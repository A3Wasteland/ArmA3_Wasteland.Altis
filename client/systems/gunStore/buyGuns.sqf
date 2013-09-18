
//	@file Version: 1.0
//	@file Name: buyGuns.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]

#include "dialog\gunstoreDefines.sqf";

#define PURCHASED_CRATE_TYPE_AMMO 60
#define PURCHASED_CRATE_TYPE_WEAPON 61

#define GET_DISPLAY (findDisplay balca_debug_VC_IDD)
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
#define GET_SELECTED_DATA(a) ([##a] call {_idc = _this select 0;_selection = (lbSelection GET_CTRL(_idc) select 0);if (isNil {_selection}) then {_selection = 0};(GET_CTRL(_idc) lbData _selection)})
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitwith { _res = true };} forEach _types;_res}
disableSerialization;

private ["_name","_switch","_exe","_price","_dialog","_ammoList","_playerMoneyText","_playerMoney","_playerSlots","_itemText","_handleMoney","_class","_name","_mag","_type","_backpack","_gunsList","_weapon","_IsMagazine",
"_vestName"];

//Initialize Values
_switch = _this select 0;
_exe = 0;
_price = 0;
// Grab access to the controls
_dialog = findDisplay gunshop_DIALOG;
_gunsList = _dialog displayCtrl gunshop_gun_list;
_playerMoneyText = _Dialog displayCtrl gunshop_money;
_playerMoney = player getVariable "cmoney";
_playerSlots = [];
_itemText = "";
_handleMoney = 1;

_showInsufficientFundsError = 
{
  _itemText = _this select 0;
  hintSilent format["You don't have enought money for %1", _itemText];
  player say "FD_CP_Not_Clear_F";
  _handleMoney = 0;
};

