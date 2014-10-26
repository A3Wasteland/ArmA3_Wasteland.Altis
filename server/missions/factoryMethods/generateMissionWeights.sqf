// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: generateMissionWeights.sqf
//	@file Author: AgentRev

private ["_missionsArray", "_missionTypes", "_missionOdds"];
_missionsArray = _this;

_missionTypes = [];
_missionOdds = [];

{
	_missionTypes set [_forEachIndex, [_x, 0, "", [""]] call BIS_fnc_param];
	_missionOdds set [_forEachIndex, [_x, 1, 1, [1]] call BIS_fnc_param];
} forEach _missionsArray;

[_missionTypes, _missionOdds]
