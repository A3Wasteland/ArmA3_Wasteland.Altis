// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: copilotTakeControl.sqf
//	@file Author: AgentRev

private ["_unit", "_veh"];
_unit = _this select 0;
_veh = _this select 1;

if (_veh isEqualType "") then
{
	_veh = objectFromNetId _veh;
};

_unit action ["TakeVehicleControl", _veh];
_unit action ["EngineOn", _veh];

if (_veh turretUnit [0] != player) exitWith {};
if (round getNumber ((([_veh, configNull] call BIS_fnc_getTurrets) param [1,configNull]) >> "isCopilot") < 1) exitWith {};

titleText ["You have been given control of the aircraft", "PLAIN DOWN", 0.5];
