//	@file Name: attemptCompileMissions.sqf
//	@file Author: AgentRev

private ["_missionsArray", "_missionsFolder"];

_missionsArray = _this select 0;
_missionsFolder = _this select 1;

{
	//Attempt to compile every mission for early bug detection
	compile preprocessFileLineNumbers format ["server\missions\%1\%2.sqf", _missionsFolder, _x select 0];
} forEach _missionsArray;
