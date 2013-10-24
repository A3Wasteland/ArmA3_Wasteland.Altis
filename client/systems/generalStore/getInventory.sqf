
//	@file Version: 1.0
//	@file Name: getInventory.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

private ["_dialog", "_itemlisttext", "_itemlist", "_amount", "_index", "_listIndex", "_class"];

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlisttext = _dialog displayCtrl genstore_item_TEXT;
_itemlist = _dialog displayCtrl genstore_sell_list;

//Clear the list
lbClear _itemlist;
_itemlist lbSetCurSel -1;

playerInventory = [];

_amount = 0;
_index = 0;

_amount = MF_ITEMS_CANNED_FOOD call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "cannedfood"];
	_index = _index + 1;
};

_amount = MF_ITEMS_WATER call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "water"];
	_index = _index + 1;
};

//_amount = MF_ITEMS_MEDKIT call mf_inventory_count;
//for [{_x=1},{_x<=_amount},{_x=_x+1}] do
//{//
//	playerInventory set [_index, "medkit"];
//	_index = _index + 1;
//};

_amount = MF_ITEMS_REPAIR_KIT call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "repairkit"];
	_index = _index + 1;
};

_amount = MF_ITEMS_JERRYCAN_FULL call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "jerrycanfull"];
	_index = _index + 1;
};

_amount = MF_ITEMS_JERRYCAN_EMPTY call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "jerrycanempty"];
	_index = _index + 1;
};

_amount = MF_ITEMS_SPAWN_BEACON call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "spawnbeacon"];
	_index = _index + 1;
};
_amount = MF_ITEMS_CAMO_NET call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "camonet"];
	_index = _index + 1;
};
_amount = MF_ITEMS_SYPHON_HOSE call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "syphonhose"];
	_index = _index + 1;
};

_amount = MF_ITEMS_ENERGY_DRINK call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "energydrink"];
	_index = _index + 1;
};

_amount = MF_ITEMS_WARCHEST call mf_inventory_count;
for [{_x=1},{_x<=_amount},{_x=_x+1}] do
{
	playerInventory set [_index, "warchest"];
	_index = _index + 1;
};

{
	_class = _x;
	
	{
		if (_class == _x select 1) exitWith
		{
			_listIndex = _itemlist lbAdd format ["%1", _x select 0];
			_itemlist lbSetPicture [_listIndex, _x select 3];
			_itemlist lbSetData [_listIndex, _x select 1];
		};
	} forEach (call customPlayerItems);
} forEach playerInventory;
