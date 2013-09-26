//	@file Version: 1.0
//	@file Name: sellItems.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

//Initialize Values
_playerMoney = player getVariable "cmoney";
_size = 0;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_cartlist = _dialog displayCtrl genstore_cart;
_totalText = _dialog displayCtrl genstore_total;
_playerMoneyText = _Dialog displayCtrl genstore_money;
_size = lbSize _cartlist;

for [{_x=0},{_x<=_size},{_x=_x+1}] do
{
	_itemText = _cartlist lbText _x;
	if(_itemText == "Drinking Water") then {[MF_ITEMS_WATER, 1] call mf_inventory_remove;};
	if(_itemText == "Snack Food") then {[MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_remove;};
	if(_itemText == "Medical Kit") then {[MF_ITEMS_MEDKIT, 1] call mf_inventory_remove;};
	if(_itemText == "Repair Kit") then {[MF_ITEMS_REPAIR_KIT, 1] call mf_inventory_remove;};
    if(_itemText == "Jerry Can (Full)") then {[MF_ITEMS_JERRYCAN_FULL, 1] call mf_inventory_remove;};
    if(_itemText == "Jerry Can (Empty)") then {[MF_ITEMS_JERRYCAN_EMPTY, 1] call mf_inventory_remove;};
    if(_itemText == "Spawn Beacon") then {[MF_ITEMS_SPAWN_BEACON, 1] call mf_inventory_remove;};
	if(_itemText == "Camo Net") then {[MF_ITEMS_CAMO_NET, 1] call mf_inventory_remove;};
	if(_itemText == "Syphon Hose") then {[MF_ITEMS_SYPHON_HOSE, 1] call mf_inventory_remove;};
	if(_itemText == "Energy Drink") then {[MF_ITEMS_ENERGY_DRINK, 1] call mf_inventory_remove;};
	if(_itemText == "Warchest") then {[MF_ITEMS_ENERGY_DRINK, 1] call mf_inventory_remove;};
};

player setVariable["cmoney",_playerMoney + genStoreCart,true];
_playerMoneyText CtrlsetText format["Cash: $%1", player getVariable "cmoney"];

genStoreCart = 0;
_totalText CtrlsetText format["Total: $%1", genStoreCart];
lbClear _cartlist;
