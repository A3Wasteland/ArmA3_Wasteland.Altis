//	@file Version: 1.0
//	@file Name: weaponInfo.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

private["_weap_type","_picture","_price","_dialog","_itemlist","_itemlisttext","_selectedItem","_itemInfo","_itemText"];

//Initialize Values
_weap_type = "";
_picture = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlist = _dialog displayCtrl genstore_item_list;
_itemlisttext = _dialog displayCtrl genstore_item_TEXT;
_itemInfo = _dialog displayCtrl genstore_item_Info;

//Get Selected Item
_selectedItem = lbCurSel _itemlist;
_itemText = _itemlist lbText _selectedItem;

//Check which state we want to be in.
{if(_itemText == _x select 0) then{
	_price = _x select 2;
	
	_itemlisttext ctrlSetText format ["Price: $%1", _price];
	breakTo "main"	
}}forEach (call headArray);

{if(_itemText == _x select 0) then{
	_price = _x select 2;
	
	_itemlisttext ctrlSetText format ["Price: $%1", _price];	
	breakTo "main"
}}forEach (call uniformArray);

{if(_itemText == _x select 0) then{
	_price = _x select 2;
	
	_itemlisttext ctrlSetText format ["Price: $%1", _price];
	breakTo "main"	
}}forEach (call genItemArray);

{if(_itemText == _x select 0) then{
	_price = _x select 2;
	
	_itemlisttext ctrlSetText format ["Price: $%1", _price];	
	breakTo "main"	
}}forEach (call backpackArray);

{if(_itemText == _x select 0) then{
	_price = _x select 4;
	
	_itemlisttext ctrlSetText format ["Price: $%1", _price];
	breakTo "main"	
}}forEach (call generalStore);

{if(_itemText == _x select 0)then{
	_price = _x select 2;
	_itemlisttext ctrlSetText format ["Price: $%1", _price];
	breakTo "main"
}} forEach (call genObjectsArray);
