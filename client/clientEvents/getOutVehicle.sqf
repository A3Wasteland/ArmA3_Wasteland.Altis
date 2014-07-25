//	@file Name: getOutVehicle.sqf
//	@file Author: AgentRev

private "_veh";
_veh = _this select 0;

_veh removeEventHandler ["Engine", _veh getVariable ["A3W_unconsciousEngineEH", -1]];
_veh setVariable ["A3W_unconsciousEngineEH", nil];

{ _veh removeAction _x } forEach (_veh getVariable ["A3W_serviceBeaconActions", []]);
_veh setVariable ["A3W_serviceBeaconActions", nil];
