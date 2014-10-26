// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: moneyMissionController.sqf
//	@file Author: AgentRev

#define MISSION_CTRL_PVAR_LIST MoneyMissions
#define MISSION_CTRL_TYPE_NAME "Money"
#define MISSION_CTRL_FOLDER "moneyMissions"
#define MISSION_CTRL_DELAY (["A3W_moneyMissionDelay", 15*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE moneyMissionColor

#include "moneyMissions\moneyMissionDefines.sqf";
#include "missionController.sqf";
