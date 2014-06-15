//	@file Version: 1.0
//	@file Name: buyVehicles.sqf
//	@file Author: His_Shadow, AgentRev
//	@file Created: 06/14/2013 05:13

if (!isNil "storePurchaseHandle" && {typeName storePurchaseHandle == "SCRIPT"} && {!scriptDone storePurchaseHandle}) exitWith {hint "Please wait, your previous purchase is being processed"};

#include "dialog\vehiclestoreDefines.hpp";

storePurchaseHandle = _this spawn
{
	disableSerialization;
	
	private ["_switch", "_playerMoney", "_price", "_dialog", "_playerMoneyText", "_itemlist", "_itemIndex", "_itemText", "_itemData", "_colorlist", "_colorIndex", "_colorText", "_applyVehProperties", "_class", "_price", "_requestKey", "_vehicle"];

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
	
	_colorlist = _dialog displayCtrl vehshop_color_list;
	_colorIndex = lbCurSel vehshop_color_list;
	_colorText = _colorlist lbText _colorIndex;
	
	_showInsufficientFundsError = 
	{
		_itemText = _this select 0;
		hint parseText format ["Not enough money for<br/>""%1""", _itemText];
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
	};

	_applyVehProperties = 
	{
		private ["_vehicle", "_colorText", "_rgbString", "_textureFilename", "_texture", "_playerItems", "_playerAssignedItems", "_uavTerminal", "_allUAV"];
		_vehicle = _this select 0;
		_colorText = _this select 1;

		//if they chose a color set the color
		switch (toLower _colorText) do
		{
			case "black":       { _rgbString = "#(argb,8,8,3)color(0.1,0.1,0.1,0.1)" };
			case "grey":        { _rgbString = "#(argb,8,8,3)color(0.5,0.51,0.512,0.3)" };
			case "blue":        { _rgbString = "#(argb,8,8,3)color(0,0.2,1,0.75)" };
			case "dark blue":   { _rgbString = "#(argb,8,8,3)color(0,0.3,0.6,0.05)" };
			case "green":       { _rgbString = "#(argb,8,8,3)color(0,1,0,0.15)" };
			case "orange":      { _rgbString = "#(argb,8,8,3)color(1,0.5,0,0.4)" };
			case "pink":        { _rgbString = "#(argb,8,8,3)color(1,0.06,0.6,0.5)" };
			case "purple":      { _rgbString = "#(argb,8,8,3)color(0.8,0,1,0.1)" };
			case "red":         { _rgbString = "#(argb,8,8,3)color(1,0.1,0,0.3)" };
			case "teal":        { _rgbString = "#(argb,8,8,3)color(0,1,1,0.15)" };
			case "white":       { _rgbString = "#(argb,8,8,3)color(1,1,1,0.5)" };
			case "yellow":      { _rgbString = "#(argb,8,8,3)color(1,0.8,0,0.4)" };

			case "nato tan":    { _rgbString = "#(argb,8,8,3)color(0.584,0.565,0.515,0.3)" };
			case "csat brown":  { _rgbString = "#(argb,8,8,3)color(0.624,0.512,0.368,0.3)" };
			case "aaf green":   { _rgbString = "#(argb,8,8,3)color(0.546,0.59,0.363,0.2)" };

			case "orange camo": { _textureFilename = "camo_fack.jpg" };
			case "pink camo":   { _textureFilename = "camo_pank.jpg" };
			case "red camo":    { _textureFilename = "camo_deser.jpg" };
			case "yellow camo": { _textureFilename = "camo_fuel.jpg" };
		};

		if (_vehicle isKindOf "Kart_01_Base_F") then
		{
			_oldTexDir = _textureDir;
			_textureDir = "\A3\Soft_F_Kart\Kart_01\Data";

			switch (toLower _colorText) do
			{
				case "black":  { _textureFilename = "Kart_01_base_black_CO.paa" };
				case "blue":   { _textureFilename = "Kart_01_base_blue_CO.paa" };
				case "green":  { _textureFilename = "Kart_01_base_green_CO.paa" };
				case "yellow": { _textureFilename = "Kart_01_base_yellow_CO.paa" };
				case "orange": { _textureFilename = "Kart_01_base_orange_CO.paa" };
				case "red":    { _textureFilename = "Kart_01_base_red_CO.paa" };
				case "white":  { _textureFilename = "Kart_01_base_white_CO.paa" };
				default        { _textureDir = _oldTexDir };
			};
		};

		// If its a straight RGBA string, we can apply it directly
		if (!isNil "_rgbString") then
		{
			_texture = _rgbString;
		};

		// If its a texture, get the right directory
		if (!isNil "_textureFilename") then
		{
			_texture = format ["%1\%2", _textureDir, _textureFilename];
		};

		if (!isNil "_texture") then
		{
			[_vehicle, _texture] call applyVehicleTexture;
		};

		// If UAV or UGV, fill vehicle with UAV AI, give UAV terminal to our player, and connect it to the vehicle
		if ({_vehicle isKindOf _x} count (call uavArray) > 0) then
		{
			switch (side player) do
			{
				case BLUFOR: { _uavTerminal = "B_UavTerminal" };
				case OPFOR:	 { _uavTerminal = "O_UavTerminal" };
				default	     { _uavTerminal = "I_UavTerminal" };
			};

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

			if (isNull getConnectedUav player) then
			{
				player connectTerminalToUav _vehicle;
			};
		};
		
		_vehicle
	};
	{
		if (_itemText == _x select 0 && _itemData == _x select 1) exitWith
		{
			_class = _x select 1;
			_price = _x select 2;
			
			// Ensure the player has enough money
			if (_price > _playerMoney) exitWith
			{
				[_itemText] call _showInsufficientFundsError;
			};
			
			_requestKey = call generateKey;
			call requestStoreObject;
			
			_vehicle = objectFromNetId (missionNamespace getVariable _requestKey);
			
			if (!isNil "_vehicle" && {!isNull _vehicle}) then
			{
				[_vehicle, _colorText] call _applyVehProperties;
			};
		};
	} forEach (call allVehStoreVehicles);
	
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
			_playerMoneyText ctrlSetText format ["Cash: $%1", player getVariable "cmoney"];
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
