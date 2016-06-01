// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: VehiclePainter_optionSelect.sqf
//	@file Author: LouD
//	@file Description: Vehicle Paint script

scriptName "repaintVehicle";

if (!isNil "storePurchaseHandle" && {typeName storePurchaseHandle == "SCRIPT"} && {!scriptDone storePurchaseHandle}) exitWith {hint "Please wait, your previous purchase is being processed"};


#define VehPaint_Menu_dialog 17000
#define VehPaint_Menu_option 17001

storePurchaseHandle = player spawn
{
	disableSerialization;

	//Initialize Values
	_textureDir = "client\images\vehicleTextures";
	_playerMoney = player getVariable ["cmoney", 0];
	
	// Grab access to the controls
	_dialog = findDisplay VehPaint_Menu_dialog;

	_colorlist = _dialog displayCtrl VehPaint_Menu_option;
	_colorIndex = lbCurSel VehPaint_Menu_option;
	_colorText = _colorlist lbText _colorIndex;
	_colorData = call compile (_colorlist lbData _colorIndex);
	
	_vehiclePainter =
	{
		_textureDir = "client\images\vehicleTextures";
		_vehicle = _this select 0;
		_colorData = _this select 1;
		
		_price = 500;
		_playerMoney = player getVariable "cmoney";

		if (_price > _playerMoney) exitWith
			{
				_text = format ["Not enough money! You need $%1 to repaint your vehicle.",_price];
				[_text, 10] call mf_notify_client;
				playSound "FD_CP_Not_Clear_F";
			};

		if (_price < _playerMoney) then	
			{
				player setVariable["cmoney",(player getVariable "cmoney")-_price,true];
				_text = format ["You paid $%1 to repaint your vehicle.",_price];
				[_text, 10] call mf_notify_client;		
				[] spawn fn_savePlayerData;
			};

		if (count _colorData > 0) then
		{
			[_vehicle, _colorData] call applyVehicleTexture;
		};
	};
	
	_applyTexProperties =
	{
		_vehicle = objectFromNetId (player getVariable ["lastVehicleRidden", ""]);
		_colorText = _this select 1;
		_colorData = _this select 2;
		_texArray  = [];

		if (count _colorData > 0) then
		{
			[_vehicle, _colorData] call _vehiclePainter;
		};
	};
	
	_player = player;
	if (!isNil "_player" && {!isNull _player}) then
	{
		[_player, _colorText, if (!isNil "_colorData") then { _colorData } else { "" }] call _applyTexProperties;
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