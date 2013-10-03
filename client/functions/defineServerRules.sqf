//	@file Version: 1.0
//	@file Name: defineServerRules.sqf
//	@file Author: AgentRev
//	@file Created: 13/07/2013 21:23

if (!hasInterface) exitWith {};

if !(player diarySubjectExists "rules") then
{
	waitUntil {player diarySubjectExists "credits"};
	player createDiarySubject ["rules", "Server Rules"];
	player createDiaryRecord ["rules", ["Rules", _this select 0]];
};
