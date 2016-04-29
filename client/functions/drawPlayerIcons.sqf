// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: drawPlayerIcons.sqf
//	@file Author: AgentRev
//	@file Created: 27/03/2014

if (!hasInterface) exitWith {};

#define ICON_fadeDistance 1250
#define ICON_limitDistance 2000
#define ICON_sizeScale 0.75

#define MINE_ICON_MAX_DISTANCE 200 // 200 is Arma 3 default for mine detector

#define UNIT_POS(UNIT) (UNIT modelToWorldVisual (UNIT selectionPosition "spine3")) //[0, 0, 1.25]) // Torso height
#define UAV_UNIT_POS(UNIT) (((vehicle UNIT) modelToWorldVisual [0, 0, 0]) vectorAdd [0, 0, 0.5])
#define CENTER_POS(OBJ) (OBJ modelToWorldVisual [0,0,0])

if (isNil "showPlayerNames") then { showPlayerNames = false };

hudPlayerIcon_uiScale = (0.55 / (getResolution select 5)) * ICON_sizeScale; // 0.55 = Interface size "Small"
drawPlayerIcons_array = [];

drawPlayerIcons_posCode =
{
	switch (_this) do
	{
		case 1: {{ UNIT_POS(_this) }};
		case 2: {{ UAV_UNIT_POS(_this) }};
		default {{ CENTER_POS(_this) }};
	};
} call mf_compile;

if (!isNil "drawPlayerIcons_draw3D") then { removeMissionEventHandler ["Draw3D", drawPlayerIcons_draw3D] };
drawPlayerIcons_draw3D = addMissionEventHandler ["Draw3D",
{
	{
		_x params ["_drawArr", "_obj", "_posCode"];
		if (alive _obj) then { _drawArr set [2, _obj call _posCode] };
		drawIcon3D _drawArr;
	} forEach drawPlayerIcons_array;
}];

if (!isNil "drawPlayerIcons_thread") then { terminate drawPlayerIcons_thread };
drawPlayerIcons_thread = [] spawn
{
	scriptName "drawPlayerIcons";

	_uiScale = (0.55 / (getResolution select 5)) * ICON_sizeScale; // 0.55 = Interface size "Small"

	_reviveIcon = call currMissionDir + "client\icons\revive.paa";
	_teamIcon = switch (playerSide) do
	{
		case BLUFOR: { call currMissionDir + "client\icons\igui_side_blufor_ca.paa" };
		case OPFOR:  { call currMissionDir + "client\icons\igui_side_opfor_ca.paa" };
		default      { call currMissionDir + "client\icons\igui_side_indep_ca.paa" };
	};

	_detectedMinesDisabled = (difficultyOption "detectedMines" == 0);
	_mineIcon = getText (configfile >> "CfgInGameUI" >> "Cursor" >> "explosive");
	_mineColor = getArray (configfile >> "CfgInGameUI" >> "Cursor" >> "explosiveColor");

	{
		if (_x isEqualType "") then
		{
			_mineColor set [_forEachIndex, call compile _x]; // explosiveColor contains an array of strings which contain profile color code...
		};
	} forEach _mineColor;

	private ["_dist", "_simulation"];

	// Execute every frame
	waitUntil
	{
		_newArray = [];

		if (!visibleMap && isNull findDisplay 49) then
		{
			{
				_unit = _x;

				if (side group _unit isEqualTo playerSide && // "side group _unit" instead of "side _unit" is because "setCaptive true" when unconscious changes player side to civ (so AI stops shooting)
				   {_dist = _unit distance positionCameraToWorld [0,0,0]; _dist < ICON_limitDistance &&
				   {alive _unit &&
				   (_unit != player || cameraOn != vehicle player) &&
				   {!(_unit getVariable ["playerSpawning", false]) &&
				   (vehicle _unit != getConnectedUAV player || cameraOn != vehicle _unit) && // do not show UAV AI icons when controlling UAV
				   {_simulation = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "simulation"); _simulation != "headlessclient"}}}}) then 
				{
					_isUavUnit = (_simulation == "UAVPilot");
					//_dist = _unit distance positionCameraToWorld [0,0,0];
					_posCode = ([1,2] select _isUavUnit) call drawPlayerIcons_posCode;
					_pos = _unit call _posCode;

					// only draw players inside range and screen
					if !(worldToScreen _pos isEqualTo []) then
					{
						_isUavUnit = (_simulation == "UAVPilot");
						if (_isUavUnit && {_unit != (crew vehicle _unit) select 0}) exitWith {}; // only one AI per UAV

						_alpha = (ICON_limitDistance - _dist) / (ICON_limitDistance - ICON_fadeDistance);
						_color = [1,1,1,_alpha];
						_icon = _teamIcon;
						_size = 0;
						_shadow = [0,2] select showPlayerNames;

						if (_unit call A3W_fnc_isUnconscious) then
						{
							_icon = _reviveIcon;
							_size = (2 - ((_dist / ICON_limitDistance) * 0.8)) * _uiScale * ([0.8, 1] select showPlayerNames);

							// Revive icon blinking code
							if (_unit call A3W_fnc_isBleeding) then
							{
								_timestamp = _unit getVariable ["FAR_iconBlinkTimestamp", 0];
								_time = time;

								if !(_unit getVariable ["FAR_iconBlink", false]) then
								{
									if (_time >= _timestamp) then
									{
										_unit setVariable ["FAR_iconBlink", true];
										_unit setVariable ["FAR_iconBlinkTimestamp", _time + 0.3]; // red duration
									};
								}
								else
								{
									if (_time >= _timestamp) then
									{
										_unit setVariable ["FAR_iconBlink", false];
										_unit setVariable ["FAR_iconBlinkTimestamp", _time + 1.25]; // green duration
									};
								};

								if (_unit getVariable ["FAR_iconBlink", false]) then
								{
									_color = [1,0,0,_alpha];
								};
							}
							else
							{
								if (!isNil {_unit getVariable "FAR_iconBlink"}) then
								{
									_unit setVariable ["FAR_iconBlink", nil];
								};
							};
						}
						else
						{
							_size = (1 - ((_dist / ICON_limitDistance) * 0.7)) * _uiScale * ([0.7, 1] select showPlayerNames);
						};

						_text = if (showPlayerNames) then
						{
							if (isPlayer _unit) then { name _unit }
							else
							{
								_uavOwner = (uavControl vehicle _unit) select 0;
								format ["[AI%1]", if (isPlayer _uavOwner) then { " - " + name _uavOwner } else { "" }]
							};
						} else { "" };

						_newArray pushBack [[_icon, _color, _pos, _size, _size, 0, _text, _shadow], _unit, _posCode]; //, 0.03, "PuristaMedium"];
					};
				};
			} forEach (if (playerSide in [BLUFOR,OPFOR]) then { allUnits } else { units player });

			if (_detectedMinesDisabled && "MineDetector" in items player) then
			{
				_posCode = 0 call drawPlayerIcons_posCode;

				{
					if (mineActive _x && _x distance player <= MINE_ICON_MAX_DISTANCE) then
					{
						_newArray pushBack [[_mineIcon, _mineColor, CENTER_POS(_x), 1, 1, 0, "", 2, 0, "PuristaMedium", "", true], _x, _posCode];
					};
				} forEach detectedMines playerSide;
			};
		};

		drawPlayerIcons_array = _newArray;
		false
	};
};

A3W_scriptThreads pushBack drawPlayerIcons_thread;
