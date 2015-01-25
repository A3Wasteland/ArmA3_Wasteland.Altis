// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setupAntiExplode.sqf
//	@file Author: AgentRev

// Attempt at fixing the dreaded explosion bug when you get in heli/planes and when taking control of UAVs

if (isServer) exitWith {};

private "_veh";
_veh = _this;

if (typeName _veh == "STRING") then { _veh = objectFromNetId _veh };

if (_veh getVariable ["A3W_antiExplodeLocalEH", false]) exitWith {};

_veh setVariable ["A3W_antiExplodeLocalEH", true];

if (isNil "A3W_antiExplodeLocalEH") then
{
	A3W_antiExplodeLocalEH =
	{
		_veh = _this select 0;
		_local = _this select 1;

		if (_local && {(isTouchingGround _veh || (getPos _veh) select 2 < 0.1) && vectorMagnitude velocity _veh < 1}) then
		{
			_pos = getPosWorld _veh;
			_pos set [2, (_pos select 2) + 0.1]; // might need to be increased if it doesn't work all the time
			_veh setPosWorld _pos;
		};
	} call mf_compile;
};

_veh addEventHandler ["Local", compile format ["[objectFromNetId '%1', _this select 1] call A3W_antiExplodeLocalEH", netId _veh]]; // apparently the vehicle isn't passed to the event code, so it has to be hardcoded...