_showInsufficientSpaceError = 
{
  _itemText = _this select 0;
  hintSilent format["You don't have enought space for %1", _itemText];
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

_showAlreadyHaveTypeMessage = 
{
	_itemText = _this select 0;
 	hintSilent format["You already have a %1. Please unequip before purchasing.", _itemText];
	player say "FD_CP_Not_Clear_F";
	_handleMoney = 1;
};

switch(_switch) do 
{
	//Buy To Player
	case 0: 
	{
		//get the item's text
		_itemText = lbText  [gunshop_gun_list, (lbCurSel gunshop_gun_list)];
		_playerSlots = [player] call BIS_fnc_invSlotsEmpty;
		
		{
			if(_itemText == _x select 0) then
			{
				_class = _x select 1;
				_weapon = (configFile >> "cfgWeapons" >> _class);
				_type = getNumber(_weapon >> "type");
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
				
				_type = getNumber (configFile >> "CfgWeapons" >> _class >> "type");
				if ((!([_class, 2] call isWeaponType)) || (handgunWeapon player == "")) then
				{
					player addWeapon _class;
				}
				else
				{
					if ([player, _class, "backpack"] call fn_fitsInventory) then { (unitBackpack player) addWeaponCargoGlobal [_class, 1]; }
					else{ ["sidearm"] call _showAlreadyHaveTypeMessage; breakTo "main"};
				};
			};
		}forEach (call pistolArray);
	
		{	if(_itemText == _x select 0) then
			{
				_class = _x select 1;
				_weapon = (configFile >> "cfgWeapons" >> _class);
				_type = getNumber(_weapon >> "type");
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
				
				_type = getNumber (configFile >> "CfgWeapons" >> _class >> "type");
				if ((!([_class, 1] call isWeaponType)) || (primaryWeapon player == "")) then
				{
					player addWeapon _class;
				}
				else
				{
					if ([player, _class, "backpack"] call fn_fitsInventory) then { (unitBackpack player) addWeaponCargoGlobal [_class, 1]; }
					else{ ["primary"] call _showAlreadyHaveTypeMessage; breakTo "main"};
				};
			};
		}forEach (call rifleArray);
			
		{
			if(_itemText == _x select 0) then
			{
				_class = _x select 1;
				_weapon = (configFile >> "cfgWeapons" >> _class);
				_type = getNumber(_weapon >> "type");
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
				
				_type = getNumber (configFile >> "CfgWeapons" >> _class >> "type");
				if ((!([_class, 1] call isWeaponType)) || (primaryWeapon player == "")) then
				{
					player addWeapon _class;
				}
				else
				{
					if ([player, _class, "backpack"] call fn_fitsInventory) then { (unitBackpack player) addWeaponCargoGlobal [_class, 1]; }
					else{ ["primary"] call _showAlreadyHaveTypeMessage; breakTo "main"};
				};
			};
		}forEach (call smgArray);
			
		{
			if(_itemText == _x select 0) then
			{
				_class = _x select 1;
				_weapon = (configFile >> "cfgWeapons" >> _class);
				_type = getNumber(_weapon >> "type");
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
				
				_type = getNumber (configFile >> "CfgWeapons" >> _class >> "type");
				if ((!([_class, 1] call isWeaponType)) || (primaryWeapon player == "")) then
				{
					player addWeapon _class;
				}
				else
				{
					if ([player, _class, "backpack"] call fn_fitsInventory) then { (unitBackpack player) addWeaponCargoGlobal [_class, 1]; }
					else{ ["primary"] call _showAlreadyHaveTypeMessage; breakTo "main"};
				};
			};
		}forEach (call shotgunArray);
			
		{
			if(_itemText == _x select 0) then
			{
				_class = _x select 1;
				_weapon = (configFile >> "cfgWeapons" >> _class);
				_type = getNumber(_weapon >> "type");
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
				
				_type = getNumber (configFile >> "CfgWeapons" >> _class >> "type");
				if ((!([_class, 4] call isWeaponType)) || (secondaryWeapon player == "")) then
				{
					player addWeapon _class;
				}
				else
				{
					if ([player, _class, "backpack"] call fn_fitsInventory) then { (unitBackpack player) addWeaponCargoGlobal [_class, 1]; }
					else{ ["secondary"] call _showAlreadyHaveTypeMessage; breakTo "main"};
				};
			};                    		
		}forEach (call launcherArray);
			

		{
			if(_itemText == _x select 0) then
			{
				_class = _x select 1;
				_name = _x select 1;
				_price = _x select 2;
				
				//ensure they player has enought money
				if (_price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
                _IsMagazine = isClass (configFile >> "cfgMagazines" >> _name);

                //handle magazine
                if(_IsMagazine) then
                {
                	if ([player, _class] call fn_fitsInventory) then
					{
						player addMagazine _class;
					}
					else { [_name] call _showInsufficientSpaceError; };
				}
				else
				{
					//handle item
					if ([player, _class] call fn_fitsInventory) then
					{
						player addItem _class;
					}
					else { [_name] call _showInsufficientSpaceError; };
				};
			}
		}forEach (call throwputArray);

		{
            if(_itemText == _x select 0) then
            {
                _class = _x select 1;
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
				switch((_x select 3)) do
                {
                    case "item":
                    {
        				if ([player, _class] call fn_fitsInventory) then
						{
							player addItem _class;
						}
						else { [_name] call _showInsufficientSpaceError; };
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
					//PURCHASED_CRATE_TYPE_WEAPON
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
        }forEach (call accessoriesArray);			
			
		{
            if(_itemText == _x select 0) then
            {
                _class = _x select 1;
				_price = _x select 2;
				
				//ensure they player has enought money
				if ( _price > parseNumber str(_playerMoney)) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
				switch((_x select 3)) do
                {
					case "backpack":
					{
						_backpackName = backpack player;

						removeBackpack player;
						player addBackpack _class;
					};
                };
			};
        }forEach (call backpackArray);

        		{
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
				[_itemText] call _showItemSpawnedOutsideMessage;				
			};
        }forEach (call staticGunsArray);
	};
};

if(_handleMoney == 1) then
{
	player setVariable["cmoney",_playerMoney - _price,true];
	_playerMoneyText CtrlsetText format["Cash: $%1", player getVariable "cmoney"];
}

