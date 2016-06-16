/* DynamicWeatherEffects.sqf version 1.01 by Engima of Ostgota Ops
 * Description:
 *   Script that generates dynamic (random) weather. Works in single player, multiplayer (hosted and dedicated), and is JIP compatible.
 * Arguments:
 *   [_initialFog]: Optional. Fog when mission starts. Must be between 0 and 1 where 0 = no fog, 1 = maximum fog. -1 = random fog.
 *   [_initialOvercast]: Optional. Overcast when mission starts. Must be between 0 and 1 where 0 = no overcast, 1 = maximum overcast. -1 = random overcast.
 *   [_initialRain]: Optional. Rain when mission starts. Must be between 0 and 1 where 0 = no rain, 1 = maximum rain. -1 = random rain. (Overcast must be greater than or equal to 0.75).
 *   [_initialWind]: Optional. Wind when mission starts. Must be an array of form [x, z], where x is one wind strength vector and z is the other. x and z must be greater than or equal to 0. [-1, -1] = random wind.
 *   [_debug]: Optional. true if debug text is to be shown, otherwise false.
 */

params [["_initialFog",-1,[0]], ["_initialOvercast",-1,[0]], ["_initialRain",-1,[0]], ["_initialWind",[],[[]]], ["_debug",false,[false]]]; 

private ["_minWeatherChangeTimeMin", "_maxWeatherChangeTimeMin", "_minTimeBetweenWeatherChangesMin", "_maxTimeBetweenWeatherChangesMin", "_rainIntervalRainProbability", "_windChangeProbability"];
private ["_minimumFog", "_maximumFog", "_minimumOvercast", "_maximumOvercast", "_minimumRain", "_maximumRain", "_minimumWind", "_maximumWind", "_minRainIntervalTimeMin", "_maxRainIntervalTimeMin", "_forceRainToStopAfterOneRainInterval", "_maxWind"];
private ["_minimumFogDecay", "_maximumFogDecay", "_minimumFogBase", "_maximumFogBase"];

#define SLEEP_REALTIME(SECS) if (hasInterface) then { sleep SECS } else { uiSleep SECS }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The following variables can be changed to tweak weather behaviour

// Minimum time in minutes for the weather (fog and overcast) to change. Must be greater than or equal to 1 and less than or equal to
// _maxWeatherChangeTimeMin. When weather changes, it is fog OR overcast that changes, not both at the same time. (Suggested value: 10).
_minWeatherChangeTimeMin = 15;

// Maximum time in minutes for the weather (fog and overcast) to change. Must be greater than or equal to _minWeatherChangeTimeMin.
// (Suggested value: 20).
_maxWeatherChangeTimeMin = 30;

// Minimum time in minutes that weather (fog and overcast) stays constant between weather changes. Must be less than or equal to 0 and
// greater than or equal to _minWeatherChangeTimeMin. (Suggested value: 5).
_minTimeBetweenWeatherChangesMin = 5;

// Maximum time in minutes that weather (fog and overcast) stays unchanged between weather changes. Must be greater than or equal to
// _minWeatherChangeTimeMin. (Suggested value: 10).
_maxTimeBetweenWeatherChangesMin = 10;

// Fog intensity never falls below this value. Must be between 0 and 1 and less than or equal to _maximumFog
// (0 = no fog, 1 = pea soup). (Suggested value: 0).
_minimumFog = 0;

// Fog intensity never exceeds this value. Must be between 0 and 1 and greater than or equal to _minimumFog
// (0 = no fog, 1 = pea soup). (Suggested value: 0.2).
_maximumFog = 0.2;

// New ArmA3 facilities added by Bewilderbeest - not currently taken into account due to engine syncing bugs and weird behavior
_minimumFogDecay = 0.0;
_maximumFogDecay = 0.0;
_minimumFogBase = 0;
_maximumFogBase = 0;

// Overcast intensity never falls below this value. Must be between 0 and 1 and less than or equal to _maximumOvercast
// (0 = no overcast, 1 = maximum overcast). (Suggested value: 0).
_minimumOvercast = 0.1;

