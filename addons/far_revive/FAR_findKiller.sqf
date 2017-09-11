// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_findKiller.sqf
//	@file Author: AgentRev

private _target = _this;
private _killer = _target getVariable ["FAR_killerUnit", objNull];

if (_killer == _target) exitWith { objNull }; // Suicide
if (_killer isKindOf "Man") exitWith { _killer }; // Killed by infantry

//systemChat format [FAR_findKiller: %2", [typeOf _target, name _target], [_killer, typeOf _killer, assignedVehicleRole _killer]];
//diag_log format [FAR_findKiller: %2", [typeOf _target, name _target], [_killer, typeOf _killer, assignedVehicleRole _killer]];

if (_killer == _target) exitWith { objNull }; // Indirect suicide

_killer
