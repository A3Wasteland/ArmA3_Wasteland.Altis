// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mainMissionController.sqf
//	@file Author: AgentRev

#define MISSION_CTRL_PVAR_LIST MainMissions
#define MISSION_CTRL_TYPE_NAME "Main"
#define MISSION_CTRL_FOLDER "mainMissions"
#define MISSION_CTRL_DELAY (["A3W_mainMissionDelay", 15*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE mainMissionColor

#include "mainMissions\mainMissionDefines.sqf"
#include "missionController.sqf";
