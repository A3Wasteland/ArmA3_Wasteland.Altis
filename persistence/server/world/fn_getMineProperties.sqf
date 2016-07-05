// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getMineProperties.sqf
//	@file Author: AgentRev

#include "functions.sqf"

params ["_dummy"];
private ["_mine", "_class", "_pos", "_dir", "_damage", "_variables", "_owner"];

_mine = _dummy getVariable ["A3W_stickyCharges_linkedBomb", objNull];

_class = A3W_mineSaving_ammoClasses find toLower typeOf _mine;
if (_class == -1) exitWith { [] }; // this is not supposed to happen, will break everything if it does.
_class = A3W_mineSaving_vehicleClasses select _class;

_pos = ASLtoATL getPosWorld _mine;
{ _pos set [_forEachIndex, _x call fn_numToStr] } forEach _pos;
_dir = [vectorDir _mine, vectorUp _mine];
_damage = damage _mine;

_variables = [];
_variables pushBack ["side", str (_dummy getVariable ["A3W_stickyCharges_side", sideUnknown])];

_owner = _dummy getVariable ["A3W_stickyCharges_ownerUID", ""];

[
	["Class", _class],
	["Position", _pos],
	["Direction", _dir],
	["Damage", _damage],
	["OwnerUID", _owner],
	["Variables", _variables]
]