// Overcast intensity never exceeds this value. Must be between 0 and 1 and greater than or equal to _minimumOvercast
// (0 = no overcast, 1 = maximum overcast). (Suggested value: 1).
_maximumOvercast = 1;

// When raining, rain intensity never falls below this value. Must be between 0 and 1 and less than or equal to _maximumRain
// (0 = no rain, 1 = maximum rain intensity). (Suggested value: 0.1);
_minimumRain = 0.1;

// When raining, rain intensity never exceeds this value. Must be between 0 and 1 and greater than or equal to _minimumRain
// (0 = no rain, 1 = maximum rain intensity). (Suggested value: 1);
_maximumRain = 1;

// Wind vector strength never falls below this value. Must be greater or equal to 0 and less than or equal to _maximumWind.
// (Suggested value: 0);
_minimumWind = 0;

// Wind vector strength never exceeds this value. Must be greater or equal to 0 and greater than or equal to _minimumWind.
// (Suggested value: 5).
_maximumWind = 5;

// Probability in percent for wind to change when weather changes. If set to 0 then wind will never change. If set to 100 then rain will
// change every time the weather (fog or overcast) start to change. (Suggested value: 25);
_windChangeProbability = 25;

// A "rain interval" is defined as "a time interval during which it may rain in any intensity (or it may not rain at all)". When overcast
// goes above 0.75, a chain of rain intervals (defined below) is started. It cycles on until overcast falls below 0.75. At overcast
// below 0.75 rain intervals never execute (thus it cannot rain).

// Probability in percent (0-100) for rain to start at every rain interval. Set this to 0 if you don't want rain at all. Set this to 100
// if you want it to rain constantly when overcast is greater than 0.75. In short: if you think that it generally rains to often then
// lower this value and vice versa. (Suggested value: 50).
_rainIntervalRainProbability = 0; // overcast syncing fubar, do not enable rain

// Minimum time in minutes for rain intervals. Must be greater or equal to 0 and less than or equal to _maxRainIntervalTimeMin.
// (Suggested value: 0).
_minRainIntervalTimeMin = 1;

// Maximum time in minutes for rain intervals. Must be greater than or equal to _minRainIntervalTimeMin. (Suggested value:
// (_maxWeatherChangeTimeMin + _maxTimeBetweenWeatherChangesMin) / 2).
_maxRainIntervalTimeMin = (_maxWeatherChangeTimeMin + _maxTimeBetweenWeatherChangesMin) / 2;

// If set to true, then the rain is forced to stop after one rain interval during which it has rained (use this for example if you only want
// small occational cloudbursts ). If set to false, then the rain may stop, but it may also just change intensity for an
// immedeate new rain interval. (Suggested value: false).
_forceRainToStopAfterOneRainInterval = false;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Don't touch anything beneath this line

drn_DynamicWeather_minFog = _minimumFog;
drn_DynamicWeather_maxFog = _maximumFog;
drn_DynamicWeather_DebugTextEventArgs = []; // Empty

"drn_DynamicWeather_DebugTextEventArgs" addPublicVariableEventHandler {
	drn_DynamicWeather_DebugTextEventArgs call drn_fnc_DynamicWeather_ShowDebugTextLocal;
};

/*
 * Summary: Shows debug text on local client.
 * Arguments:
 *   _text: Debug text.
 */
drn_fnc_DynamicWeather_ShowDebugTextLocal = {
	private ["_minutes", "_seconds"];

	if (!isNull player) then {
		player sideChat (_this select 0);
	};

	_minutes = floor (diag_tickTime / 60);
	_seconds = floor (diag_tickTime - (_minutes * 60));
	diag_log ((str _minutes + ":" + str _seconds) + " Debug: " + (_this select 0));
};

/*
 * Summary: Shows debug text on all clients.
 * Arguments:
 *   _text: Debug text.
 */
drn_fnc_DynamicWeather_ShowDebugTextAllClients = {
	drn_DynamicWeather_DebugTextEventArgs = _this;
	publicVariable "drn_DynamicWeather_DebugTextEventArgs";
	drn_DynamicWeather_DebugTextEventArgs call drn_fnc_DynamicWeather_ShowDebugTextLocal;
};

