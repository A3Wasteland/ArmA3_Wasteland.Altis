// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: buyVehicles.sqf
//	@file Author: His_Shadow, AgentRev
//	@file Created: 06/14/2013 05:13

scriptName "buyVehicles";

if (!isNil "storePurchaseHandle" && {typeName storePurchaseHandle == "SCRIPT"} && {!scriptDone storePurchaseHandle}) exitWith {hint "Please wait, your previous purchase is being processed"};

if (!isNil "vehicleStore_lastPurchaseTime") then
{
	_timeLeft = (["A3W_vehiclePurchaseCooldown", 60] call getPublicVar) - (diag_tickTime - vehicleStore_lastPurchaseTime);

	if (_timeLeft > 0) then
	{
		hint format ["You need to wait %1s before buying another vehicle", ceil _timeLeft];
		playSound "FD_CP_Not_Clear_F";
		breakOut "buyVehicles";
	};
};

#include "dialog\vehiclestoreDefines.hpp";

storePurchaseHandle = _this spawn
{
	disableSerialization;

	private ["_switch", "_playerMoney", "_price", "_dialog", "_playerMoneyText", "_itemlist", "_itemIndex", "_itemText", "_itemData", "_colorlist", "_colorIndex", "_colorText", "_colorData", "_applyVehProperties", "_class", "_price", "_requestKey", "_vehicle"];

	//Initialize Values
	_switch = _this select 0;
	_textureDir = "client\images\vehicleTextures";
	_playerMoney = player getVariable ["cmoney", 0];

	// Grab access to the controls
	_dialog = findDisplay vehshop_DIALOG;
	_playerMoneyText = _dialog displayCtrl vehshop_money;

	_itemlist = _dialog displayCtrl vehshop_veh_list;
	_itemIndex = lbCurSel vehshop_veh_list;
	_itemText = _itemlist lbText _itemIndex;
	_itemData = _itemlist lbData _itemIndex;

	_itemData = call compile _itemData; // [name, class, price, type, variant, ...]

	_colorlist = _dialog displayCtrl vehshop_color_list;
	_colorIndex = lbCurSel vehshop_color_list;
	_colorText = _colorlist lbText _colorIndex;
	_colorData = call compile (_colorlist lbData _colorIndex);

	_partList = _dialog displayCtrl vehshop_part_list;
	_defPartsChk = _dialog displayCtrl vehshop_defparts_checkbox;
	_animList = []; // ["anim1", 1, "anim2", 0, ...] - formatted for BIS_fnc_initVehicle

	if (!cbChecked _defPartsChk) then
	{
		for "_i" from 0 to (lbSize _partList - 1) do
		{
			_animList append [_partList lbData _i, (vehshop_list_checkboxTextures find (_partList lbPicture _i)) max 0];
		};
	};

	_showInsufficientFundsError =
	{
		hint parseText format ["Not enough money for<br/>""%1""", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	_showItemSpawnTimeoutError =
	{
		hint parseText format ["<t color='#ffff00'>An unknown error occurred.</t><br/>The purchase of ""%1"" has been cancelled.", _itemText];
		playSound "FD_CP_Not_Clear_F";
		_price = -1;
	};

	_showItemSpawnedOutsideMessage =
	{
		hint format ["""%1"" has been spawned outside, in front of the store.%2", _itemText, ["","\n\nVehicle saving will not start until manually enabled."] select ((objectFromNetId _object) getVariable ["A3W_skipAutoSave", false])];
		playSound "FD_Finish_F";
	};

	_applyVehProperties =
	{
		params ["_vehicle", "_colorText", "_colorData", "_animList"];

		if (count _colorData > 0) then
		{
			[_vehicle, _colorData] call applyVehicleTexture;
		};

		if (count _animList > 0) then
		{
			[_vehicle, false, _animList, true] remoteExecCall ["BIS_fnc_initVehicle", _vehicle];
		};

		// If UAV or UGV, fill vehicle with UAV AI, give UAV terminal to our player, and connect it to the vehicle
		if (unitIsUAV _vehicle) then
		{
			private _uavTerminal = configName (configFile >> "CfgWeapons" >> (switch (playerSide) do // retrieve case-sensitive name
			{
				case BLUFOR: { "B_UavTerminal" };
				case OPFOR:  { "O_UavTerminal" };
				default      { "I_UavTerminal" };
			}));

			if !(_uavTerminal in assignedItems player) then
			{
				{ player unassignItem _x } forEach ["ItemGPS", "B_UavTerminal", "O_UavTerminal", "I_UavTerminal"]; // Unassign any GPS slot item

				if (_uavTerminal in items player) then
				{
					player assignItem _uavTerminal;
				}
				else
				{
					player linkItem _uavTerminal;
				};
			};

			_vehicle spawn
			{
				params ["_uav"];
				private "_crewActive";
				_time = time;

				waitUntil {time - _time > 30 || {_crewActive = alive _uav && !(crew _uav isEqualTo []); _crewActive}};

				if (_crewActive) then
				{
					player connectTerminalToUav _uav;
				};
			};
		};

		_vehicle
	};

	if (_itemData isEqualType []) then
	{
		_class = _itemData param [1];
		_price = _itemData param [2];

		// Ensure the player has enough money
		if (_price > _playerMoney) exitWith
		{
			[_itemText] call _showInsufficientFundsError;
		};

		_requestKey = call A3W_fnc_generateKey;
		_itemData call requestStoreObject;

		_vehicle = objectFromNetId (missionNamespace getVariable _requestKey);

		if (!isNil "_vehicle" && {!isNull _vehicle}) then
		{
			[_vehicle, _colorText, if (!isNil "_colorData") then { _colorData } else { "" }, _animList] call _applyVehProperties;
		};
	};

	if (!isNil "_price" && {_price > -1}) then // vehicle price now handled in spawnStoreObject.sqf
	{
		vehicleStore_lastPurchaseTime = diag_tickTime;

		//player setVariable ["cmoney", _playerMoney - _price, true];
		//[player, -_price] call A3W_fnc_setCMoney;
		_playerMoneyText ctrlSetText format ["Cash: $%1", [player getVariable ["cmoney", 0]] call fn_numbersText];

		if (["A3W_playerSaving"] call isConfigOn) then
		{
			[] spawn fn_savePlayerData;
		};
	};

	if (!isNil "_requestKey" && {!isNil _requestKey}) then
	{
		missionNamespace setVariable [_requestKey, nil];
	};

	sleep 0.5; // double-click protection
};

if (typeName storePurchaseHandle == "SCRIPT") then
{
	private "_storePurchaseHandle";
	_storePurchaseHandle = storePurchaseHandle;
	waitUntil {scriptDone _storePurchaseHandle};
};

storePurchaseHandle = nil;
