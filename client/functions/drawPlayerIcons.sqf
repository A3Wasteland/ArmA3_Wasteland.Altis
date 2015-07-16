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

if (isNil "showPlayerNames") then { showPlayerNames = false };

hudPlayerIcon_uiScale = (0.55 / (getResolution select 5)) * ICON_sizeScale; // 0.55 = Interface size "Small"
drawPlayerIcons_array = [];

if (!isNil "drawPlayerIcons_draw3D") then { removeMissionEventHandler ["Draw3D", drawPlayerIcons_draw3D] };
drawPlayerIcons_draw3D = addMissionEventHandler ["Draw3D",
{
	{ drawIcon3D _x } forEach drawPlayerIcons_array;
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

	// Execute every frame
	waitUntil
	{
		_newArray = [];

		if (!visibleMap && isNull findDisplay 49 && showPlayerIcons) then
		{
			{
				_unit = _x;

				if (side group _unit == playerSide && // "side group _unit" instead of "side _unit" is because "setCaptive true" when unconscious changes player side to civ (so AI stops shooting)
				   {alive _unit &&
				   (_unit != player || cameraOn != vehicle player) &&
				   {!(_unit getVariable ["playerSpawning", false]) &&
				   (vehicle _unit != getConnectedUAV player || cameraOn != vehicle _unit) && // do not show UAV AI icons when controlling UAV
				   {typeOf _unit != "HeadlessClient_F"}}}) then 
				{
					_dist = _unit distance positionCameraToWorld [0,0,0];
					_pos = _unit modelToWorldVisual [0, 0, 1.35]; // Torso height

					// only draw players inside range and screen
					if (_dist < ICON_limitDistance && {count worldToScreen _pos > 0}) then
					{
						_alpha = (ICON_limitDistance - _dist) / (ICON_limitDistance - ICON_fadeDistance);
						_color = [1,1,1,_alpha];
						_icon = _teamIcon;
						_size = 0;

						if (_unit call A3W_fnc_isUnconscious) then
						{
							_icon = _reviveIcon;
							_size = (2 - ((_dist / ICON_limitDistance) * 0.8)) * _uiScale;

							// Revive icon blinking code
							if (_unit call A3W_fnc_isBleeding) then
							{
								_blink = false;
								_timestamp = _unit getVariable ["FAR_iconBlinkTimestamp", 0];
								_time = time;

								if (isNil {_unit getVariable "FAR_iconBlink"} || (_time >= _timestamp && _time < _timestamp + 0.3)) then
								{
									_blink = true;

									if !(_unit getVariable ["FAR_iconBlink", false]) then
									{
										_unit setVariable ["FAR_iconBlink", true];
										_unit setVariable ["FAR_iconBlinkTimestamp", _time];
									};
								}
								else
								{
									if (_unit getVariable ["FAR_iconBlink", false]) then
									{
										_unit setVariable ["FAR_iconBlink", false];
										_unit setVariable ["FAR_iconBlinkTimestamp", _time + 1.25];
									};
								};

								if (_blink) then
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
							_size = (1 - ((_dist / ICON_limitDistance) * 0.7)) * _uiScale;
						};

						_text = if (showPlayerNames) then {
							if (isPlayer _unit) then { name _unit } else { "[AI]" }
						} else {
							""
						};

						_newArray pushBack [_icon, _color, _pos, _size, _size, 0, _text]; //, 1, 0.03, "PuristaMedium"];
					};
				};
			} forEach (if (playerSide in [BLUFOR,OPFOR]) then { allUnits } else { units player });
		};

		drawPlayerIcons_array = _newArray;
		false
	};
};

A3W_scriptThreads pushBack drawPlayerIcons_thread;
