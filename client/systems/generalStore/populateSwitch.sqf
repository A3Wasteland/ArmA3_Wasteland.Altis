
//	@file Version: 1.0
//	@file Name: populateSwitch.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

_dialog = findDisplay genstore_DIALOG;
_iteminv = _dialog displayCtrl genstore_iteminventory;

_switchText = Ctrltext _iteminv;

if(_switchText == "Inventory") then
{
	[] execVM "client\systems\generalStore\getInventory.sqf";
} else {	
	[] execVM "client\systems\generalStore\populateGenStore.sqf";
};