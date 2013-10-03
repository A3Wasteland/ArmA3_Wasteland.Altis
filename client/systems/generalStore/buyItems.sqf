//	@file Version: 1.0
//	@file Name: buyGuns.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]

#include "dialog\genstoreDefines.sqf";

#define PURCHASED_CRATE_TYPE_AMMO 60
#define PURCHASED_CRATE_TYPE_WEAPON 61

disableSerialization;

private["_playerMoney","_size", "_price","_dialog","_itemlist","_totalText","_playerMoneyText","_handleMoney","_itemText", "_class",
        "_vestName", "_backpackName","_markerPos","_obj"];

if(genStoreCart > (player getVariable "cmoney")) exitWith {hintSilent "You do not have enough money for that"; player say "FD_CP_Not_Clear_F"; };

//Initialize Values
_playerMoney = player getVariable "cmoney";
_size = 0;
_price = 0;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlist = _dialog displayCtrl genstore_item_list;
_totalText = _dialog displayCtrl genstore_total;
_playerMoneyText = _Dialog displayCtrl genstore_money;
_handleMoney = 1;
_itemText = lbText [genstore_item_list, (lbCurSel genstore_item_list)];

_showInsufficientFundsError = 
{
	_itemText = _this select 0;
 	hintSilent format["You don't have enought money for %1", _itemText];
	player say "FD_CP_Not_Clear_F";
	_handleMoney = 0;
};

_showItemSpawnedOutsideMessage = 
{
	_itemText = _this select 0;
 	hintSilent format["%1 has been spawned outside.", _itemText];
	player say "FD_CP_Not_Clear_F";
	_handleMoney = 1;
};

{
	if(_itemText == _x select 0) then
    {
		_class = _x select 1;
		_price = _x select 2;
		
		//ensure they player has enought money
		if ( _price > parseNumber str(_playerMoney)) then { [_itemText] call _showInsufficientFundsError; breakTo "main"};
		_vestName = headgear player;
		removeHeadgear player;
		player addHeadgear _class;
    };
}forEach (call headArray);

{
	if(_itemText == _x select 0) then
    {
        _class = _x select 1;
		_price = _x select 2;
				
		//ensure they player has enought money
		if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
        _vestName = uniform player;
		removeUniform player;
        
        switch (_itemText) do
		{
			case "Ghillie Suit":
			{
				switch (faction player) do
				{
					case "BLU_F": { player addUniform "U_B_GhillieSuit" };
					case "OPF_F": { player addUniform "U_O_GhillieSuit" };
					default       { player addUniform "U_I_GhillieSuit" };
				};
			};
			case "Wetsuit":
			{
				switch (faction player) do
				{
					case "BLU_F": { player addUniform "U_B_Wetsuit" };
					case "OPF_F": { player addUniform "U_O_Wetsuit" };
					default       { player addUniform "U_I_Wetsuit" };
				};
			};
			case "Default Uniform": 
			{
				switch (faction player) do
				{
					case "BLU_F": { player addUniform "U_B_CombatUniform_mcam" };
					case "OPF_F": { player addUniform "U_O_CombatUniform_ocamo" };
					default       { player addUniform "U_I_CombatUniform" };
				};
			};
			default
			{
				player addUniform _class;
			};
		};
	};
}forEach (call uniformArray);

{
	if(_itemText == _x select 0) then
     {
		_class = _x select 1;
		_price = _x select 2;
		
		//ensure they player has enought money
		if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
		_vestName = vest player;
		removeVest player;
		
		switch (_itemText) do
		{
			case "Rebreather":
			{
				switch (faction player) do
				{
					case "BLU_F": { player addVest "V_RebreatherB" };
					case "OPF_F": { player addVest "V_RebreatherIR" };
					default { player addVest "V_RebreatherIA" };
				};
			};
			default
			{
				player addVest _class;
			};
		};
	};
}forEach (call vestArray);

{
    if(_itemText == _x select 0) then
    {
        _class = _x select 1;
		_price = _x select 2;
		
		//ensure they player has enought money
			if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; ;breakTo "main"};
		
					_backpackName = backpack player;

					removeBackpack player;
					player addBackpack _class;
	};
}forEach (call backpackArray);

