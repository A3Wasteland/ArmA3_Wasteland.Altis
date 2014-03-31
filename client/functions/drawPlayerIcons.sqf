//	@file Version: 1.0
//	@file Name: drawPlayerIcons.sqf
//	@file Author: AgentRev
//	@file Created: 27/03/2014

if (!hasInterface) exitWith {};

#define ICON_fadeDistance 750
#define ICON_limitDistance 1250
#define ICON_sizeScale 0.75

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
	if (!visibleMap && {showPlayerIcons}) then
	{
		_icon = switch (playerSide) do
		{
			case BLUFOR:      { call bluforPlayerIcon };
			case OPFOR:       { call opforPlayerIcon };
			case INDEPENDENT: { call indepPlayerIcon };
			default           { call bluforPlayerIcon };
		};

		_iconScaleUI =  (0.55 / (getResolution select 5)) * ICON_sizeScale; // 0.55 = Interface size "Small"

		_units = if (playerSide == INDEPENDENT) then { units player } else { allUnits };

		{
			if (alive _x && {side _x == playerSide} && {_x != player}) then
			{
				_pos = visiblePosition _x;

				if (getTerrainHeightASL _pos < 0) then
				{
					_pos = visiblePositionASL _x;
				};

				_distance = _pos distance positionCameraToWorld [0,0,0];

				// only draw players inside range and screen
				if (_distance < ICON_limitDistance && {count worldToScreen _pos > 0}) then
				{
					_pos set [2, (_pos select 2) + 1.35]; // Torso height
					_size = (1 - ((_distance / ICON_limitDistance) * 0.6)) * _iconScaleUI;
					_alpha = (ICON_limitDistance - _distance) / (ICON_limitDistance - ICON_fadeDistance);

					drawIcon3D [_icon, [1,1,1,_alpha], _pos, _size, _size, 0, "", 0, 0, "PuristaMedium"];
				};
			};
		} forEach _units;
	};
}];
