// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: playerHud.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, [KoS] Bewilderbeest
//	@file Created: 11/09/2012 04:23
//	@file Args:

#define hud_status_idc 3600
#define hud_vehicle_idc 3601
#define hud_activity_icon_idc 3602
#define hud_activity_textbox_idc 3603

scriptName "playerHud";

disableSerialization;
private ["_lastHealthReading", "_lastTerritoryName", "_lastTerritoryDescriptiveName", "_territoryCaptureIcon", "_activityIconOrigPos", "_activityTextboxOrigPos", "_dispUnitInfo", "_topLeftBox", "_topLeftBoxPos"];

_lastHealthReading = 100; // Used to flash the health reading when it changes

// Needed for territory system
_lastTerritoryName = "";
_lastTerritoryDescriptiveName = "";

_displayTerritoryActivity =
{
	private ['_boldFont', '_descriptiveName', '_configEntry', '_territoryActionText', '_territoryAction', '_seconds', '_minutes'];

	_boldFont = "PuristaBold";

	_descriptiveName = "Unknown territory";

	// Expensive lookup for the HUD, so cache it
	if (_territoryName != _lastTerritoryName) then
	{
		// Look up the descriptive name of this territory
		_configEntry = [["config_territory_markers", []] call getPublicVar, { _x select 0 == _territoryName }] call BIS_fnc_conditionalSelect;
		_descriptiveName = (_configEntry select 0) select 1;
		_lastTerritoryName = _territoryName;
		_lastTerritoryDescriptiveName = _descriptiveName;
	}
	else
	{
		_descriptiveName = _lastTerritoryDescriptiveName;
	};

	_territoryActionText = "";
	_territoryAction = _territoryActivity select 0;

	switch (_territoryAction) do
	{
		case "CAPTURE":
		{
			_territoryCaptureCountdown = round (_territoryActivity select 1);

			if (_territoryCaptureCountdown > 60) then
			{
				_seconds = _territoryCaptureCountdown % 60;
				_territoryCaptureCountdown = (_territoryCaptureCountdown - _seconds) / 60;
				_minutes = _territoryCaptureCountdown % 60;

				_territoryActionText = format["Capturing territory in about <t font='%1'>%2 minutes</t>", _boldFont, _minutes + 1];
			}
			else
			{
				if (_territoryCaptureCountdown < 5) then
				{
					_territoryActionText = "Territory transition in progress...";
				}
				else
				{
					_territoryActionText = format["Capturing territory in <t font='%1'>%2 seconds</t>", _boldFont, _territoryCaptureCountdown];
				};
			};
		};
		case "BLOCKEDATTACKER": { _territoryActionText = "Territory capture blocked" };
		case "BLOCKEDDEFENDER": { _territoryActionText = "Territory under attack" };
		case "RESET":           { _territoryActionText = "Territory capture started" };
	};

	_activityMessage = format ["Location: <t font='%1'>%2</t><br/>%3", _boldFont, _descriptiveName, _territoryActionText];
	_topLeftIconText = format ["<img size='%1' image='territory\client\icons\territory_cap_white.paa'/>", 3 * (0.55 / (getResolution select 5))];

	[_topLeftIconText, _activityMessage]
};

_unlimitedStamina = ["A3W_unlimitedStamina"] call isConfigOn;
_atmEnabled = ["A3W_atmEnabled"] call isConfigOn;

private ["_globalVoiceTimer", "_globalVoiceWarnTimer", "_globalVoiceWarning", "_globalVoiceMaxWarns", "_globalVoiceTimestamp"];

_globalVoiceTimer = 0;
_globalVoiceWarnTimer = ["A3W_globalVoiceWarnTimer", 5] call getPublicVar;
_globalVoiceWarning = 0;
_globalVoiceMaxWarns = ceil (["A3W_globalVoiceMaxWarns", 5] call getPublicVar);

private ["_mapCtrls", "_mapCtrl"];