{
	if(_itemText == _x select 0) then
            {
                _class = _x select 1;
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
				switch((_x select 3)) do
                {
                	case "binoc":
                    {
						player addWeapon _class;
                    };
                    case "item":
                    {
                        player addItem _class;
                    };
                    case "vest":
                    {
                        _vestName = vest player;

						removeVest player;
                        player addVest _class;
                    };
					case "backpack":
					{
						_backpackName = backpack player;

						removeBackpack player;
						player addBackpack _class;
					};
                    case "uni":
                    {
                        _vestName = uniform player;
						removeUniform player;
                        player addUniform _class;
                    };
                    case "hat":
                    {
                        _vestName = headgear player;
						removeHeadgear player;
                        player addHeadgear _class;
                    };
					case "gogg":
					{
						_vestName = goggles player;
                        removeGoggles player;
                        player addgoggles _class;
					};
					case "ammocrate":
					{
						[currentOwnerID, currentOwnerName, PURCHASED_CRATE_TYPE_AMMO] execVM "client\functions\placePurchasedCrate.sqf";
						//_playerPos = getPos player;
						//_ammoTypes = ["Box_NATO_Ammo_F","Box_NATO_Grenades_F","Box_NATO_AmmoOrd_F","Box_IND_Ammo_F","Box_IND_Grenades_F","Box_IND_AmmoOrd_F","Box_EAST_Ammo_F","Box_EAST_Grenades_F","Box_EAST_AmmoOrd_F"];
						//_sbox = createVehicle [_ammoTypes call BIS_fnc_selectRandom,[(_playerPos select 0), (_playerPos select 1),0],[], 0, "NONE"];
						//clearMagazineCargoGlobal _sbox;
						//clearWeaponCargoGlobal _sbox;
						//clearItemCargoGlobal _sbox;
					};
					case "weaponcrate":
					{
						[currentOwnerID, currentOwnerName, PURCHASED_CRATE_TYPE_WEAPON] execVM "client\functions\placePurchasedCrate.sqf";
						//_playerPos = getPos player;
						//_weaponTypes = ["Box_NATO_Wps_F","Box_NATO_WpsLaunch_F","Box_NATO_WpsSpecial_F","B_supplyCrate_F","Box_NATO_Support_F","Box_IND_Wps_F","Box_IND_WpsLaunch_F","Box_IND_WpsSpecial_F","I_supplyCrate_F","Box_IND_Support_F", "Box_EAST_Wps_F","Box_EAST_WpsLaunch_F","Box_EAST_WpsSpecial_F","O_supplyCrate_F","Box_EAST_Support_F"];
						//_sbox = createVehicle [_weaponTypes call BIS_fnc_selectRandom,[(_playerPos select 0), (_playerPos select 1),0],[], 0, "NONE"];
						//clearMagazineCargoGlobal _sbox;
						//clearWeaponCargoGlobal _sbox;
						//clearItemCargoGlobal _sbox;
					};
                    case default
                    {
                        
                    };
                };
			};
}forEach (call genItemArray);

{
	if(_itemText == _x select 0) then
	{
		_price = _x select 4;
		if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
		switch (_itemText) do 
		{
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
		//populate the inventory items
		[] execVM "client\systems\generalStore\getInventory.sqf";
	};
}forEach (call generalStore);

{
	//if the names match attempt to purchase the item
	if(_itemText == _x select 0) then
	{
		//collect the class name and price
		_class = _x select 1;
		_price = _x select 2;
		
		//ensure they player has enought money
		if ( _price > parseNumber str(_playerMoney)) then { [_itemText] call _showInsufficientFundsError; breakTo "main"};

		//get the marker at which we will spawn this object
		_markerPos = (getMarkerPos format ["spawn_%1", currentOwnerID]);
		_obj = createVehicle [_class,_markerPos,[],0,"None"];
		_obj addeventhandler ["hit", {(_this select 0) setdamage 0;}];
		_obj addeventhandler ["dammaged", {(_this select 0) setdamage 0;}];
		[_itemText] call _showItemSpawnedOutsideMessage;
	};
}forEach (call genObjectsArray);

if(_handleMoney == 1) then
{
	player setVariable["cmoney",_playerMoney - _price,true];
	_playerMoneyText CtrlsetText format["Cash: $%1", player getVariable "cmoney"];
}
