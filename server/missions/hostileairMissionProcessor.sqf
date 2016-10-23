// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: hostileairMissionProcessor.sqf
//	@file Author: AgentRev

#define MISSION_PROC_TYPE_NAME "Hostile Air"
#define MISSION_PROC_TIMEOUT (["A3W_mainMissionTimeout", 60*60] call getPublicVar)
#define MISSION_PROC_COLOR_DEFINE hostileairMissionColor

#include "hostileairMissions\hostileairMissionDefines.sqf"
#include "missionProcessor.sqf";