while {true} do
{
	private ["_ui","_vitals","_hudVehicle","_health","_tempString","_yOffset","_vehicle"];

	1000 cutRsc ["WastelandHud","PLAIN",1e10];
	_ui = uiNameSpace getVariable "WastelandHud";
	_vitals = _ui displayCtrl hud_status_idc;
	_hudVehicle = _ui displayCtrl hud_vehicle_idc;
	_hudActivityIcon = _ui displayCtrl hud_activity_icon_idc;
	_hudActivityTextbox = _ui displayCtrl hud_activity_textbox_idc;

	//Calculate Health 0 - 100
	_health = ((1 - damage player) * 100) max 0;
	_health = if (_health > 1) then { floor _health } else { ceil _health };

	// Flash the health colour on the HUD according to it going up, down or the same
	_healthTextColor = "#FFFFFF";

	if (_health != _lastHealthReading) then
	{
		// Health change. Up or down?
		if (_health < _lastHealthReading) then
		{
			// Gone down. Red flash
			_healthTextColor = "#FF1717";
		}
		else
		{
			// Gone up. Green flash
			_healthTextColor = "#17FF17";
		};
	};

	// Make sure we keep a record of the health value from this iteration
	_lastHealthReading = _health;

	// Icons in bottom right

	_minimumBRs = 5;
	_strArray = [];

	if (_atmEnabled) then { _strArray pushBack format ["%1 <img size='0.7' image='client\icons\suatmm_icon.paa'/>", [player getVariable ["bmoney", 0]] call fn_numbersText] };
	_strArray pushBack format ["%1 <img size='0.7' image='client\icons\money.paa'/>", [player getVariable ["cmoney", 0]] call fn_numbersText];
	_strArray pushBack format ["%1 <img size='0.7' image='client\icons\water.paa'/>", ceil (thirstLevel max 0)];
	_strArray pushBack format ["%1 <img size='0.7' image='client\icons\food.paa'/>", ceil (hungerLevel max 0)];
	if (!_unlimitedStamina) then { _strArray pushBack format ["%1 <img size='0.7' image='client\icons\running_man.paa'/>", 100 - ceil ((getFatigue player) * 100)] };
	_strArray pushBack format ["<t color='%1'>%2</t> <img size='0.7' image='client\icons\health.paa'/>", _healthTextColor, _health];

	_str = "";

	for "_i" from 0 to (_minimumBRs - count _strArray) do
	{
		_str = _str + "<br/>";
	};

	{
		_str = _str + format ["%1%2", if (_forEachIndex > 0) then { "<br/>" } else { "" }, _x];
	} forEach _strArray;

	_vitals ctrlShow alive player;
	_vitals ctrlSetStructuredText parseText _str;
	_vitals ctrlCommit 0;

	_tempString = "";
	_yOffset = 0.26;

	if (isStreamFriendlyUIEnabled) then
	{
		_tempString = format ["<t color='#A0FFFFFF'>A3Wasteland %1<br/>www.a3wasteland.com</t>", getText (configFile >> "CfgWorlds" >> worldName >> "description")];
		_yOffset = 0.28;

		_hudVehicle ctrlSetStructuredText parseText _tempString;

		_x = safeZoneX + (safeZoneW * (1 - (0.42 / SafeZoneW)));
		_y = safeZoneY + (safeZoneH * (1 - (_yOffset / SafeZoneH)));
		_hudVehicle ctrlSetPosition [_x, _y, 0.4, 0.65];
	}
	else
	{
		if (player != vehicle player) then
		{
			_yOffset = 0.24;
			_vehicle = assignedVehicle player;

			{
				_icon = switch (true) do
				{
					case (driver _vehicle == _x): { "client\icons\driver.paa" };
					case (gunner _vehicle == _x): { "client\icons\gunner.paa" };
					default                       { "client\icons\cargo.paa" };
				};

				_tempString = format ["%1 %2 <img image='%3'/><br/>", _tempString, name _x, _icon];
				_yOffset = _yOffset + 0.04;
			} forEach crew _vehicle;
		};
	};

	_hudVehicle ctrlSetStructuredText parseText _tempString;
	_x = safeZoneX + (safeZoneW * (1 - (0.42 / SafeZoneW)));
	_y = safeZoneY + (safeZoneH * (1 - (_yOffset / SafeZoneH)));
	_hudVehicle ctrlSetPosition [_x, _y, 0.4, 0.65];
	_hudVehicle ctrlCommit 0;

	// Territory system! Uses two new boxes in the top left of the HUD. We
	// can extend the system later to encompas other activities
	//
	// This does nothing if the system is not enabled, as TERRITORY_ACTIVITY is never set
	_activityIconStr = "";
	_activityMessage = "";
	_activityBackgroundAlpha = 0;

	// Activity does not show when the map or Esc menu is open
	if (!visibleMap && isNull findDisplay 49) then
	{
		// Determine activity. Currently this is territory cap only
		_territoryActivity = player getVariable ["TERRITORY_ACTIVITY", []];
		_territoryName = player getVariable ["TERRITORY_OCCUPATION", ""];

		if (count _territoryActivity > 0 && _territoryName != "") then
		{
			_activityDetails = [] call _displayTerritoryActivity;

			_activityIconStr = _activityDetails select 0;
			_activityMessage = _activityDetails select 1;
		};

		// Show the UI if we have activity
		if (_activityIconStr != "" && _activityMessage != "") then
		{
			if (isNil "_activityIconOrigPos" && isNil "_activityTextboxOrigPos") then
			{
				_activityIconOrigPos = ctrlPosition _hudActivityIcon;
				_activityTextboxOrigPos = ctrlPosition _hudActivityTextbox;
			};

			_activityBackgroundAlpha = 0.4;

			_dispUnitInfo = uiNamespace getVariable ["RscUnitInfo", displayNull];
			_topLeftBox = _dispUnitInfo displayCtrl 113;

			// If top left vehicle info box is displayed, move activity controls a bit to the right
			if (ctrlShown _topLeftBox) then
			{
				_topLeftBoxPos = ctrlPosition _topLeftBox;

				_hudActivityIcon ctrlSetPosition
				[
					(_activityIconOrigPos select 0) + (_topLeftBoxPos select 2) + (0.015 * (safezoneW min safezoneH)),
					_activityIconOrigPos select 1,
					_activityIconOrigPos select 2,
					_activityIconOrigPos select 3
				];

				_hudActivityTextbox ctrlSetPosition
				[
					(_activityTextboxOrigPos select 0) + (_topLeftBoxPos select 2) + (0.015 * (safezoneW min safezoneH)),
					_activityTextboxOrigPos select 1,
					_activityTextboxOrigPos select 2,
					_activityTextboxOrigPos select 3
				];
			}
			else
			{
				_hudActivityIcon ctrlSetPosition _activityIconOrigPos;
				_hudActivityTextbox ctrlSetPosition _activityTextboxOrigPos;
			};
		};
	};

	_hudActivityIcon ctrlSetBackgroundColor [0, 0, 0, _activityBackgroundAlpha];
	_hudActivityIcon ctrlSetStructuredText parseText _activityIconStr;
	_hudActivityIcon ctrlCommit 0;

	_hudActivityTextbox ctrlSetBackgroundColor [0, 0, 0, _activityBackgroundAlpha];
	_hudActivityTextbox ctrlSetStructuredText parseText _activityMessage;
	_hudActivityTextbox ctrlCommit 0;

	// Remove unrealistic blur effects
	if (!isNil "BIS_fnc_feedback_damageBlur" && {ppEffectCommitted BIS_fnc_feedback_damageBlur}) then { ppEffectDestroy BIS_fnc_feedback_damageBlur };
	if (!isNil "BIS_fnc_feedback_fatigueBlur" && {ppEffectCommitted BIS_fnc_feedback_fatigueBlur}) then { ppEffectDestroy BIS_fnc_feedback_fatigueBlur };

	// Global voice warning system
	if (_globalVoiceWarnTimer > 0 && _globalVoiceMaxWarns > 0) then
	{
		if (!isNull findDisplay 55 && ctrlText (findDisplay 63 displayCtrl 101) == localize "str_channel_global") then
		{
			if (isNil "_globalVoiceTimestamp") then
			{
				_globalVoiceTimestamp = diag_tickTime;
			}
			else
			{
				_globalVoiceTimer = _globalVoiceTimer + (diag_tickTime - _globalVoiceTimestamp);

				if (_globalVoiceTimer >= _globalVoiceWarnTimer) then
				{
					_globalVoiceWarning = _globalVoiceWarning + 1;
					_globalVoiceTimestamp = diag_tickTime;
					_globalVoiceTimer = 0;

					_msgTitle = format ["Warning %1 of %2", _globalVoiceWarning, _globalVoiceMaxWarns];

					if (_globalVoiceWarning < _globalVoiceMaxWarns) then
					{
						uiNamespace setVariable ["BIS_fnc_guiMessage_status", false];
						["Please stop using the global voice channel, or you will be killed and crashed.", _msgTitle] spawn BIS_fnc_guiMessage;
					}
					else
					{
						_globalVoiceTimestamp = 1e11;
						_msgTitle spawn
						{
							setPlayerRespawnTime 1e11;
							player setDamage 1;
							uiNamespace setVariable ["BIS_fnc_guiMessage_status", false];
							_msgBox = ["You have exceeded the tolerance limit for using the global voice channel. Goodbye.", _this] spawn BIS_fnc_guiMessage;
							_time = diag_tickTime;
							waitUntil {scriptDone _msgBox || diag_tickTime - _time >= 5};
							preprocessFile "client\functions\quit.sqf"; // CTD
						};
					};
				};
			};
		}
		else
		{
			_globalVoiceTimestamp = nil;
		};
	};

	if (isNil "_mapCtrls") then
	{
		_mapCtrls =
		[
			[{(uiNamespace getVariable ["RscDisplayAVTerminal", displayNull]) displayCtrl 51}, controlNull]/*, // UAV Terminal
			[{artilleryComputerDisplayGoesHere displayCtrl 500}, controlNull]*/  // Artillery computer - cannot be enabled until this issue is resolved: http://feedback.arma3.com/view.php?id=21546
		];
	};

	if (!isNil "A3W_mapDraw_eventCode") then
	{
		// Add custom markers and lines to misc map controls
		{
			if (isNull (_x select 1)) then
			{
				_mapCtrl = call (_x select 0);

				if (!isNull _mapCtrl) then
				{
					_mapCtrl ctrlAddEventHandler ["Draw", A3W_mapDraw_eventCode];
					_x set [1, _mapCtrl];
				};
			};
		} forEach _mapCtrls;
	};

	uiSleep 1;
};
