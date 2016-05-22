// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: tLoad.sqf
//	@file Author: AgentRev

private ["_time", "_dayTime", "_date"];
_time = call compile preprocessFileLineNumbers ("persistence\server\world\" + call A3W_savingMethodDir + "\getTime.sqf");

if (["A3W_timeSaving"] call isConfigOn) then
{
	_dayTime = _time param [0, dayTime, [0]];
	_date = date;
	_date set [3, 0];
	_date set [4, _dayTime * 60];

	setDate _date;

	currentDate = date;
	publicVariable "currentDate";

	A3W_timeSavingInitDone = compileFinal 'true';
	publicVariable "A3W_timeSavingInitDone";
};

if (["A3W_weatherSaving"] call isConfigOn) then 
{
	if (!isNil "drn_DynamicWeather_MainThread") then { terminate drn_DynamicWeather_MainThread };
	if (!isNil "drn_DynamicWeather_WeatherThread") then { terminate drn_DynamicWeather_WeatherThread };
	if (!isNil "drn_DynamicWeather_RainThread") then { terminate drn_DynamicWeather_RainThread };
	if (!isNil "drn_DynamicWeather_FogThread") then { terminate drn_DynamicWeather_FogThread };

	drn_JIPWeatherSynced = nil;
	publicVariable "drn_JIPWeatherSynced";

	drn_DynamicWeather_MainThread = (_time select [1,4]) execVM "addons\scripts\DynamicWeatherEffects.sqf";
};
