//	@file Version: 1.0
//	@file Name: loadGenStore.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

private ["_genshopDialog", "_Dialog", "_playerMoney", "_money", "_owner"];
_genshopDialog = createDialog "genstored";

_Dialog = findDisplay genstore_DIALOG;
_playerMoney = _Dialog displayCtrl genstore_money;
_money = player getVariable "cmoney";
_playerMoney ctrlSetText format["Cash: $%1", _money];
if(!isNil "_this") then {_owner = _this select 0;};
if(!isNil "_owner") then {currentOwnerName = name _owner;};
if(!isNil "_owner") then {currentOwnerID = _owner;};