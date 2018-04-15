// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: sellVehicle.sqf
//	@file Author: AgentRev
//  @file edited: CRE4MPIE
//  @credits to: Cael817, lodac, Wiking

#include "sellIncludesStart.sqf";

storeSellingHandle = _this spawn
{
	#define CHOPSHOP_PRICE_RELATIONSHIP 2
	#define VEHICLE_MAX_SELLING_DISTANCE 50

	_storeNPC = _this select 0;
	_vehicle = objectFromNetId (player getVariable ["lastVehicleRidden", ""]);

	if (isNull _vehicle) exitWith
	{
		playSound "FD_CP_Not_Clear_F";
		["Your previous vehicle was not found.", "Error"] call  BIS_fnc_guiMessage;
	};

	_type = typeOf _vehicle;
	_objName = getText (configFile >> "CfgVehicles" >> _type >> "displayName");

	_checkValidDistance =
	{
		if (_vehicle distance _storeNPC > VEHICLE_MAX_SELLING_DISTANCE) then
		{
			playSound "FD_CP_Not_Clear_F";
			[format ['"%1" is further away than %2m from the store.', _objName, VEHICLE_MAX_SELLING_DISTANCE], "Error"] call  BIS_fnc_guiMessage;
			false
		} else { true };
	};

	_checkValidOwnership =
	{
		if (!local _vehicle) then
		{
			playSound "FD_CP_Not_Clear_F";
			[format ['You are not the owner of "%1", try getting in the driver seat.', _objName], "Error"] call  BIS_fnc_guiMessage;
			false
		} else { true };
	};

	if (!call _checkValidDistance) exitWith {};
	if (!call _checkValidOwnership) exitWith {};

	private _variant = _vehicle getVariable ["A3W_vehicleVariant", ""];
	if (_variant != "") then { _variant = "variant_" + _variant };

	_price = 1000;

	{
		if (_type == _x select 1 && (_variant == "" || {_variant in _x})) exitWith
		{
			_price = (ceil (((_x select 2) / CHOPSHOP_PRICE_RELATIONSHIP) / 5)) * 5;
		};
	} forEach (call allVehStoreVehicles + call staticGunsArray);

	if (!isNil "_price") then
	{
		// Add total sell value to confirm message
		_confirmMsg = format ["Selling the %1 will give you $%2<br/>", _objName, [_price] call fn_numbersText];

		// Display confirm message
		if ([parseText _confirmMsg, "Confirm", "Sell", true] call BIS_fnc_guiMessage) then
		{
			if (!call _checkValidDistance) exitWith {};
			if (!call _checkValidOwnership) exitWith {};

			if (_vehicle distance _storeNPC > VEHICLE_MAX_SELLING_DISTANCE) exitWith
			{
				playSound "FD_CP_Not_Clear_F";
				[format ['The %1 has already been sold!', _objname, VEHICLE_MAX_SELLING_DISTANCE], "Error"] call  BIS_fnc_guiMessage;
			};

			private _attachedObjs = attachedObjects _vehicle;
			deleteVehicle _vehicle;

			{ ["detach", _x] call A3W_fnc_towingHelper } forEach _attachedObjs;

			//player setVariable ["cmoney", (player getVariable ["cmoney",0]) + _price, true];
			[player, _price] call A3W_fnc_setCMoney;
			[format ['The %1 has been sold!', _objname, VEHICLE_MAX_SELLING_DISTANCE], "Thank You"] call  BIS_fnc_guiMessage;

			if (["A3W_playerSaving"] call isConfigOn) then
			{
				[] spawn fn_savePlayerData;
			};
		};
	}
	else
	{
		hint parseText "<t color='#FFFF00'>An unknown error occurred.</t><br/>Vehicle sale cancelled.";
		playSound "FD_CP_Not_Clear_F";
	};
};

#include "sellIncludesEnd.sqf";
