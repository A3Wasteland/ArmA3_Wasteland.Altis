// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: switchMoveGlobal.sqf
//	@file Author: AgentRev

params [["_unit",objNull,[objNull]], ["_move","",[""]]];

pvar_switchMoveGlobal = [_unit, _move];
publicVariable "pvar_switchMoveGlobal";

_unit switchMove _move;
