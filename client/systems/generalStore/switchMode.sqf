
//	@file Version: 1.0
//	@file Name: switchMode.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]

#include "dialog\genstoreDefines.sqf";
disableSerialization;
private ["_dialog", "_switch", "_switchText", "_buysell", "_iteminv", "_cartlist", "_itemlist", "_totalText", "_itemInfo"];
_dialog = findDisplay genstore_DIALOG;
_switch = _dialog displayCtrl genstore_switch;
_buysell = _dialog displayCtrl genstore_buysell;
_iteminv = _dialog displayCtrl genstore_iteminventory;
_cartlist = _dialog displayCtrl genstore_cart;
_itemlist = _dialog displayCtrl genstore_item_list;
_totalText = _dialog displayCtrl genstore_total;
_itemInfo = _dialog displayCtrl genstore_item_Info;

//Clear old data
genStoreCart = 0;
lbClear _cartlist;
lbClear _itemlist;
_totalText ctrlSetText format["Total: $%1", genStoreCart];
_itemInfo ctrlSetStructuredText parseText "";

//Check which state we want to be in.
_switchText = ctrlText _switch;
if(_switchText == "Sell Items") then
{
	_switch ctrlSetText "Buy Items";
	_buysell ctrlSetText "Sell";
	_iteminv ctrlSetText "Inventory";
	[] execVM "client\systems\generalStore\getInventory.sqf";
} else {	
	_switch ctrlSetText "Sell Items";
	_buysell ctrlSetText "Buy";
	_iteminv ctrlSetText "Items";
	[0] execVM "client\systems\generalStore\populateGenStore.sqf";
};