if (_debug) then {
	["Starting script WeatherEffects.sqf..."] call drn_fnc_DynamicWeather_ShowDebugTextLocal;
};

drn_DynamicWeatherEventArgs = []; // [current overcast, current fog, current rain, current weather change ("OVERCAST", "FOG" or ""), target weather value, time until weather completion (in seconds), current wind x, current wind z]
drn_AskServerDynamicWeatherEventArgs = [];

drn_fnc_overcastOdds = { ((9/8) * (_this ^ (5/2))) min 1 }; // https://www.desmos.com/calculator/sp7zsxckhn
drn_fnc_fogOdds =
{
	params ["_currFog", "_maxFog"];

	if (_maxFog <= 0) exitWith {0};

	private _fogVal = _currFog / _maxFog;
	_fogVal call drn_fnc_overcastOdds
};

drn_fnc_DynamicWeather_SetWeatherLocal = {
	params ["_currentOvercast", "_currentFog", "_currentRain", "_currentWeatherChange", "_targetWeatherValue", "_timeUntilCompletion", "_currentWindX", "_currentWindY"];

	_currentRain = drn_var_DynamicWeather_Rain;

	if (_currentFog isEqualType []) then {
		_currentFog = _currentFog select 0;
	};

	/*if (typeName _currentFog == "ARRAY") then {
		_currentFog set [0, (_currentFog select 0) max (_currentRain / 4)];
	}
	else {*/
		_currentFog = (drn_DynamicWeather_minFog max _currentFog min drn_DynamicWeather_maxFog) max (_currentRain / 4);
	//};

	// Set current weather values
	if (_currentWeatherChange != "OVERCAST") then { 0 setOvercast _currentOvercast };
	0 setFog [_currentFog, 0.0, 0]; // do not change fog decay/base otherwise the fog level will vary unpredictably
	//drn_var_DynamicWeather_Rain = _currentRain;
	setWind [_currentWindX, _currentWindY, true];

	if (isNil "drn_JIPWeatherSynced") then
	{
		forceWeatherChange;
		simulWeatherSync;
		drn_JIPWeatherSynced = true;
	};

	// Set forecast
	if (_currentWeatherChange == "OVERCAST") then {
		_timeUntilCompletion setOvercast (_targetWeatherValue call drn_fnc_overcastOdds);
		//5 setFog [_currentRain / 4, 0.0, 0]; // do not change fog decay/base otherwise the fog level will vary unpredictably // Quick hack to ensure fog goes away regularly
	};
	if (_currentWeatherChange == "FOG") then {
		if (typeName _targetWeatherValue == "ARRAY") then {
			_targetWeatherValue = _targetWeatherValue select 0;
		};
		(3600 * timeMultiplier * abs (overcast - _currentOvercast)) setOvercast _currentOvercast;
		_timeUntilCompletion setFog [_targetWeatherValue max (_currentRain / 4), 0.0, 0]; // do not change fog decay/base otherwise the fog level will vary unpredictably
	};
};

if (!isServer) then {
	"drn_DynamicWeatherEventArgs" addPublicVariableEventHandler {
		drn_DynamicWeatherEventArgs spawn drn_fnc_DynamicWeather_SetWeatherLocal;
	};

	waitUntil {!isNil "drn_var_DynamicWeather_ServerInitialized"};

	drn_AskServerDynamicWeatherEventArgs = []; //[clientOwner];
	publicVariable "drn_AskServerDynamicWeatherEventArgs";
};

