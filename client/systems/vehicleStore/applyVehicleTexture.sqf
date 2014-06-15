/*********************************************************#
# @@ScriptName: applyVehicleTexture.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>, AgentRev
# @@Create Date: 2013-09-15 19:33:17
# @@Modify Date: 2013-09-24 23:03:48
# @@Function: Applies a custom texture or color to a vehicle
#*********************************************************/

// Generally called from buyVehicles.sqf

private ["_veh", "_texture", "_selections"];

_veh = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_texture = [_this, 1, "", [""]] call BIS_fnc_param;

if (!isNull _veh && _texture != "") then
{
	_veh setVariable ["BIS_enableRandomization", false, true];

	// Apply texture to all appropriate parts
	_selections = switch (true) do
	{
		case (_veh isKindOf "Van_01_base_F"):             { [0,1] };

		case (_veh isKindOf "MRAP_01_base_F"):            { [0,2] };
		case (_veh isKindOf "MRAP_02_base_F"):            { [0,2] };
		case (_veh isKindOf "MRAP_03_base_F"):            { [0,1] };

		case (_veh isKindOf "Truck_01_base_F"):           { [0,1,2] };
		case (_veh isKindOf "Truck_02_base_F"):           { [0,1] };
		case (_veh isKindOf "Truck_03_base_F"):           { [0,1] };

		case (_veh isKindOf "APC_Wheeled_01_base_F"):     { [0,2] };
		case (_veh isKindOf "APC_Wheeled_02_base_F"):     { [0,2] };
		case (_veh isKindOf "APC_Wheeled_03_base_F"):     { [0,2,3] };

		case (_veh isKindOf "APC_Tracked_01_base_F"):     { [0,1,2,3] };
		case (_veh isKindOf "APC_Tracked_02_base_F"):     { [0,1,2] };
		case (_veh isKindOf "APC_Tracked_03_base_F"):     { [0,1] };

		case (_veh isKindOf "MBT_01_base_F"):             { [0,1,2] };
		case (_veh isKindOf "MBT_02_base_F"):             { [0,1,2,3] };
		case (_veh isKindOf "MBT_03_base_F"):             { [0,1,2] };

		case (_veh isKindOf "Heli_Transport_01_base_F"):  { [0,1] };
		case (_veh isKindOf "Heli_Transport_02_base_F"):  { [0,1,2] };
		case (_veh isKindOf "Heli_Attack_02_base_F"):     { [0,1] };

		case (_veh isKindOf "Plane_Base_F"):              { [0,1] };

		default                                           { [0] };
	};

	{ _veh setObjectTextureGlobal [_x, _texture] } forEach _selections;

	_veh setVariable ["A3W_objectTexture", _texture, true];
};
