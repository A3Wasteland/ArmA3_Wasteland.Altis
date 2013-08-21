
//	@file Version: 1.0
//	@file Name: getInventory.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlisttext = _dialog displayCtrl genstore_item_TEXT;
_totalText = _dialog displayCtrl genstore_total;
_itempicture = _dialog displayCtrl genstore_item_pic;
_itemlist = _dialog displayCtrl genstore_item_list;
_cartlist = _dialog displayCtrl genstore_cart;
_itemInfo = _dialog displayCtrl genstore_item_Info;

//Clear the list
genStoreCart = 0;
lbClear _itemlist;
lbClear _cartlist;
_itemlist lbSetCurSel -1;
_itempicture ctrlSettext "";
_itemlisttext ctrlSettext "";
_totalText CtrlsetText format["Total: $%1", genStoreCart];
_itemInfo ctrlSetStructuredText parseText "";

playerInventory = [];

_amount = 0;
_index = 0;

_amount = MF_ITEMS_CANNED_FOOD call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "Canned Food"];
	_index = _index + 1;
};

_amount = MF_ITEMS_WATER call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "Bottled Water"];
	_index = _index + 1;
};

_amount = MF_ITEMS_MEDKIT call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "Medical Kit"];
	_index = _index + 1;
};

_amount = MF_ITEMS_REPAIR_KIT call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "Repair Kit"];
	_index = _index + 1;
};

_amount = MF_ITEMS_JERRYCAN_FULL call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "Jerry Can (Full)"];
	_index = _index + 1;
};

_amount = MF_ITEMS_JERRYCAN_EMPTY call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "Jerry Can (Empty)"];
	_index = _index + 1;
};

_amount = MF_ITEMS_SPAWN_BEACON call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "Spawn Beacon"];
	_index = _index + 1;
};
_amount = MF_ITEMS_CAMO_NET call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "Improv. roof"];
	_index = _index + 1;
};

{
	_itemlistIndex = _itemlist lbAdd format["%1",_x];
} forEach playerInventory;