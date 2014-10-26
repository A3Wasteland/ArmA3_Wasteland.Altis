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
