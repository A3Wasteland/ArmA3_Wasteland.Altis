//	@file Name: drawPlayerMarkers.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {};

#define IS_FRIENDLY_PLAYER(UNIT) (isPlayer UNIT && {(group UNIT == group player || (!_isIndie && side group UNIT == playerSide))})
#define DEFAULT_ICON_POS(UNIT) (UNIT modelToWorld (UNIT selectionPosition "spine3"))

disableSerialization;
waitUntil {!isNull findDisplay 12};

_mapCtrl = (findDisplay 12) displayCtrl 51;

if (!isNil "mapEH_drawPlayerMarkers") then
{
	_mapCtrl ctrlRemoveEventHandler ["Draw", mapEH_drawPlayerMarkers]
};

mapEH_drawPlayerMarkers = _mapCtrl ctrlAddEventHandler ["Draw",
{
	_mapCtrl = _this select 0;

	_isIndie = !(playerSide in [BLUFOR,OPFOR]);
	_mapIconsEnabled = difficultyEnabled "map";

	_allDeadMen = allDeadMen;
	_playableUnits = playableUnits;

	reverse _allDeadMen;
	reverse _playableUnits;

	{
		_newUnit = _x getVariable ["newRespawnedUnit", objNull];

		if (IS_FRIENDLY_PLAYER(_x) || _newUnit getVariable ["playerSpawning", false]) then
		{
			_veh = vehicle _x;
			_pos = if (_mapIconsEnabled) then { DEFAULT_ICON_POS(_veh) } else { visiblePositionASL _x };

			_mapCtrl drawIcon ["\A3\UI_F_Curator\Data\CfgMarkers\kia_ca.paa", [0,0,0,0.6], _pos, 22, 22, 0]; // draw icon
		};
	} forEach _allDeadMen;

	{
		if (IS_FRIENDLY_PLAYER(_x) && !(_x getVariable ["playerSpawning", false])) then
		{
			_veh = vehicle _x;

			if ((crew _veh) select 0 == _x) then
			{
				_color = if (group _x == group player) then { [0,1,0,1] } else { [1,1,1,1] };
				_vehColor = if ({group _x == group player} count crew _veh > 0) then { [0,1,0,1] } else { _color }; // make vehicle green if group player in it
				_pos = if (_mapIconsEnabled) then { DEFAULT_ICON_POS(_veh) } else { visiblePositionASL _veh };

				_mapCtrl drawIcon [getText (configFile >> "CfgVehicles" >> typeOf _veh >> "icon"), _vehColor, _pos, 24, 24, getDir _veh, "", 1]; // draw icon

				if (_x != player) then
				{
					_mapCtrl drawIcon ["#(argb,8,8,3)color(0,0,0,0)", _color, _pos, 25, 25, 0, name _x, 2, 0.05, "PuristaMedium"]; // draw text
				};
			};
		};
	} forEach _playableUnits;

	if (!_mapIconsEnabled) then
	{
		_veh = vehicle player;
		_mapCtrl drawIcon ["\A3\UI_F\Data\IGUI\Cfg\IslandMap\iconplayer_ca.paa", [1,0,0,1], visiblePositionASL _veh, 26, 26, getDir _veh]; // draw player circle
	};
}];
