//	@file Name: animateVehicle.sqf
//	@file Author: AgentRev

private ["_veh", "_params", "_name", "_value"];

_veh = _this select 0;
_params = _this select 3;
_name = _params select 0;
_value = _params select 1;

_veh animate [_name, _value];
