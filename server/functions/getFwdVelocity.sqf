//	@file Name: getFwdVelocity.sqf
//	@file Author: AgentRev

(velocityModelSpace _this) select 1

/*
private ["_veh", "_getAngleBetween", "_vel", "_dir", "_angle", "_scalar", "_absVel"];
_veh = _this;

_getAngleBetween =
{
	private ["_vec1", "_vec2", "_dotProd", "_mag1x2"];
	_vec1 = _this select 0;
	_vec2 = _this select 1;
	
	_dotProd = [_vec1, _vec2] call BIS_fnc_dotProduct;
	_mag1x2 = (_vec1 distance [0,0,0]) * (_vec2 distance [0,0,0]);
	
	if (_mag1x2 > 0) then
	{
		acos (((_dotProd / _mag1x2) max -1) min 1)
	}
	else { 0 }
};

_vel = velocity _veh;
_dir = vectorDir _veh;
_angle = [_vel, _dir] call _getAngleBetween;
_scalar = 1;

if (_angle > 90) then
{
	_scalar = -1;
	_dir = [_dir, _scalar] call BIS_fnc_vectorMultiply;
	_angle = [_vel, _dir] call _getAngleBetween;
};

_absVel = _vel distance [0,0,0];

(cos _angle) * _absVel * _scalar
*/
