//	@file Name: drawPlayerMarkers.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {};

#define IS_FRIENDLY_PLAYER(UNIT) (isPlayer UNIT && {(group UNIT == group player || (!_isIndie && side group UNIT == playerSide))})
#define DEFAULT_ICON_POS(UNIT) (UNIT modelToWorld (UNIT selectionPosition "spine3"))

if (isNil "showPlayerNames") then { showPlayerNames = false };

drawPlayerMarkers_array = [];

if (!isNil "drawPlayerMarkers_thread") then { terminate drawPlayerMarkers_thread };
drawPlayerMarkers_thread = [] spawn
{
	scriptName "drawPlayerMarkers";
	waitUntil
	{
		_newArray = [];

		_isIndie = !(playerSide in [BLUFOR,OPFOR]);
		_mapIconsEnabled = difficultyEnabled "map";

		_allUAVs = allUnitsUAV;
		_allDeadMen = allDeadMen;
		_playableUnits = playableUnits;

		reverse _allUAVs;
		reverse _allDeadMen;
		reverse _playableUnits;

		{
			_uav = _x;
			_uavOwner = (uavControl _uav) select 0;

			if (IS_FRIENDLY_PLAYER(_uavOwner) || (isNull _uavOwner && side _uav == playerSide)) then
			{
				_icon = getText (configFile >> "CfgVehicles" >> typeOf _uav >> "icon");
				if (_icon == "") then { _icon = "iconMan" };

				_color = if (group _uavOwner == group player) then { [0,1,0,1] } else { [1,1,1,1] };
				_pos = if (_mapIconsEnabled) then { DEFAULT_ICON_POS(_uav) } else { getPosASLVisual _uav };

				_newArray pushBack [_icon, _color, _pos, 24, 24, getDir _uav, "", 1]; // draw icon

				if (showPlayerNames) then
				{
					_newArray pushBack ["#(argb,1,1,1)color(0,0,0,0)", _color, _pos, 25, 25, 0, "[AI]", 2, 0.05, "PuristaMedium"]; // draw text
				};
			};
		} forEach _allUAVs;

		{
			_newUnit = _x getVariable ["newRespawnedUnit", objNull];

			if (IS_FRIENDLY_PLAYER(_x) || (_newUnit getVariable ["playerSpawning", false] && IS_FRIENDLY_PLAYER(_newUnit))) then
			{
				_veh = vehicle _x;
				_pos = if (_mapIconsEnabled) then { DEFAULT_ICON_POS(_veh) } else { getPosASLVisual _x };

				_newArray pushBack ["\A3\ui_f_curator\Data\CfgMarkers\kia_ca.paa", [0,0,0,0.6], _pos, 22, 22, 0]; // draw skull
			};
		} forEach _allDeadMen;

		{
			if (IS_FRIENDLY_PLAYER(_x) && !(_x getVariable ["playerSpawning", false])) then
			{
				_veh = vehicle _x;

				if ((crew _veh) select 0 == _x) then
				{
					_icon = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "icon");
					if (_icon == "") then { _icon = "iconMan" };

					_color = if (group _x == group player) then { [0,1,0,1] } else { [1,1,1,1] };
					_vehColor = if ({group _x == group player} count crew _veh > 0) then { [0,1,0,1] } else { _color }; // make vehicle green if group player in it
					_pos = if (_mapIconsEnabled) then { DEFAULT_ICON_POS(_veh) } else { getPosASLVisual _veh };
					_dir = if (_icon == "iconParachute") then { 0 } else { getDir _veh };

					if (_veh == _x && _x getVariable ["FAR_isUnconscious", 0] == 1) then { _vehColor = [1,0.25,0,1] }; // make icon orange if awaiting revive

					_newArray pushBack [_icon, _vehColor, _pos, 24, 24, _dir, "", 1]; // draw icon

					if (_x != player && showPlayerNames) then
					{
						_newArray pushBack ["#(argb,1,1,1)color(0,0,0,0)", _color, _pos, 25, 25, 0, name _x, 2, 0.05, "PuristaMedium"]; // draw text
					};
				};
			};
		} forEach _playableUnits;

		if (!_mapIconsEnabled) then
		{
			_veh = vehicle player;
			_newArray pushBack ["\A3\ui_f\Data\IGUI\Cfg\IslandMap\iconplayer_ca.paa", [1,0,0,1], getPosASLVisual _veh, 26, 26, getDir _veh]; // draw player circle
		};

		drawPlayerMarkers_array = _newArray;
		false
	};
};

A3W_scriptThreads pushBack drawPlayerMarkers_thread;

// Main map = findDisplay 12 displayCtrl 51
// GPS = (uiNamespace getVariable ["RscMiniMap", displayNull]) displayCtrl 101
// UAV Terminal = findDisplay 160 displayCtrl 51

disableSerialization;
private ["_display", "_mapCtrl"];

// Main map
waitUntil {_display = findDisplay 12; !isNull _display};
_mapCtrl = _display displayCtrl 51;

if (!isNil "drawPlayerMarkers_mapDraw") then { _mapCtrl ctrlRemoveEventHandler ["Draw", drawPlayerMarkers_mapDraw] };
drawPlayerMarkers_mapDraw = _mapCtrl ctrlAddEventHandler ["Draw",
{
	{ (_this select 0) drawIcon _x } forEach drawPlayerMarkers_array;
}];

// GPS
waitUntil {_display = uiNamespace getVariable ["RscMiniMap", displayNull]; !isNull _display};
_mapCtrl = _display displayCtrl 101;

if (!isNil "drawPlayerMarkers_gpsDraw") then { _mapCtrl ctrlRemoveEventHandler ["Draw", drawPlayerMarkers_gpsDraw] };
drawPlayerMarkers_gpsDraw = _mapCtrl ctrlAddEventHandler ["Draw",
{
	{ (_this select 0) drawIcon _x } forEach drawPlayerMarkers_array;
}];
