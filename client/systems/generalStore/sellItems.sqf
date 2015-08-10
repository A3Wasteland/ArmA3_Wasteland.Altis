// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: sellItems.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

if (!isNil "storeSellingHandle" && {typeName storeSellingHandle == "SCRIPT"} && {!scriptDone storeSellingHandle}) exitWith {hint "Please wait, your previous sale is being processed"};

#include "dialog\genstoreDefines.sqf";

storeSellingHandle = [] spawn
{
	disableSerialization;
	private ["_playerMoney", "_size", "_dialog", "_itemlist", "_totalText", "_playerMoneyText", "_itemIndex", "_itemText", "_itemData", "_price"];

	//Initialize Values
	_playerMoney = player getVariable "cmoney";
	_size = 0;

	// Grab access to the controls
	_dialog = findDisplay genstore_DIALOG;
	_itemlist = _dialog displayCtrl genstore_sell_list;
	_totalText = _dialog displayCtrl genstore_total;
	_playerMoneyText = _Dialog displayCtrl genstore_money;

	//Get Selected Item
	_itemIndex = lbCurSel _itemlist;
	_itemText = _itemlist lbText _itemIndex;
	_itemData = _itemlist lbData _itemIndex;

	{
		if (_itemText == _x select 0 && _itemData == _x select 1) exitWith
		{
			_price = _x select 5;
		};
	} forEach (call customPlayerItems);

	if (!isNil "_price") then
	{
		[_itemData, 1] call mf_inventory_remove;

		player setVariable ["cmoney", _playerMoney + _price, true];
		_playerMoneyText ctrlSetText format ["Cash: $%1", [player getVariable "cmoney"] call fn_numbersText];
		[] execVM "client\systems\generalStore\getInventory.sqf";
	};
};

if (typeName storeSellingHandle == "SCRIPT") then
{
	private "_storeSellingHandle";
	_storeSellingHandle = storeSellingHandle;
	waitUntil {scriptDone _storeSellingHandle};
};

storeSellingHandle = nil;
