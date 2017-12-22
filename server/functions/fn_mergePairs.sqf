// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_mergePairs.sqf
//	@file Author: AgentRev

params [["_currPairs",[],[[]]], ["_newPairs",[],[[]]]];
private "_input";

{
	_input = [_currPairs];
	_input append _x;
	_input call fn_addToPairs;
} forEach _newPairs;

_currPairs
