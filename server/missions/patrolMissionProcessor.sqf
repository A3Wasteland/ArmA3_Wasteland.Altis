// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: patrolMissionProcessor.sqf
//	@file Author: AgentRev

#define MISSION_PROC_TYPE_NAME "Patrol"
#define MISSION_PROC_TIMEOUT (["A3W_patrolMissionTimeout", 30*60] call getPublicVar)
#define MISSION_PROC_COLOR_DEFINE patrolMissionColor

#include "patrolMissions\patrolMissionDefines.sqf"
#include "missionProcessor.sqf";
