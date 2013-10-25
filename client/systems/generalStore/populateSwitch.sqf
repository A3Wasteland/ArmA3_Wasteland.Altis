
//	@file Version: 1.0
//	@file Name: populateSwitch.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;
private ["_dialog", "_iteminv", "_switchText"];
_dialog = findDisplay genstore_DIALOG;
_iteminv = _dialog displayCtrl genstore_iteminventory;

_switchText = ctrlText _iteminv;

if(_switchText == "Inventory") then
{
	[] execVM "client\systems\generalStore\getInventory.sqf";
} else {	
	[0] execVM "client\systems\generalStore\populateGenStore.sqf";
};
