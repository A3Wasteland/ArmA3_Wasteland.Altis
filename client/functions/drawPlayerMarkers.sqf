// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: drawPlayerMarkers.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {};

#define IS_FRIENDLY_PLAYER(UNIT) (isPlayer UNIT && [UNIT, player] call A3W_fnc_isFriendly)
#define DEFAULT_ICON_POS(UNIT) (UNIT modelToWorld (UNIT selectionPosition "spine3"))
#define MISSION_AI_FAR_DISTANCE 75

disableSerialization;

if (isNil "showPlayerNames") then { showPlayerNames = false };

A3W_mapDraw_arrIcons = [];
A3W_mapDraw_arrLines = [];
A3W_mapDraw_eventCode =
{
	_mapCtrl = _this select 0;

	{
		_item = _x;

		// Dynamic size
		{
			if (count _item > _x) then
			{
				_val = _item select _x;
				if (typeName _val == "CODE") then { _item set [_x, _this call _val] };
			};
		} forEach [3,4,8];

		_mapCtrl drawIcon _item;
	} forEach A3W_mapDraw_arrIcons;

	{ _mapCtrl drawLine _x } forEach A3W_mapDraw_arrLines;
} call mf_compile;

if (!isNil "A3W_mapDraw_thread") then { terminate A3W_mapDraw_thread };
A3W_mapDraw_thread = [] spawn
{
	scriptName "drawPlayerMarkers";

	_showPlayers = ["A3W_teamPlayersMap"] call isConfigOn;
	_missionAiDrawLines = ["A3W_missionFarAiDrawLines"] call isConfigOn;
	_drawAtmIcons = ["A3W_atmMapIcons"] call isConfigOn;
	_atmIcon = (call currMissionDir) + "client\icons\suatmm_icon.paa";
	_atmIconSize = {(0.4 / ctrlMapScale (_this select 0)) max 8 min 25};

	waitUntil
	{
		_newArrayIcons = [];

		if (!isNil "A3W_atmArray" && _drawAtmIcons) then
		{
			_deadATMs = [];

			{
				if (alive _x) then
				{
					_newArrayIcons pushBack [_atmIcon, [1,1,1,1], getPosATL _x, _atmIconSize, _atmIconSize, 0];
				}
				else
				{
					_deadATMs pushback _x;
				};
			} forEach A3W_atmArray;

			if (count _deadATMs > 0) then
			{
				_deadATMs spawn { A3W_atmArray = A3W_atmArray - _this };
			};
		};

		if (_showPlayers) then
		{
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

					_newArrayIcons pushBack [_icon, _color, _pos, 24, 24, getDir _uav, "", 1]; // draw icon

					if (showPlayerNames) then
					{
						_newArrayIcons pushBack ["#(argb,1,1,1)color(0,0,0,0)", _color, _pos, 25, 25, 0, "[AI]", 2, 0.05, "PuristaMedium"]; // draw text
					};
				};
			} forEach _allUAVs;

			{
				_newUnit = _x getVariable ["newRespawnedUnit", objNull];

				if (IS_FRIENDLY_PLAYER(_x) || (_newUnit getVariable ["playerSpawning", false] && IS_FRIENDLY_PLAYER(_newUnit))) then
				{
					_veh = vehicle _x;
					_pos = if (_mapIconsEnabled) then { DEFAULT_ICON_POS(_veh) } else { getPosASLVisual _x };

					_newArrayIcons pushBack ["\A3\ui_f_curator\Data\CfgMarkers\kia_ca.paa", [0,0,0,0.6], _pos, 22, 22, 0]; // draw skull
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

						if (_veh == _x && _x call A3W_fnc_isUnconscious) then { _vehColor = [1,0.25,0,1] }; // make icon orange if awaiting revive

						_newArrayIcons pushBack [_icon, _vehColor, _pos, 24, 24, _dir, "", 1]; // draw icon

						if (_x != player && showPlayerNames) then
						{
							_newArrayIcons pushBack ["#(argb,1,1,1)color(0,0,0,0)", _color, _pos, 25, 25, 0, name _x, 2, 0.05, "PuristaMedium"]; // draw text
						};
					};
				};
			} forEach _playableUnits;

			if (!_mapIconsEnabled) then
			{
				_veh = vehicle player;
				_newArrayIcons pushBack ["\A3\ui_f\Data\IGUI\Cfg\IslandMap\iconplayer_ca.paa", [1,0,0,1], getPosASLVisual _veh, 26, 26, getDir _veh]; // draw player circle
			};
		};

		A3W_mapDraw_arrIcons = _newArrayIcons;

		_newArrayLines = [];

		if (_missionAiDrawLines) then
		{
			{
				if (side _x == CIVILIAN) then
				{
					_markerPos = markerPos (_x getVariable ["A3W_missionMarkerName", ""]);

					if !(_markerPos isEqualTo [0,0,0]) then
					{
						_vehs = [];

						{
							_veh = vehicle _x;

							if !(_veh in _vehs) then
							{
								if (alive _veh && _veh distance _markerPos > MISSION_AI_FAR_DISTANCE) then
								{
									_newArrayLines pushBack [_markerPos, getPosASLVisual _veh, [1,0,0,1]];
								};

								_vehs pushBack _veh;
							};
						} forEach units _x;
					};
				};
			} forEach allGroups;
		};

		A3W_mapDraw_arrLines = _newArrayLines;
		false
	};
};

A3W_scriptThreads pushBack A3W_mapDraw_thread;

// Main map = findDisplay 12 displayCtrl 51
// GPS = (uiNamespace getVariable ["RscMiniMap", displayNull]) displayCtrl 101
// UAV Terminal = findDisplay 160 displayCtrl 51

private ["_display", "_mapCtrl"];

// Main map
waitUntil {_display = findDisplay 12; !isNull _display};
_mapCtrl = _display displayCtrl 51;

if (!isNil "A3W_mapDraw_mainMapEH") then { _mapCtrl ctrlRemoveEventHandler ["Draw", A3W_mapDraw_mainMapEH] };
A3W_mapDraw_mainMapEH = _mapCtrl ctrlAddEventHandler ["Draw", A3W_mapDraw_eventCode];

// GPS
waitUntil {_display = uiNamespace getVariable ["RscMiniMap", displayNull]; !isNull _display};
_mapCtrl = _display displayCtrl 101;

if (!isNil "A3W_mapDraw_gpsMapEH") then { _mapCtrl ctrlRemoveEventHandler ["Draw", A3W_mapDraw_gpsMapEH] };
A3W_mapDraw_gpsMapEH = _mapCtrl ctrlAddEventHandler ["Draw", A3W_mapDraw_eventCode];
