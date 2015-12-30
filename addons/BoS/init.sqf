// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: init.sqf
//	@file Author: LouD
//	@file Description: BoS script

waitUntil {time > 0};
execVM "addons\BoS\BoS_SelectMenu.sqf";
waitUntil {!isNil "BoS_Initialized"};
[player] call BoS_Actions;