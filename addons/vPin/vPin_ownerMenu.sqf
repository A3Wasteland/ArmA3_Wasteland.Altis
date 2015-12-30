// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: vPin_ownerMenu.sqf
//	@file Author: LouD (Original author: Cael817)
//	@file Description: vPin script

#define vPin_Menu_option 17001
disableSerialization;

private ["_start","_panelOptions","_vPin_select","_displayvPin"];
_uid = getPlayerUID player;
if (!isNil "_uid") then 
{
	_start = createDialog "vPin_Menu";

	_displayvPin = uiNamespace getVariable "vPin_Menu";
	_vPin_select = _displayvPin displayCtrl vPin_Menu_option;

	_panelOptions = 
	[
		"Unlock Vehicle",
		"Lock Vehicle",
		"Change PIN"
	];

	{
		_vPin_select lbAdd _x;
	} forEach _panelOptions;
};