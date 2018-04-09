// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: sellVehicleItems.sqf
//	@file Author: AgentRev

#define VEHICLE_MAX_SELLING_DISTANCE 50

#include "sellIncludesStart.sqf";

storeSellingHandle = _this spawn
{
	_storeNPC = _this select 0;
	_veh = objectFromNetId (player getVariable ["lastVehicleRidden", ""]);

	if (isNull _veh) exitWith
	{
		playSound "FD_CP_Not_Clear_F";
		["Your previous vehicle was not found.", "Error"] call  BIS_fnc_guiMessage;
	};

	_objClass = typeOf _veh;
	_objName = getText (configFile >> "CfgVehicles" >> _objClass >> "displayName");

	_checkValidDistance =
	{
		if (_veh distance _storeNPC > VEHICLE_MAX_SELLING_DISTANCE) then
		{
			playSound "FD_CP_Not_Clear_F";
			[format ['"%1" is further away than %2m from the store.', _objName, VEHICLE_MAX_SELLING_DISTANCE], "Error"] call  BIS_fnc_guiMessage;
			false
		} else { true };
	};

	_checkValidOwnership =
	{
		if (!local _veh) then
		{
			playSound "FD_CP_Not_Clear_F";
			[format ['You are not the owner of "%1", try getting in the driver seat.', _objName], "Error"] call  BIS_fnc_guiMessage;
			false
		} else { true };
	};

	if (!call _checkValidDistance) exitWith {};
	if (!call _checkValidOwnership) exitWith {};

	_sellValue = 0;
	_originalCargo = CARGO_STRING(_veh);

	// Get all the items
	_allVehItems = _veh call getSellPriceList;

	if (count _allVehItems == 0) exitWith
	{
		playSound "FD_CP_Not_Clear_F";
		[format ['"%1" does not contain valid items to sell.', _objName], "Error"] call BIS_fnc_guiMessage;
	};

	// Calculate total value
	{
		if (count _x > 3) then
		{
			_sellValue = _sellValue + (_x select 3);
		};
	} forEach _allVehItems;

	// Add total sell value to confirm message
	_confirmMsg = format ["You will obtain $%1 for:<br/>", [_sellValue] call fn_numbersText];

	// Add item quantities and names to confirm message
	{
		_item = _x select 0;
		_itemQty = _x select 1;

		if (_itemQty > 0 && {count _x > 2}) then
		{
			_itemName = _x select 2;
			_confirmMsg = _confirmMsg + format ["<br/>%1 x  %2%3", _itemQty, _itemName, if (PRICE_DEBUGGING) then { format [" ($%1)", [_x select 3] call fn_numbersText] } else { "" }];
		};
	} forEach _allVehItems;

	// Display confirmation
	if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
	{
		if (!call _checkValidDistance) exitWith {};
		if (!call _checkValidOwnership) exitWith {};

		// Check if somebody else manipulated the cargo since the start
		if (CARGO_STRING(_veh) != _originalCargo) exitWith
		{
			playSound "FD_CP_Not_Clear_F";
			[format ['The contents of "%1" have changed, please restart the selling process.', _objName], "Error"] call BIS_fnc_guiMessage;
		};

		// Have to spawn clearing commands due to mysterious game crash...
		_clearing = _veh spawn
		{
			clearBackpackCargoGlobal _this;
			clearMagazineCargoGlobal _this;
			clearWeaponCargoGlobal _this;
			clearItemCargoGlobal _this;
		};

		{
			_x params ["", "_item"];
			_veh setVariable [_item, nil, true];
		} forEach call customPlayerItems;

		waitUntil {scriptDone _clearing};

		//player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + _sellValue, true];
		[player, _sellValue] call A3W_fnc_setCMoney;

		hint format ['You sold the inventory of "%1" for $%2', _objName, _sellValue];
		playSound "FD_Finish_F";
	};
};

#include "sellIncludesEnd.sqf";
