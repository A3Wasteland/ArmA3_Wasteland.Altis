// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*********************************************************#
# @@ScriptName: applyVehicleTexture.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>, AgentRev
# @@Create Date: 2013-09-15 19:33:17
# @@Modify Date: 2013-09-24 23:03:48
# @@Function: Applies a custom texture or color to a vehicle
#*********************************************************/

// Generally called from buyVehicles.sqf

private ["_veh", "_texture", "_selections", "_textures"];

_veh = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_texture = [_this, 1, "", ["",[]]] call BIS_fnc_param;
_selections = [_this, 2, [], [[]]] call BIS_fnc_param;

if (isNull _veh || count _texture == 0) exitWith {};

_veh setVariable ["BIS_enableRandomization", false, true];

_textures = _veh getVariable ["A3W_objectTextures", []];

// Apply texture to all appropriate parts
if (typeName _texture == "STRING") then
{
	if (count _selections == 0) then
	{
		_selections = switch (true) do
		{
			case (_veh isKindOf "Van_01_base_F"):                 { [0,1] };

			case (_veh isKindOf "MRAP_01_base_F"):                { [0,2] };
			case (_veh isKindOf "MRAP_02_base_F"):                { [0,1,2] };
			case (_veh isKindOf "MRAP_03_base_F"):                { [0,1] };

			case (_veh isKindOf "Truck_01_base_F"):               { [0,1,2] };
			case (_veh isKindOf "Truck_02_base_F"):               { [0,1] };
			case (_veh isKindOf "Truck_03_base_F"):               { [0,1] };

			case (_veh isKindOf "APC_Wheeled_01_base_F"):         { [0,2] };
			case (_veh isKindOf "APC_Wheeled_02_base_F"):         { [0,2] };
			case (_veh isKindOf "APC_Wheeled_03_base_F"):         { [0,2,3] };

			case (_veh isKindOf "APC_Tracked_01_base_F"):         { [0,1,2,3] };
			case (_veh isKindOf "APC_Tracked_02_base_F"):         { [0,1,2] };
			case (_veh isKindOf "APC_Tracked_03_base_F"):         { [0,1] };

			case (_veh isKindOf "MBT_01_base_F"):                 { [0,1,2] };
			case (_veh isKindOf "MBT_02_base_F"):                 { [0,1,2,3] };
			case (_veh isKindOf "MBT_03_base_F"):                 { [0,1,2] };

			case (_veh isKindOf "Heli_Transport_01_base_F"):      { [0,1] };
			case (_veh isKindOf "Heli_Transport_02_base_F"):      { [0,1,2] };
			case (_veh isKindOf "Heli_Transport_03_base_F"):      { [0,1] };
			case (_veh isKindOf "Heli_Transport_04_base_F"):      { [0,1,2,3] };
			case (_veh isKindOf "Heli_Attack_02_base_F"):         { [0,1] };

			case (_veh isKindOf "Plane_Base_F"):                  { [0,1] };

			case (_veh isKindOf "UGV_01_rcws_base_F"):            { [0,2] };

			default                                               { [0] };
		};
	};

	{
		_veh setObjectTextureGlobal [_x, _texture];
		[_textures, _x, _texture] call fn_setToPairs;
	} forEach _selections;
}
else
{
	{
		_sel = _x select 0;
		_tex = _x select 1;

		_veh setObjectTextureGlobal [_sel, _tex];
		[_textures, _sel, _tex] call fn_setToPairs;
	} forEach _texture;
};

_veh setVariable ["A3W_objectTextures", _textures, true];
