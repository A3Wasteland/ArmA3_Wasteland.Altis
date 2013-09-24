/*********************************************************#
# @@ScriptName: applyVehicleTexture.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>
# @@Create Date: 2013-09-15 19:33:17
# @@Modify Date: 2013-09-24 23:03:48
# @@Function: Applies a custom texture or color to a vehicle
#*********************************************************/

// Called with [_car, _textureFilename], "applyVehicleTexture", side, false] call TPG_fnc_MP;

// Generally called from buyVehicles.sqf

private["_car", "_texture"];
	
if (typeName _this == "ARRAY" && {count _this == 2}) then {
	_car = _this select 0;
	_texture = _this select 1;
	_car setObjectTexture [0, _texture];
};
