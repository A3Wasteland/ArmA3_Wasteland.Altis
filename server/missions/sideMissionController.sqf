// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: sideMissionController.sqf
//	@file Author: AgentRev

#define MISSION_CTRL_PVAR_LIST SideMissions
#define MISSION_CTRL_TYPE_NAME "Side"
#define MISSION_CTRL_FOLDER "sideMissions"
#define MISSION_CTRL_DELAY (["A3W_sideMissionDelay", 15*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE sideMissionColor

#include "sideMissions\sideMissionDefines.sqf"
#include "missionController.sqf";
