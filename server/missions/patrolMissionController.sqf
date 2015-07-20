// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: patrolMissionController.sqf
//	@file Author: AgentRev

#define MISSION_CTRL_PVAR_LIST PatrolMissions
#define MISSION_CTRL_TYPE_NAME "Patrol"
#define MISSION_CTRL_FOLDER "patrolMissions"
#define MISSION_CTRL_DELAY (["A3W_patrolMissionDelay", 90*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE patrolMissionColor

#include "patrolMissions\patrolMissionDefines.sqf"
#include "missionController.sqf";
