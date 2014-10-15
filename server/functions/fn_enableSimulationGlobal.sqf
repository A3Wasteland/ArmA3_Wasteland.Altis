//	@file Name: fn_enableSimulationGlobal.sqf
//	@file Author: Farooq, AgentRev

// Because some twat decided that enableSimulationGlobal was to be restricted to server only...

private ["_object", "_simul"];
_object = _this select 0;
_simul = _this select 1;

if (typeName _object == "STRING") then { _object = objectFromNetId _object };

if (isServer) then
{
	_object enableSimulationGlobal _simul;
}
else
{
	pvar_enableSimulationGlobal = [netId _object, _simul];
	publicVariableServer "pvar_enableSimulationGlobal";
};
