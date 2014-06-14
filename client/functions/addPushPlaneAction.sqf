//	@file Name: addPushPlaneAction.sqf
//	@file Author: AgentRev

private ["_veh", "_condArgs"];

_veh = _this select 0;
_condArgs = _this select 1;

_veh addAction ["Push plane backward", "server\functions\pushVehicle.sqf", [-7.5], 1, false, false, "", format ["%1 call canPushPlaneBack", _condArgs]]
