//	@file Name: pushVehicleOnFoot.sqf
//	@file Author: AgentRev

_this call pushVehicle;

/*
private ["_veh", "_caller", "_actionID", "_params", "_vel", "_vectorDir", "_vectorVel", "_finalVel", "_finalMag"];

_caller = _this select 1;
_actionID = _this select 2;
_params = [_this, 3, [], [[]]] call BIS_fnc_param;

_vel = [_params, 0, 0, [0]] call BIS_fnc_param;
_veh = [_params, 1, objNull, [""]] call BIS_fnc_param;

if (_vel != 0) then
{
	if (typeName _veh == "STRING") then
	{
		_veh = objectFromNetId _veh;
	}
	else
	{
		if (isNull _veh && _caller == player) then
		{
			_veh = cursorTarget;
		};
	};

	if (!isNull _veh && !isPlayer _veh) then
	{
		if (local _veh) then
		{
			if (count crew _veh == 0) then
			{
				_fwdVel = _veh call getFwdVelocity;

				if ((velocity _veh) distance [0,0,0] < _vel) then
				{
					_vectorDir = [getPosASL _caller, getPosASL _veh] call BIS_fnc_vectorFromXToY;
					_vectorVel = [_vectorDir, _vel / 2] call BIS_fnc_vectorMultiply;
					_finalVel = [velocity _veh, _vectorVel] call BIS_fnc_vectorAdd;
					_finalMag = _finalVel distance [0,0,0];

					if (_finalMag > abs _vel) then
					{
						_finalVel = [_finalVel, abs _vel / _finalMag] call BIS_fnc_vectorMultiply;
					};

					_veh setVelocity _finalVel;
				};
			};
		}
		else
		{
			[[_caller, _caller, _actionID, [_vel, netId _veh]], "pushVehicleOnFoot", _veh, false] call TPG_fnc_MP;
		};
	};
};
*/