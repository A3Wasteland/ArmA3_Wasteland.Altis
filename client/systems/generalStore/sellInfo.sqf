//	@file Version: 1.0
//	@file Name: sellInfo.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;
private["_weap_type","_price","_dialog","_itemlist","_itemlisttext","_buysell","_itemInfo","_selectedItem","_itemText"];
//Initialize Values
_weap_type = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlist = _dialog displayCtrl genstore_sell_list;
_itemlisttext = _dialog displayCtrl genstore_sell_TEXT;
_itemInfo = _dialog displayCtrl genstore_item_Info;

//Get Selected Item
_selectedItem = lbCurSel _itemlist;
_itemText = _itemlist lbText _selectedItem;

{if(_itemText == _x select 0) then{
	_price = _x select 5;
	
	_itemlisttext ctrlSetText format ["Price: $%1", _price];
	breakTo "main"	
}}forEach (call generalStore);
