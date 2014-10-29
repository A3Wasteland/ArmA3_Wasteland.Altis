// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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
