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
	_missionTypes set [_forEachIndex, _x param [0, "", [""]]];
	_missionOdds set [_forEachIndex, _x param [1, 1, [1]]];
} forEach _missionsArray;

[_missionTypes, _missionOdds]
