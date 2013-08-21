
//	@file Version: 1.0
//	@file Name: buysellSwitch.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

_dialog = findDisplay genstore_DIALOG;
_buysell = _dialog displayCtrl genstore_buysell;

//Check which state we want to be in.
_switchText = Ctrltext _buysell;
if(_switchText == "Buy") then
{
	[] execVM "client\systems\generalStore\buyItems.sqf";
	
} else {	
	[] execVM "client\systems\generalStore\sellItems.sqf";
};