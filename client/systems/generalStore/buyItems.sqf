//	@file Version: 1.0
//	@file Name: buyGuns.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, MercyfulFate
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]

#include "dialog\genstoreDefines.sqf";
disableSerialization;
if not(isNil "_Purchaseactive") then {if(_Purchaseactive == 1) exitWith {hint "Please do not spam the purschase button.. Wait for the transaction to complete"};};
if(genStoreCart > (player getVariable "cmoney")) exitWith {hint "You do not have enough money"};

//Initialize Values
_Purchaseactive = 1;
_playerMoney = player getVariable "cmoney";
_size = 0;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_cartlist = _dialog displayCtrl genstore_cart;
_totalText = _dialog displayCtrl genstore_total;
_playerMoneyText = _Dialog displayCtrl genstore_money;
_size = lbSize _cartlist;

if(_size <= 0) exitWith {hint "You have no items in the cart"};

for [{_x=0},{_x<=_size},{_x=_x+1}] do
{
	_itemText = _cartlist lbText _x;
    switch (_itemText) do {
        case "Bottled Water": {
			if not(MF_ITEMS_WATER call mf_inventory_is_full) then {
				[MF_ITEMS_WATER, 1] call mf_inventory_add;
            } else {
                _price = 0;
                {if(_x select 0 == "Bottled Water") then{_price = _x select 4;};}forEach (call generalStore);
            	genStoreCart = genStoreCart - _price;    
            };
        };
        
		case "Canned Food":	{
			if not(MF_ITEMS_CANNED_FOOD call mf_inventory_is_full) then {
				[MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_add;
            } else {
            	_price = 0;
                {if(_x select 0 == "Canned Food") then{_price = _x select 4;};}forEach (call generalStore);
            	genStoreCart = genStoreCart - _price;    
            };
        };
        
		case "Medical Kit": {
			if not(MF_ITEMS_MEDKIT call mf_inventory_is_full) then {
				[MF_ITEMS_MEDKIT, 1] call mf_inventory_add;
			} else {
            	_price = 0;
                {if(_x select 0 == "Medical Kit") then{_price = _x select 4;};}forEach (call generalStore);
            	genStoreCart = genStoreCart - _price;    
            };
        };
        
		case "Repair Kit": {
			if not(MF_ITEMS_REPAIR_KIT call mf_inventory_is_full) then {
				[MF_ITEMS_REPAIR_KIT, 1] call mf_inventory_add;
            } else {
            	_price = 0;
                {if(_x select 0 == "Repair Kit") then{_price = _x select 4;};}forEach (call generalStore);
            	genStoreCart = genStoreCart - _price;    
            };
        };
        
        case "Jerry Can (Full)": {
			if not(MF_ITEMS_JERRYCAN_FULL call mf_inventory_is_full) then {
				[MF_ITEMS_JERRYCAN_FULL, 1] call mf_inventory_add;
            } else {
				_price = 0;
				{if(_x select 0 == "Jerry Can (Full)") then{_price = _x select 4;};}forEach (call generalStore);
				genStoreCart = genStoreCart - _price;
            };
        };
        
        case "Jerry Can (Empty)": {
			if not(MF_ITEMS_JERRYCAN_EMPTY call mf_inventory_is_full) then {
				[MF_ITEMS_JERRYCAN_EMPTY, 1] call mf_inventory_add;
            } else {
            	_price = 0;
                {if(_x select 0 == "Jerry Can (Empty)") then{_price = _x select 4;};}forEach (call generalStore);
            	genStoreCart = genStoreCart - _price;
            };
        };
        case "Spawn Beacon": {
			if not(MF_ITEMS_SPAWN_BEACON call mf_inventory_is_full) then {
				[MF_ITEMS_SPAWN_BEACON, 1] call mf_inventory_add;
            } else {
            	_price = 0;
                {if(_x select 0 == "Spawn Beacon") then{_price = _x select 4;};}forEach (call generalStore);
            	genStoreCart = genStoreCart - _price;    
            };
        };
        case "Improv. roof": {
			if not(MF_ITEMS_CAMO_NET call mf_inventory_is_full) then {
				[MF_ITEMS_CAMO_NET, 1] call mf_inventory_add;
            } else {
            	_price = 0;
                {if(_x select 0 == "Improv. roof") then{_price = _x select 4;};}forEach (call generalStore);
            	genStoreCart = genStoreCart - _price;    
            };
        };
	};
};

player setVariable["cmoney",_playerMoney - genStoreCart,true];
_playerMoneyText CtrlsetText format["Cash: $%1", player getVariable "cmoney"];

genStoreCart = 0;
_totalText CtrlsetText format["Total: $%1", genStoreCart];
lbClear _cartlist;
_Purchaseactive = 0;
