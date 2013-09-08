
//	@file Version: 1.0
//	@file Name: populateGunStore.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlisttext = _dialog displayCtrl genstore_item_TEXT;
_itempicture = _dialog displayCtrl genstore_item_pic;
_itemlist = _dialog displayCtrl genstore_item_list;
_cartlist = _dialog displayCtrl genstore_cart;
_itemInfo = _dialog displayCtrl genstore_item_Info;

//Clear the list
lbClear _itemlist;
lbClear _cartlist;
_itemlist lbSetCurSel -1;
_itempicture ctrlSettext "";
_itemlisttext ctrlSettext "";
_itemInfo ctrlSetStructuredText parseText "";

// Populate the gun shop weapon list
{
	_itemlistIndex = _itemlist lbAdd format["%1",_x select 0];
} forEach (call generalStore);		