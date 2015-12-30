// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: init.sqf
//	@file Author: LouD
//	@file Description: Door script

waitUntil {time > 0};
execVM "addons\Door\Door_SelectMenu.sqf";
waitUntil {!isNil "DoorScriptInitialized"};
[player] call Door_Actions;

