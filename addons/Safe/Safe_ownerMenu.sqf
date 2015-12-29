// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: Safe_ownerMenu.sqf
//	@file Author: LouD / Cael817 for original script
//	@file Description: Safe script

#define Safe_Menu_option 17001
disableSerialization;

private ["_start","_panelOptions","_Safe_select","_displaySafe"];
_uid = getPlayerUID player;
if (!isNil "_uid") then {
	_start = createDialog "Safe_Menu";

	_displaySafe = uiNamespace getVariable "Safe_Menu";
	_Safe_select = _displaySafe displayCtrl Safe_Menu_option;

	_panelOptions = 
	[
		"Lock Safe",
		"Unlock Safe",
		"Change PIN"
	];

	{
		_Safe_select lbAdd _x;
	} forEach _panelOptions;
};