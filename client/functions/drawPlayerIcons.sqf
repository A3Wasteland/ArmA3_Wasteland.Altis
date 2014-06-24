//	@file Version: 1.0
//	@file Name: drawPlayerIcons.sqf
//	@file Author: AgentRev
//	@file Created: 27/03/2014

if (!hasInterface) exitWith {};

#define ICON_fadeDistance 750
#define ICON_limitDistance 1250
#define ICON_sizeScale 0.75

bluforPlayerIcon = call currMissionDir + "client\icons\igui_side_blufor_ca.paa";
opforPlayerIcon = call currMissionDir + "client\icons\igui_side_opfor_ca.paa";
indepPlayerIcon = call currMissionDir + "client\icons\igui_side_indep_ca.paa";
revivePlayerIcon = call currMissionDir + "client\icons\revive.paa";

showPlayerNames = false;
hudPlayerIcon_uiScale = (0.55 / (getResolution select 5)) * ICON_sizeScale; // 0.55 = Interface size "Small"

if (!isNil "missionEH_drawPlayerIcons") then
{
	removeMissionEventHandler ["Draw3D", missionEH_drawPlayerIcons];
};

missionEH_drawPlayerIcons = addMissionEventHandler ["Draw3D",
{
	if (!visibleMap && isNull findDisplay 49 && showPlayerIcons) then
	{
		_icon = switch (playerSide) do
		{
			case BLUFOR: { bluforPlayerIcon };
			case OPFOR:  { opforPlayerIcon };
			default      { indepPlayerIcon };
		};

		{
			_unit = _x;

			if (alive _unit && (side group _unit == playerSide) && (_unit != player)) then // "side group _unit" instead of "side _unit" is because "setCaptive true" when unconscious changes player side to civ (so AI stops shooting)
			{
				_dist = _unit distance positionCameraToWorld [0,0,0];

				_pos = visiblePositionASL _unit;
				_pos set [2, (_unit modelToWorld [0,0,0]) select 2];

				// only draw players inside range and screen
				if (_dist < ICON_limitDistance && (count worldToScreen _pos > 0)) then
				{
					_pos set [2, (_pos select 2) + 1.35]; // Torso height
					_alpha = (ICON_limitDistance - _dist) / (ICON_limitDistance - ICON_fadeDistance);
					_color = [1,1,1,_alpha];
					_size = 0;

					if (_unit getVariable ["FAR_isUnconscious", 0] == 1) then
					{
						_icon = revivePlayerIcon;
						_size = (2 - ((_dist / ICON_limitDistance) * 0.8)) * hudPlayerIcon_uiScale;

						// Revive icon blinking code
						if (_unit getVariable ["FAR_isStabilized", 0] == 0) then
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
						_size = (1 - ((_dist / ICON_limitDistance) * 0.6)) * hudPlayerIcon_uiScale;
					};

					_text = if (showPlayerNames) then {
						if (isPlayer _unit) then { name _unit } else { "[AI]" }
					} else {
						""
					};

					drawIcon3D [_icon, _color, _pos, _size, _size, 0, _text]; //, 1, 0.03, "PuristaMedium"];
				};
			};
		} forEach (if (playerSide in [BLUFOR,OPFOR]) then { allUnits } else { units player });
	};
}];
