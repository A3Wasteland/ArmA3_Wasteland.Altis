// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mainMissionProcessor.sqf
//	@file Author: AgentRev

#define MISSION_PROC_TYPE_NAME "Main"
#define MISSION_PROC_TIMEOUT (["A3W_mainMissionTimeout", 60*60] call getPublicVar)
#define MISSION_PROC_COLOR_DEFINE mainMissionColor

#include "mainMissions\mainMissionDefines.sqf"
#include "missionProcessor.sqf";
