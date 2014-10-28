// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: sellInfo.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;
private ["_weap_type", "_price", "_dialog", "_itemlist", "_itemlisttext", "_buysell", "_itemInfo", "_itemIndex", "_itemText", "_itemData"];

//Initialize Values
_weap_type = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlist = _dialog displayCtrl genstore_sell_list;
_itemlisttext = _dialog displayCtrl genstore_sell_TEXT;
_itemInfo = _dialog displayCtrl genstore_item_Info;

//Get Selected Item
_itemIndex = lbCurSel _itemlist;
_itemText = _itemlist lbText _itemIndex;
_itemData = _itemlist lbData _itemIndex;

{
	if (_itemText == _x select 0 && _itemData == _x select 1) exitWith
	{
		_price = _x select 5;
		_itemlisttext ctrlSetText format ["Value: $%1", [_price] call fn_numbersText];
	}
} forEach (call customPlayerItems);
