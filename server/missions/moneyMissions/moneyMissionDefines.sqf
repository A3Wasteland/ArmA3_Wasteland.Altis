// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: moneyMissionController.sqf
//	@file Author: His_Shadow
//	@file Created: 07/09/2013 15:19

#define moneyMissionColor "#00DE00"
#define failMissionColor "#FF1717"
#define successMissionColor "#17FF41"
#define subTextColor "#FFFFFF"

#define AI_GROUP_SMALL 4
#define AI_GROUP_MEDIUM 7
#define AI_GROUP_LARGE 10

#define missionDifficultyHard (["A3W_missionsDifficulty", 0] call getPublicVar >= 1)
