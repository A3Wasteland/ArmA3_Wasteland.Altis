// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: init.sqf
//	@file Author: LouD
//	@file Description: vPin script

waitUntil {time > 0};
execVM "addons\vPin\vPin_SelectMenu.sqf";
waitUntil {!isNil "vPinScriptInitialized"};
[player] call vPin_Actions;

