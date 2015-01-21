// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_ejectCorpse.sqf
//	@file Author: AgentRev

private ["_corpse", "_veh", "_pos", "_vehSize"];
_corpse = _this;
_veh = vehicle _corpse;

#define INVALID_CORPSE (!local _corpse || alive _corpse || isNull _veh || _veh == _corpse)

if (INVALID_CORPSE) exitWith {};

waitUntil
{
	sleep 0.1;
	_veh = vehicle _corpse;
	_pos = getPos _veh;
	INVALID_CORPSE || {(isTouchingGround _veh || _pos select 2 < 5) && {vectorMagnitude velocity _veh < (if (surfaceIsWater _pos) then { 5 } else { 1 })}}
};

if (!INVALID_CORPSE) then
{
	_vehSize = sizeOf typeOf _veh;
	_corpse setPos ((_corpse call fn_getPos3D) vectorAdd ([[0, (_vehSize / 3) + random (_vehSize / 6), 0], -([_corpse, _veh] call BIS_fnc_dirTo)] call BIS_fnc_rotateVector2D));
};
