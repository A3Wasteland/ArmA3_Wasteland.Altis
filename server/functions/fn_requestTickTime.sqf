// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_requestTickTime.sqf
//	@file Author: AgentRev

params [["_owner",0,[0]]];

A3W_serverTickTime = diag_tickTime;

if (_owner == clientOwner) exitWith {};

_owner publicVariableClient "A3W_serverTickTime";