if (isServer) then {
	drn_fnc_DynamicWeather_SetWeatherAllClients = {
		params [["_owner",0,[0]]];
		private ["_timeUntilCompletion", "_currentWeatherChange"];

		_timeUntilCompletion = (drn_DynamicWeather_WeatherChangeCompletedTime - drn_DynamicWeather_WeatherChangeStartedTime) * timeMultiplier;
		if (_timeUntilCompletion > 0) then {
			_currentWeatherChange = drn_DynamicWeather_CurrentWeatherChange;
		}
		else {
			_currentWeatherChange = "";
		};

		drn_DynamicWeatherEventArgs = [overcast, fog, drn_var_DynamicWeather_Rain, _currentWeatherChange, drn_DynamicWeather_WeatherTargetValue, _timeUntilCompletion, drn_DynamicWeather_WindX, drn_DynamicWeather_WindY];

		if (_owner > 0) then
		{
			_owner publicVariableClient "drn_DynamicWeatherEventArgs";
		}
		else
		{
			publicVariable "drn_DynamicWeatherEventArgs";
		};

		drn_DynamicWeatherEventArgs spawn drn_fnc_DynamicWeather_SetWeatherLocal;
	};

	drn_DynamicWeather_CurrentWeatherChange = "";
	drn_DynamicWeather_WeatherTargetValue = 0;
	drn_DynamicWeather_WeatherChangeStartedTime = diag_tickTime;
	drn_DynamicWeather_WeatherChangeCompletedTime = diag_tickTime;
	drn_DynamicWeather_WindX = _initialWind param [0, nil, [0]];
	drn_DynamicWeather_WindY = _initialWind param [1, nil, [0]];

	"drn_AskServerDynamicWeatherEventArgs" addPublicVariableEventHandler {
		(_this select 1) spawn drn_fnc_DynamicWeather_SetWeatherAllClients;
	};

	if (_initialFog == -1) then {
		_initialFog = _minimumFog + random (_maximumFog - _minimumFog);
		_initialFog = ([_initialFog, _maximumFog] call drn_fnc_fogOdds) * _maximumFog;
	}
	else {
		_initialFog = _minimumFog max _initialFog min _maximumFog;
	};

	//0 setFog [_initialFog max (rain / 4), 0.0, 0]; // do not change fog decay/base otherwise the fog level will vary unpredictably

	if (_initialOvercast == -1) then {
		_initialOvercast = _minimumOvercast + random (_maximumOvercast - _minimumOvercast);
		_initialOvercast = _initialOvercast call drn_fnc_overcastOdds;
	}
	else {
		_initialOvercast = _minimumOvercast max _initialOvercast min _maximumOvercast;
	};

	0 setOvercast _initialOvercast;

	private _keepRain = false;

	if (_initialOvercast >= 0.75) then {
		if (_initialRain == -1 || _rainIntervalRainProbability <= 0) then {
			_initialRain = 0; //_minimumRain + random (_minimumRain - _minimumRain); // drn_DynamicWeather_RainThread will override the value anyway, so we keep it at 0
		}
		else {
			_initialRain = _minimumRain max _initialRain min _maximumRain;
			_keepRain = true; // force drn_DynamicWeather_RainThread to wait one cycle after mission start
		};
	}
	else {
		_initialRain = 0;
	};

	drn_var_DynamicWeather_Rain = _initialRain;
	0 setRain _initialRain;
	0 setFog [_initialFog max (_initialRain / 4), 0.0, 0]; // do not change fog decay/base otherwise the fog level will vary unpredictably


	if (isNil "drn_DynamicWeather_WindX") then {
		drn_DynamicWeather_WindX = (_minimumWind + random (_maximumWind - _minimumWind)) * (1 - 2 * round random 1);
	} else {
		drn_DynamicWeather_WindX = -_maximumWind max drn_DynamicWeather_WindX min _maximumWind;
	};

	if (isNil "drn_DynamicWeather_WindY") then {
		drn_DynamicWeather_WindY = (_minimumWind + random (_maximumWind - _minimumWind)) * (1 - 2 * round random 1);
	} else {
		drn_DynamicWeather_WindY = -_maximumWind max drn_DynamicWeather_WindY min _maximumWind;
	};

	setWind [drn_DynamicWeather_WindX, drn_DynamicWeather_WindY, true];

	forceWeatherChange;

	sleep 0.05;

	publicVariable "drn_var_DynamicWeather_Rain";
	drn_var_DynamicWeather_ServerInitialized = true;
	publicVariable "drn_var_DynamicWeather_ServerInitialized";

	// Start weather thread
	if (!isNil "drn_DynamicWeather_WeatherThread") then { terminate drn_DynamicWeather_WeatherThread };
	drn_DynamicWeather_WeatherThread = [_minWeatherChangeTimeMin, _maxWeatherChangeTimeMin, _minTimeBetweenWeatherChangesMin, _maxTimeBetweenWeatherChangesMin, _minimumFog, _maximumFog, _minimumFogDecay, _maximumFogDecay, _minimumFogBase, _maximumFogBase, _minimumOvercast, _maximumOvercast, _minimumWind, _maximumWind, _windChangeProbability, _debug] spawn
	{
		params ["_minWeatherChangeTimeMin", "_maxWeatherChangeTimeMin", "_minTimeBetweenWeatherChangesMin", "_maxTimeBetweenWeatherChangesMin", "_minimumFog", "_maximumFog", "_minimumFogDecay", "_maximumFogDecay", "_minimumFogBase", "_maximumFogBase", "_minimumOvercast", "_maximumOvercast", "_minimumWind", "_maximumWind", "_windChangeProbability", "_debug"];
		private ["_weatherType", "_fogLevel", "_overcastLevel", "_oldFogLevel", "_oldOvercastLevel", "_weatherChangeTimeSek", "_fogValue", "_fogBase", "_fogDecay"];

		// Set initial fog level
		_fogLevel = 2;
		_overcastLevel = 2;

		while {true} do {
			// Sleep a while until next weather change
			sleep floor (_minTimeBetweenWeatherChangesMin * 60 + random ((_maxTimeBetweenWeatherChangesMin - _minTimeBetweenWeatherChangesMin) * 60));

			if (_minimumFog == _maximumFog && _minimumOvercast != _maximumOvercast) then {
				_weatherType = "OVERCAST";
			};
			if (_minimumFog != _maximumFog && _minimumOvercast == _maximumOvercast) then {
				_weatherType = "FOG";
			};
			if (_minimumFog != _maximumFog && _minimumOvercast != _maximumOvercast) then {

				// Select type of weather to change
				_weatherType = ["OVERCAST","FOG"] call BIS_fnc_selectRandom;
			};

			// DEBUG
			//_weatherType = "OVERCAST";

			if (_weatherType == "FOG") then {

				drn_DynamicWeather_CurrentWeatherChange = "FOG";

				// Select a new fog level
				_oldFogLevel = _fogLevel;
				_fogLevel = ([0,1,2,3] - [_oldFogLevel]) call BIS_fnc_selectRandom;

				_fogValue = switch (_fogLevel) do
				{
					case 1: { _minimumFog + (_maximumFog - _minimumFog) * (0.05 + random 0.2) };
					case 2: { _minimumFog + (_maximumFog - _minimumFog) * (0.25 + random 0.3) };
					case 3: { _minimumFog + (_maximumFog - _minimumFog) * (0.55 + random 0.45) };
					default { _minimumFog + (_maximumFog - _minimumFog) * random 0.05 };
				};

				_fogValue = ([_fogValue, _maximumFog] call drn_fnc_fogOdds) * _maximumFog;

				_fogDecay = _minimumFogDecay + (_maximumFogDecay - _minimumFogDecay) * random 1;
				_fogBase = _minimumFogBase + (_maximumFogBase - _minimumFogBase) * random 1;

				drn_DynamicWeather_WeatherTargetValue = [_fogValue, 0.0, 0]; //_fogDecay, _fogBase];

				drn_DynamicWeather_WeatherChangeStartedTime = diag_tickTime;
				_weatherChangeTimeSek = _minWeatherChangeTimeMin * 60 + random ((_maxWeatherChangeTimeMin - _minWeatherChangeTimeMin) * 60);
				drn_DynamicWeather_WeatherChangeCompletedTime = diag_tickTime + _weatherChangeTimeSek;

				if (_debug) then {
					["Weather forecast: Fog " + str drn_DynamicWeather_WeatherTargetValue + " in " + str round (_weatherChangeTimeSek / 60) + " minutes."] call drn_fnc_DynamicWeather_ShowDebugTextAllClients;
				};
			};

			if (_weatherType == "OVERCAST") then {

				drn_DynamicWeather_CurrentWeatherChange = "OVERCAST";

				// Select a new overcast level
				_oldOvercastLevel = _overcastLevel;
				//_overcastLevel = floor ((random 100) / 25);
				_overcastLevel = 3;

				if (_overcastLevel == _oldOvercastLevel) then {
					_overcastLevel = ([0,1,2,3] - [_oldOvercastLevel]) call BIS_fnc_selectRandom;
				};

				drn_DynamicWeather_WeatherTargetValue = switch (_overcastLevel) do
				{
					case 1: { _minimumOvercast + (_maximumOvercast - _minimumOvercast) * (0.05 + random 0.3) };
					case 2: { _minimumOvercast + (_maximumOvercast - _minimumOvercast) * (0.35 + random 0.35) };
					case 3: { _minimumOvercast + (_maximumOvercast - _minimumOvercast) * (0.7 + random 0.3) };
					default { _minimumOvercast + (_maximumOvercast - _minimumOvercast) * random 0.05 };
				};

				// DEBUG
				/*
				if (overcast > 0.8) then {
					drn_DynamicWeather_WeatherTargetValue = 0.5;
				}
				else {
					drn_DynamicWeather_WeatherTargetValue = 0.85;
				};
				*/

				drn_DynamicWeather_WeatherChangeStartedTime = diag_tickTime;
				_weatherChangeTimeSek = _minWeatherChangeTimeMin * 60 + random ((_maxWeatherChangeTimeMin - _minWeatherChangeTimeMin) * 60);
				drn_DynamicWeather_WeatherChangeCompletedTime = diag_tickTime + _weatherChangeTimeSek;

				if (_debug) then {
					["Weather forecast: Overcast " + str drn_DynamicWeather_WeatherTargetValue + " in " + str round (_weatherChangeTimeSek / 60) + " minutes."] call drn_fnc_DynamicWeather_ShowDebugTextAllClients;
				};
			};

			// On average every one fourth of weather changes, change wind too
			if (random 100 < _windChangeProbability) then
			{
				drn_DynamicWeather_WindX = (_minimumWind + random (_maximumWind - _minimumWind)) * (1 - 2 * round random 1);
				drn_DynamicWeather_WindY = (_minimumWind + random (_maximumWind - _minimumWind)) * (1 - 2 * round random 1);

				if (_debug) then {
					["Wind changes: [" + str drn_DynamicWeather_WindX + ", " + str drn_DynamicWeather_WindY + "]."] call drn_fnc_DynamicWeather_ShowDebugTextAllClients;
				};
			};

			[] call drn_fnc_DynamicWeather_SetWeatherAllClients;

			SLEEP_REALTIME(_weatherChangeTimeSek);
		};
	};

	// Start rain thread
	if (_rainIntervalRainProbability > 0) then {
		if (!isNil "drn_DynamicWeather_RainThread") then { terminate drn_DynamicWeather_RainThread };
		drn_DynamicWeather_RainThread = [_minimumRain, _maximumRain, _forceRainToStopAfterOneRainInterval, _minRainIntervalTimeMin, _maxRainIntervalTimeMin, _rainIntervalRainProbability, _keepRain, _debug] spawn
		{
			params ["_minimumRain", "_maximumRain", "_forceRainToStopAfterOneRainInterval", "_minRainIntervalTimeMin", "_maxRainIntervalTimeMin", "_rainIntervalRainProbability", "_keepRain", "_debug"];
			private ["_nextRainEventTime", "_forceStop", "_rainTimeSec"];

			if (rain > 0) then {
				drn_var_DynamicWeather_Rain = rain;
				publicVariable "drn_var_DynamicWeather_Rain";
			};

			_nextRainEventTime = diag_tickTime;
			_forceStop = false;

			if (_keepRain) then
			{
				_rainTimeSec = _minRainIntervalTimeMin * 60 + random ((_maxRainIntervalTimeMin - _minRainIntervalTimeMin) * 60);
				_nextRainEventTime = _nextRainEventTime + _rainTimeSec;
			};

			while {true} do {

				if (overcast >= 0.75) then {

					if (diag_tickTime >= _nextRainEventTime) then {

						// At every rain event time, start or stop rain with 50% probability
						if (random 100 < _rainIntervalRainProbability && !_forceStop) then {
							drn_var_DynamicWeather_rain = _minimumRain + random (_maximumRain - _minimumRain);
							publicVariable "drn_var_DynamicWeather_rain";

							_forceStop = _forceRainToStopAfterOneRainInterval;
						}
						else {
							drn_var_DynamicWeather_rain = 0;
							publicVariable "drn_var_DynamicWeather_rain";

							_forceStop = false;
						};

						// Pick a time for next rain change
						_rainTimeSec = _minRainIntervalTimeMin * 60 + random ((_maxRainIntervalTimeMin - _minRainIntervalTimeMin) * 60);
						_nextRainEventTime = diag_tickTime + _rainTimeSec;

						if (_debug) then {
							["Rain set to " + str drn_var_DynamicWeather_rain + " for " + str (_rainTimeSec / 60) + " minutes"] call drn_fnc_DynamicWeather_ShowDebugTextAllClients;
						};
					};
				}
				else {
					if (drn_var_DynamicWeather_rain != 0) then {
						drn_var_DynamicWeather_rain = 0;
						publicVariable "drn_var_DynamicWeather_rain";

						if (_debug) then {
							["Rain stops due to low overcast."] call drn_fnc_DynamicWeather_ShowDebugTextAllClients;
						};
					};

					_nextRainEventTime = diag_tickTime;
					_forceStop = false;
				};

				if (_debug) then {
					sleep 1;
				}
				else {
					SLEEP_REALTIME(20);
				};
			};
		};
	};
};

