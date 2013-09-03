
//	@file Version: 1.0
//	@file Name: buyGuns.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]

#include "dialog\gunstoreDefines.sqf";
if not(isNil "_Purchaseactive") then {if(_Purchaseactive == 1) exitWith {hint "Please do not spam the purschase button.. Wait for the transaction to complete"};};
if(gunStoreCart > (player getVariable "cmoney")) exitWith {hint "You do not have enough money"};
_Purchaseactive = 1;
private ["_name"];
disableSerialization;




//Initialize Values
_switch = _this select 0;

_playerMoney = player getVariable "cmoney";
_size = 0;
_price = 0;
// Grab access to the controls
_dialog = findDisplay gunshop_DIALOG;
_cartlist = _dialog displayCtrl gunshop_cart;
_totalText = _dialog displayCtrl gunshop_total;
_playerMoneyText = _Dialog displayCtrl gunshop_money;
_size = lbSize _cartlist;

_notEnoughSpace = "You do not have space for ""%1"""; 
_alreadyHaveType = "You already have a weapon of this type, please unequip it before purchasing ""%1"""; 

switch (_switch) do 
{
	//Buy To Player
	case 0: 
	{
		for "_x" from 0 to (_size - 1) do
		{
			_itemText = _cartlist lbText _x;
			//0 = Primary, 1 = SideArm, 2 = Secondary, 3 = HandGun Mags, 4 = MainGun Mags, 5 = Binocular, 7 =Compass Slots
			_playerSlots = [player] call BIS_fnc_invSlotsEmpty; 
			
			{
				_name = _x select 0;
				
				if (_itemText == _name) then
				{
					_class = _x select 1;
					_type = getNumber (configFile >> "CfgWeapons" >> _class >> "type");
					
					if ((_type == 1 && (_playerSlots select 0) > 0) || {_type == 2 && (_playerSlots select 1) > 0} || {_type == 4 && (_playerSlots select 2) > 0}) then
					{
						player addWeapon _class;
					}
					else
					{
						gunStoreCart = gunStoreCart - (_x select 2);
						hint format [_alreadyHaveType,_name];  
					};
				};
			} forEach (call weaponsArray);

			{
				_name = _x select 0;
				
				if (_itemText == _name) then
				{
					_class = _x select 1;
					_type = getNumber (configFile >> "CfgMagazines" >> _class >> "type");
					
					if ([player, _class] call fn_fitsInventory) then
					{
						player addMagazine _class;
					}
					else
					{
						gunStoreCart = gunStoreCart - (_x select 2);
						hint format [_notEnoughSpace,_name];
					};
				}
			} forEach (call ammoArray);

			{
				_name = _x select 0;
				
                if (_itemText == _name) then
                {
                    _class = _x select 1;
					
					switch (_x select 3) do
                    {
                    	case "binoc":
                        {
                            if ((_playerSlots select 5) > 0 || {[player, _class] call fn_fitsInventory}) then
							{
								player addWeapon _class;
							}
							else
							{
								gunStoreCart = gunStoreCart - (_x select 2);
								hint format [_notEnoughSpace,_name];
							};
                        };
                        case "item":
                        {
							if ([player, _class] call fn_fitsInventory) then
							{
								player addItem _class;
							}
							else
							{
								gunStoreCart = gunStoreCart - (_x select 2);
								hint format [_notEnoughSpace,_name];
							};
                        };
						case "backpack":
						{
							if (backpack player == "") then
							{
								player addBackpack _class;
							}
							else
							{
								gunStoreCart = gunStoreCart - (_x select 2);
								hint format["You already have a backpack, please drop it before buying a new one"]; 
							};
						};
						case "uni":
						{
							if (uniform player == "") then
							{
							switch (_name) do
								{
									case "Ghillie Suit":
									{
										switch (faction player) do
										{
											case "BLU_F": { player addUniform "U_B_GhillieSuit" };
											case "OPF_F": { player addUniform "U_O_GhillieSuit" };
											default { player addUniform "U_I_GhillieSuit" };
										};
									};
									case "Wetsuit":
									{
										switch (faction player) do
										{
											case "BLU_F": { player addUniform "U_B_Wetsuit" };
											case "OPF_F": { player addUniform "U_O_Wetsuit" };
											default { player addUniform "U_I_Wetsuit" };
										};
									};
									default
									{
										player addUniform _class;
									};
								};
							}
							else
							{
								gunStoreCart = gunStoreCart - (_x select 2);
								hint format["You already have an uniform, please sell it before buying a new one"];
							};
						};
                        case "hat":
                        {
                            if (headgear player == "") then
                            {
                                player addHeadgear _class;
                            }
                            else
                            {
								gunStoreCart = gunStoreCart - (_x select 2);
								hint format["You already have headgear, please drop it before buying a new one"]; 
                            };
                        };
						case "vest":
                        {
                            if (vest player == "") then
                            {
								switch (_name) do
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
							}
							else
                            {
								gunStoreCart = gunStoreCart - (_x select 2);
								hint format["You already have a vest, please drop them before buying a new one"]; 
                            };
                        };
                    };
				};
            } forEach (call accessoriesArray);
		};
		player setVariable["cmoney",_playerMoney - gunStoreCart,true];
		_playerMoneyText CtrlsetText format["Cash: $%1", player getVariable "cmoney"];
		lbClear _cartlist;
		gunStoreCart = 0;
		_totalText CtrlsetText format["Total: $%1", gunStoreCart];
		_Purchaseactive = 0;
	};
};
