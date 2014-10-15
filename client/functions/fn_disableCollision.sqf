//	@file Name: fn_disableCollision.sqf
//	@file Author: AgentRev

private ["_veh1", "_veh2"];

_veh1 = _this select 0;
_veh2 = _this select 1;

if (typeName _veh1 == "STRING") then { _veh1 = objectFromNetId _veh1 };
if (typeName _veh2 == "STRING") then { _veh2 = objectFromNetId _veh2 };

_veh1 disableCollisionWith _veh2;