// is actually rain thread (#2)
if (!isNil "drn_DynamicWeather_FogThread") then { terminate drn_DynamicWeather_FogThread };
drn_DynamicWeather_FogThread = [_rainIntervalRainProbability, _debug] spawn
{
	params ["_rainIntervalRainProbability", "_debug"];
	private ["_rain", "_rainPerSecond"];

	if (_debug) then {
		_rainPerSecond = 0.2;
	}
	else {
		_rainPerSecond = 0.03;
	};

	if (_rainIntervalRainProbability > 0) then {
		_rain = 0 max drn_var_DynamicWeather_Rain min 1;
	}
	else {
		_rain = 0;
	};

	//0 setRain _rain;
	//0 setFog [fog max (_rain / 4), 0.0, 0]; // do not change fog decay/base otherwise the fog level will vary unpredictably
	sleep 0.1;

	while {true} do {
		/*if (_rainIntervalRainProbability > 0) then {
			if (_rain < drn_var_DynamicWeather_Rain) then {
				_rain = _rain + _rainPerSecond;
				if (_rain > 1) then { _rain = 1; };
			};
			if (_rain > drn_var_DynamicWeather_Rain) then {
				_rain = _rain - _rainPerSecond;
				if (_rain < 0) then { _rain = 0; };
			};
		}
		else {
			_rain = 0;
		};*/

		_rain = drn_var_DynamicWeather_Rain;

		if (round (rain * 100) != round (_rain * 100) || round (fog * 100) < round ((rain / 4) * 100)) then
		{
			if (overcast >= 0.75) then
			{
				10 setRain _rain;

				if (fog < _rain / 4) then
				{
					10 setFog [_rain / 4, 0.0, 0]; // do not change fog decay/base otherwise the fog level will vary unpredictably
				};
			}
			else
			{
				if (rain > 0) then
				{
					10 setRain 0;
					drn_var_DynamicWeather_Rain = 0;
					drn_DynamicWeatherEventArgs call drn_fnc_DynamicWeather_SetWeatherLocal;
				};
			};
		};

		/*_tempFog = fog max (_rain / 4);
		if (_tempFog > fog + 0.001 || _tempFog < fog - 0.001) then
		{
			(10 * timeMultiplier) setFog [_tempFog, 0.0, 0]; // do not change fog decay/base otherwise the fog level will vary unpredictably
		};*/

		SLEEP_REALTIME(10);
	};
};
