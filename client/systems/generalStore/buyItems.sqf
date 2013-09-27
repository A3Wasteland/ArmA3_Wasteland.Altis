//	@file Version: 1.0
//	@file Name: buyGuns.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]

#include "dialog\genstoreDefines.sqf";

if (!isNil "storePurchaseHandle" && {!scriptDone storePurchaseHandle}) exitWith {hint "Please wait, your previous purchase is being processed"};

if (genStoreCart > player getVariable ["cmoney", 0]) then
{
	hint "You do not have enough money";
}
else
{
	storePurchaseHandle = _this spawn
	{
		disableSerialization;

		//Initialize Values
		_playerMoney = player getVariable ["cmoney", 0];
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
				case "Drinking Water": {
					if not(MF_ITEMS_WATER call mf_inventory_is_full) then {
						[MF_ITEMS_WATER, 1] call mf_inventory_add;
					} else {
						_price = 0;
						{if(_x select 0 == "Drinking Water") then{_price = _x select 4;};}forEach (call generalStore);
						genStoreCart = genStoreCart - _price;    
					};
				};
				
				case "Snack Food":	{
					if not(MF_ITEMS_CANNED_FOOD call mf_inventory_is_full) then {
						[MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_add;
					} else {
						_price = 0;
						{if(_x select 0 == "Snack Food") then{_price = _x select 4;};}forEach (call generalStore);
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
				case "Camo Net": {
					if not(MF_ITEMS_CAMO_NET call mf_inventory_is_full) then {
						[MF_ITEMS_CAMO_NET, 1] call mf_inventory_add;
					} else {
						_price = 0;
						{if(_x select 0 == "Camo Net") then{_price = _x select 4;};}forEach (call generalStore);
						genStoreCart = genStoreCart - _price;    
					};
				};
				case "Syphon Hose": {
					if not(MF_ITEMS_SYPHON_HOSE call mf_inventory_is_full) then {
						[MF_ITEMS_SYPHON_HOSE, 1] call mf_inventory_add;
		            } else {
		            	_price = 0;
		                {if(_x select 0 == "Syphon Hose") then{_price = _x select 4;};}forEach (call generalStore);
		            	genStoreCart = genStoreCart - _price;    
		            };
				};
		        case "Energy Drink": {
		            if not(MF_ITEMS_ENERGY_DRINK call mf_inventory_is_full) then {
		                [MF_ITEMS_ENERGY_DRINK, 1] call mf_inventory_add;
		            } else {
		                _price = 0;
		                {if(_x select 0 == "Energy Drink") then{_price = _x select 4;};}forEach (call generalStore);
		                genStoreCart = genStoreCart - _price;    
		            };
		        };
		        case "Warchest": {
		            if not(MF_ITEMS_WARCHEST call mf_inventory_is_full) then {
		                [MF_ITEMS_WARCHEST, 1] call mf_inventory_add;
		            } else {
		                _price = 0;
		                {if(_x select 0 == "Warchest") then{_price = _x select 4;};}forEach (call generalStore);
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
	};
	
	_storePurchaseHandle = storePurchaseHandle;
	waitUntil {scriptDone _storePurchaseHandle};
	
	storePurchaseHandle = nil;
};
