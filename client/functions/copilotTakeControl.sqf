//	@file Name: copilotTakeControl.sqf
//	@file Author: AgentRev

private ["_unit", "_veh"];
_unit = _this select 0;
_veh = _this select 1;

if (typeName _veh == "STRING") then
{
	_veh = objectFromNetId _veh;
};

_unit action ["TakeVehicleControl", _veh];
_unit action ["EngineOn", _veh];

if (_unit == player) then
{
	titleText ["You have been given control of the aircraft", "PLAIN DOWN", 0.5];
};
