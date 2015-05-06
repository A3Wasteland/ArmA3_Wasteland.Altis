// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: extraMissionController.sqf
//	@file Author: AgentRev

#define MISSION_CTRL_PVAR_LIST ExtraMissions
#define MISSION_CTRL_TYPE_NAME "Extra"
#define MISSION_CTRL_FOLDER "extraMissions"
#define MISSION_CTRL_DELAY (["A3W_extraMissionDelay", 10*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE extraMissionColor

#include "extraMissions\extraMissionDefines.sqf"
#include "missionController.sqf";
