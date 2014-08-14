//	@file Name: fn_getPos3D.sqf
//	@file Author: AgentRev

// This function is to counter the fact that "getPos" is relative to the floor under the object,
// while most functions require positions to be from ground or sea wave level, whichever is highest

private "_pos";
_pos = getPosATL _this;

if (surfaceIsWater _pos) then
{
	_pos = getPosASLW _this;
};

_pos
