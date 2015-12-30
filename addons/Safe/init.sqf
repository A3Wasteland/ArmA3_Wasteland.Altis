// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: init.sqf
//	@file Author: LouD
//	@file Description: Safe script

waitUntil {time > 0};
execVM "addons\Safe\safe_SelectMenu.sqf";
waitUntil {!isNil "SafeScriptInitialized"};
[player] call Safe_Actions;

