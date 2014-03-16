//	@file Name: pushVehicleBack.sqf
//	@file Author: AgentRev

#define MAX_BACKWARDS_VELOCITY 7.5

private "_veh";
_veh = _this select 0;

if (typeName _veh == "STRING") then
{
	_veh = objectFromNetId _veh;
};

if (_veh == player) then
{
	_veh = vehicle player;
};

if (!local _veh) exitWith
{
	[[netId _veh], "pushVehicleBack", _veh, false] call TPG_fnc_MP;
};

if (!isNull _veh && {_veh != player}) then
{
	_fwdVel = _veh call getFwdVelocity;

	if (_veh call getFwdVelocity > -MAX_BACKWARDS_VELOCITY) then
	{
		_reverseVel = [vectorDir _veh, -MAX_BACKWARDS_VELOCITY / 2] call BIS_fnc_vectorMultiply;
		_finalVel = [velocity _veh, _reverseVel] call BIS_fnc_vectorAdd;
		_finalMag = _finalVel distance [0,0,0];
		
		if (_finalMag > MAX_BACKWARDS_VELOCITY) then
		{
			_finalVel = [_finalVel, MAX_BACKWARDS_VELOCITY / _finalMag] call BIS_fnc_vectorMultiply;
		};
		
		_veh setVelocity _finalVel;
	};
};
