// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: moneyMissionProcessor.sqf
//	@file Author: AgentRev

#define MISSION_PROC_TYPE_NAME "Money"
#define MISSION_PROC_TIMEOUT (["A3W_moneyMissionTimeout", 60*60] call getPublicVar)
#define MISSION_PROC_COLOR_DEFINE moneyMissionColor

#include "moneyMissions\moneyMissionDefines.sqf"
#include "missionProcessor.sqf";
