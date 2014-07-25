//	@file Version: 1.0
//	@file Name: drawPlayerIcons.sqf
//	@file Author: AgentRev
//	@file Created: 27/03/2014

if (!hasInterface) exitWith {};

#define ICON_fadeDistance 750
#define ICON_limitDistance 1250
#define ICON_sizeScale 0.75

/*
hudPlayerIcon = switch (playerSide) do
{
	case OPFOR:       { call currMissionDir + "client\icons\igui_side_opfor_ca.paa" };
	case INDEPENDENT: { call currMissionDir + "client\icons\igui_side_indep_ca.paa" };
	default           { call currMissionDir + "client\icons\igui_side_blufor_ca.paa" };
};
*/

hudPlayerIcon_uiScale = (0.55 / (getResolution select 5)) * ICON_sizeScale; // 0.55 = Interface size "Small"
	
if (isNil "missionEH_drawPlayerIcons") then
{
	bluforPlayerIcon = compileFinal str (call currMissionDir + "client\icons\igui_side_blufor_ca.paa");
	opforPlayerIcon = compileFinal str (call currMissionDir + "client\icons\igui_side_opfor_ca.paa");
	indepPlayerIcon = compileFinal str (call currMissionDir + "client\icons\igui_side_indep_ca.paa");
}
else
{
	removeMissionEventHandler ["Draw3D", missionEH_drawPlayerIcons];
};

missionEH_drawPlayerIcons = addMissionEventHandler ["Draw3D",
{
	if (!visibleMap && isNull findDisplay 49 && showPlayerIcons) then
	{
		_units = if (playerSide == INDEPENDENT) then { units player } else { allUnits };

		{
			if (alive _x && (side _x == playerSide) && (_x != player)) then
			{
				_pos = visiblePositionASL _x;
				_pos set [2, (_x modelToWorld [0,0,0]) select 2];

				_distance = _pos distance positionCameraToWorld [0,0,0];

				// only draw players inside range and screen
				if (_distance < ICON_limitDistance && (count worldToScreen _pos > 0)) then
				{
					_icon = switch (side _x) do
					{
						case OPFOR:       { call opforPlayerIcon };
						case INDEPENDENT: { call indepPlayerIcon };
						default           { call bluforPlayerIcon };
					};

					_pos set [2, (_pos select 2) + 1.25]; // Torso height
					_size = (1 - ((_distance / ICON_limitDistance) * 0.6)) * hudPlayerIcon_uiScale;
					_alpha = (ICON_limitDistance - _distance) / (ICON_limitDistance - ICON_fadeDistance);

					drawIcon3D [_icon, [1,1,1,_alpha], _pos, _size, _size, 0]; //, "", 1, 0.03, "PuristaMedium"];
				};
			};
		} forEach _units;
	};
}];
