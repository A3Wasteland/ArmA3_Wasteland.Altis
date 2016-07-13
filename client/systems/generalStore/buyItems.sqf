// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: buyItems.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = buy to player 1 = buy to crate)]

if (!isNil "storePurchaseHandle" && {typeName storePurchaseHandle == "SCRIPT"} && {!scriptDone storePurchaseHandle}) exitWith {hint "Please wait, your previous purchase is being processed"};

#include "dialog\genstoreDefines.sqf";

#define PURCHASED_CRATE_TYPE_AMMO 60
#define PURCHASED_CRATE_TYPE_WEAPON 61

#define CEIL_PRICE(PRICE) (ceil ((PRICE) / 5) * 5)

storePurchaseHandle = _this spawn
{
	disableSerialization;

	private ["_playerMoney", "_size", "_price", "_dialog", "_itemlist", "_totalText", "_playerMoneyText", "_itemText", "_class", "_uniformClass", "_vestClass", "_backpackClass", "_itemClass", "_markerPos", "_obj", "_currentBinoc", "_confirmResult", "_successHint", "_hasNVG", "_requestKey"];

	//Initialize Values
	_playerMoney = player getVariable ["cmoney", 0];
	_successHint = true;

	// Grab access to the controls
	_dialog = findDisplay genstore_DIALOG;
	_itemlist = _dialog displayCtrl genstore_item_list;
	_totalText = _dialog displayCtrl genstore_total;
	_playerMoneyText = _Dialog displayCtrl genstore_money;

	_itemIndex = lbCurSel genstore_item_list;
	_itemText = _itemlist lbText _itemIndex;
	_itemData = _itemlist lbData _itemIndex;

	_showInsufficientFundsError =
	{
		_itemText = _this select 0;
		hint parseText format ["Not enough money for<br/>""%1""", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	_showInsufficientSpaceError =
	{
		_itemText = _this select 0;
		hint parseText format ["Not enough space for<br/>""%1""", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	_showItemSpawnTimeoutError =
	{
		_itemText = _this select 0;
		hint parseText format ["<t color='#ffff00'>An unknown error occurred.</t><br/>The purchase of ""%1"" has been cancelled.", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	_showItemSpawnedOutsideMessage =
	{
		_itemText = _this select 0;
		hint format ["""%1"" has been spawned outside, in front of the store.", _itemText];
		playSound "FD_Finish_F";
		_successHint = false;
	};

	_showReplaceConfirmMessage =
	{
		_itemText = _this select 0;

		if (param [1, false, [false]]) then
		{
			_itemText = format ["Purchasing these %1 will replace your current ones.", _itemText];
		}
		else
		{
			if (param [2, false, [false]]) then
			{
				_itemText = format ["Purchasing this %1 will replace your current one.", _itemText];
			}
			else
			{
				_itemText = format ["Purchasing this %1 will replace your current one, and its contents will be lost.", _itemText];
			};
		};

		_confirmResult = [parseText _itemText, "Confirm", "Buy", true] call BIS_fnc_guiMessage;

		if (!_confirmResult) then
		{
			_price = -1;
		};

		_confirmResult
	};

	_showAlreadyHaveItemMessage =
	{
		_itemText = _this select 0;

		if (param [1, false, [false]]) then
		{
			_itemText = format ["You already have these %1.", _itemText];
		}
		else
		{
			_itemText = format ["You already have this %1.", _itemText];
		};

		playSound "FD_CP_Not_Clear_F";
		_price = -1;

		[parseText _itemText, "Error"] call BIS_fnc_guiMessage
	};

	if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;

				if (_x select 3 == "vest") then
				{
					([_class] call fn_getItemArmor) params ["_ballArmor", "_explArmor"];
					_price = CEIL_PRICE(([_class] call getCapacity) / 2 + _ballArmor*3 + _explArmor*2); // price formula also defined in getItemInfo.sqf
				}
				else
				{
					_price = _x select 2;
				};

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				switch (_x select 3) do
				{
					case "binoc":
					{
						_currentBinoc = binocular player;

						if (_currentBinoc == "") then
						{
							if (_class select [0,15] == "Laserdesignator" && {{_x == "Laserbatteries"} count magazines player == 0}) then
							{
								[player, "Laserbatteries"] call fn_forceAddItem;
							};

							player addWeapon _class;
						}
						else
						{
							if !([player, _class] call addWeaponInventory) then
							{
								[_itemText] call _showInsufficientSpaceError;
							};
						};
					};
					case "item":
					{
						if ([player, _class] call fn_fitsInventory) then
						{
							[player, _class] call fn_forceAddItem;
						}
						else
						{
							[_itemText] call _showInsufficientSpaceError;
						};
					};
					case "mag":
					{
						if ([player, _class] call fn_fitsInventory) then
						{
							[player, _class] call fn_forceAddItem;
						}
						else
						{
							[_itemText] call _showInsufficientSpaceError;
						};
					};
					case "backpack":
					{
						if (backpack player == _class) exitWith
						{
							["backpack"] call _showAlreadyHaveItemMessage;
						};

						// Confirm replace
						if (backpack player != "" && {!(["backpack"] call _showReplaceConfirmMessage)}) exitWith {};

						removeBackpack player;
						player addBackpack _class;
					};
					case "gogg":
					{
						if (goggles player == _class) exitWith
						{
							["goggles", true] call _showAlreadyHaveItemMessage;
						};

						// Confirm replace
						if (goggles player != "" && {!(["goggles", true] call _showReplaceConfirmMessage)}) exitWith {};

						removeGoggles player;
						player addGoggles _class;
					};
					case "nvg":
					{
						if ({["NVGoggles", _x] call fn_startsWith} count assignedItems player == 0) then
						{
							player linkItem _class;
						}
						else
						{
							if ([player, _class] call fn_fitsInventory) then
							{
								[player, _class] call fn_forceAddItem;
							}
							else
							{
								[_itemText] call _showInsufficientSpaceError;
							};
						};
					};
					case "gps":
					{
						if ({_x in ["ItemGPS", "B_UavTerminal", "O_UavTerminal", "I_UavTerminal"]} count assignedItems player == 0) then
						{
							player linkItem _class;
						}
						else
						{
							if ([player, _class] call fn_fitsInventory) then
							{
								[player, _class] call fn_forceAddItem;
							}
							else
							{
								[_itemText] call _showInsufficientSpaceError;
							};
						};
					};
					// Crates transferred to genObjectsArray below
					/*case "ammocrate":
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
					};*/
				};
			};
		} forEach (call genItemArray);
	};

	if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;
				_price = _x select 2;

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				_requestKey = call A3W_fnc_generateKey;
				call requestStoreObject;
			};
		} forEach (call genObjectsArray);
	};

	if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_price = _x select 4;

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				if !(_itemData call mf_inventory_is_full) then
				{
					[_itemData, 1] call mf_inventory_add;
				}
				else
				{
					[_itemText] call _showInsufficientSpaceError;
				};

				//populate the inventory items
				[] execVM "client\systems\generalStore\getInventory.sqf";
			};
		} forEach (call customPlayerItems);
	};

	if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;
				_price = _x select 2;

				if (headgear player == _class) exitWith
				{
					["headgear"] call _showAlreadyHaveItemMessage;
				};

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				// Confirm replace
				if (headgear player != "" && {!(["headgear", false, true] call _showReplaceConfirmMessage)}) exitWith {};

				removeHeadgear player;
				player addHeadgear _class;
			};
		} forEach (call headArray);
	};

	if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;
				_price = _x select 2;

				if (uniform player == _class) exitWith
				{
					["uniform"] call _showAlreadyHaveItemMessage;
				};

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				// Confirm replace
				if (uniform player != "" && {!(["uniform"] call _showReplaceConfirmMessage)}) exitWith {};

				removeUniform player;
				player forceAddUniform _class;
			};
		} forEach (call uniformArray);
	};

	if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;
				_price = _x select 2;

				if (_price < 0) then
				{
					_price = [_class] call getCapacity;
				};

				if (vest player == _class) exitWith
				{
					["vest"] call _showAlreadyHaveItemMessage;
				};

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				// Confirm replace
				if (vest player != "" && {!(["vest"] call _showReplaceConfirmMessage)}) exitWith {};

				removeVest player;
				player addVest _class;
			};
		} forEach (call vestArray);
	};

	if (isNil "_price") then
	{
		{
			if (_itemData == _x select 1) exitWith
			{
				_class = _x select 1;
				_price = _x select 2;

				if (backpack player == _class) exitWith
				{
					["backpack"] call _showAlreadyHaveItemMessage;
				};

				// Ensure the player has enough money
				if (_price > _playerMoney) exitWith
				{
					[_itemText] call _showInsufficientFundsError;
				};

				// Confirm replace
				if (backpack player != "" && {!(["backpack"] call _showReplaceConfirmMessage)}) exitWith {};

				removeBackpack player;
				player addBackpack _class;
			};
		} forEach (call backpackArray);
	};

	if (!isNil "_price" && {_price > -1}) then
	{
		_playerMoney = player getVariable ["cmoney", 0];

		// Re-check for money after purchase
		if (_price > _playerMoney) then
		{
			if (!isNil "_requestKey" && {!isNil _requestKey}) then
			{
				deleteVehicle objectFromNetId (missionNamespace getVariable _requestKey);
			};

			[_itemText] call _showInsufficientFundsError;
		}
		else
		{
			player setVariable ["cmoney", _playerMoney - _price, true];
			_playerMoneyText ctrlSetText format ["Cash: $%1", [player getVariable ["cmoney", 0]] call fn_numbersText];
			if (_successHint) then { hint "Purchase successful!" };
			playSound "FD_Finish_F";
		};
	};

	if (!isNil "_requestKey" && {!isNil _requestKey}) then
	{
		missionNamespace setVariable [_requestKey, nil];
	};

	sleep 0.25; // double-click protection
};

if (typeName storePurchaseHandle == "SCRIPT") then
{
	private "_storePurchaseHandle";
	_storePurchaseHandle = storePurchaseHandle;
	waitUntil {scriptDone _storePurchaseHandle};
};

storePurchaseHandle = nil;
