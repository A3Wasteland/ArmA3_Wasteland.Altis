//	@file Name: getPushPlaneAction.sqf
//	@file Author: AgentRev

private "_condArgs";
_condArgs = _this select 0;

["Push plane backward", "server\functions\pushVehicle.sqf", [-7.5], 1, false, false, "", format ["%1 call canPushPlaneBack", _condArgs]]
