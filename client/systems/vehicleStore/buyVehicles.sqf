//	@file Version: 1.0
//	@file Name: buyVehicles.sqf
//	@file Author: His_Shadow, AgentRev
//	@file Created: 06/14/2013 05:13

if (!isNil "storePurchaseHandle" && {typeName storePurchaseHandle == "SCRIPT"} && {!scriptDone storePurchaseHandle}) exitWith {hint "Please wait, your previous purchase is being processed"};

#include "dialog\vehiclestoreDefines.hpp";

#define DELIVERY_METHOD_SPAWN 1
#define DELIVERY_METHOD_AIRDROP 2

storePurchaseHandle = _this spawn
{
	private ["_switch", "_deliveryMethod", "_playerMoney", "_price", "_dialog", "_playerMoneyText", "_colorText", "_itemText", "_handleMoney", "_applyVehProperties", "_car", "_vehType", "_vehPos", "_veh"];

	disableSerialization;

	//Initialize Values
	_switch = _this select 0;

	// CHANGE THIS TO SWAP BETWEEN SPAWNS AND AIRDROPS
	_deliveryMethod = DELIVERY_METHOD_SPAWN;

	if (_deliveryMethod == DELIVERY_METHOD_AIRDROP && currentOwnerID getVariable "isDeliveringVehicle" == 1) exitWith {
	  // Nicer audible error effect
	  hint format ["Please wait until the previous delivery is complete before ordering more vehicles"];
	  player say "FD_CP_Not_Clear_F";
	};

	_textureDir = "client\images\vehicleTextures";

	_playerMoney = player getVariable ["cmoney", 0];
	_price = 0;

	_vehicleSpawnPosAirdrop = [3786.45,7912.79,10000]; // Spawn it on debug island before moving to the chopper

	// Grab access to the controls
	_dialog = findDisplay vehshop_DIALOG;
	_playerMoneyText = _Dialog displayCtrl vehshop_money;
	_colorText = lbText [vehshop_color_list, (lbCurSel vehshop_color_list)];
	_itemText = lbText  [vehshop_veh_list, (lbCurSel vehshop_veh_list)];
	_handleMoney = 1;

	// Our array of compileFinal'd arrays
	_landVehicleArrays = [landArray, armoredArray, tanksArray];

	_showInsufficientFundsError = 
	{
	  _itemText = _this select 0;
	  hint format ["You don't have enought money for %1", _itemText];
	  player say "FD_CP_Not_Clear_F";
	  _handleMoney = 0;
	};

	_createAndApplyapplyVehProperties = 
	{
		private ["_vehicle", "_colorText", "_group", "_textureFilename", "_rgbString", "_texture", "_type", "_pos", "_playerItems", "_playerAssignedItems", "_playerSide", "_uavTerminal", "_allUAV"];
		_pos = _this select 0;
		_type = _this select 1;
		_colorText = _this select 2;

		if (_deliveryMethod == DELIVERY_METHOD_AIRDROP) then {
			_spawnType = "FLY";
		} else {
			_spawnType = "NONE";
		};
		
		_vehicle = createVehicle [_type,_pos, [], 0, _spawnType];
		_vehicle disableTIEquipment true; // Disable Thermal on bought vehicles.
		//_veh setDir _dir;
		_vehicle setVariable ["newVehicle",1,true];
		
		clearMagazineCargoGlobal _vehicle;
		clearWeaponCargoGlobal _vehicle;
		clearItemCargoGlobal _vehicle;
		
		_texture = "";
		_textureFilename = "";
		_rgbString = "";

		//if they chose a color set the color
		if(_colorText == "Orange") then { _rgbString = '#(argb,8,8,3)color(0.82,0.2,0,1)';};
		if(_colorText == "Red") then { _rgbString = '#(argb,8,8,3)color(0.79,0.03,0,1)';};
		if(_colorText == "Pink") then { _rgbString = '#(argb,8,8,3)color(0.95,0.45,0.74,1)';};
		if(_colorText == "Yellow") then { _rgbString = '#(argb,8,8,3)color(1,0.97,0.17,1)';};
		if(_colorText == "Purple") then { _rgbString = '#(argb,8,8,3)color(0.43,0.18,0.67,1)';};
		if(_colorText == "Blue") then { _rgbString = '#(argb,8,8,3)color(0,0.1,0.8,1)';};
		if(_colorText == "Dark Blue") then { _rgbString = '#(argb,8,8,3)color(0,0.01,0.06,1)';};
		if(_colorText == "Green") then { _rgbString = '#(argb,8,8,3)color(0.01,0.64,0,1)';};
		if(_colorText == "Black") then { _rgbString = '#(argb,8,8,3)color(0,0,0,1)';};
		if(_colorText == "White") then { _rgbString = '#(argb,8,8,3)color(1,1,1,1)';};
		if(_colorText == "Teal") then { _rgbString = '#(argb,8,8,3)color(0,0.93,0.86,1)';};
		if(_colorText == "Orange Camo") then {_textureFilename = "camo_fack.jpg";};
		if(_colorText == "Red Camo") then {_textureFilename = "camo_deser.jpg";};
		if(_colorText == "Yellow Camo") then {_textureFilename = "camo_fuel.jpg";};
		if(_colorText == "Pink Camo") then {_textureFilename = "camo_pank.jpg";};
		
		systemChat _rgbString;

		// If its a texture, get the right directory
		if(_textureFilename != "") then { _texture = format ["%1\%2", _textureDir, _textureFilename]; };

		// If its a straight RGBA string, we can apply it directly
		if(_rgbString != "") then { _texture = _rgbString; };

		if (_texture != "") then
		{
			_vehicle setVariable ["textureName", _texture];
			[[_vehicle, _texture], "applyVehicleTexture", true, true] call TPG_fnc_MP;
		};

		//if this a remote controlled type we have to do some special stuff
		if ({_type isKindOf _x} count (call uavArray) > 0) then
		{
			//collect arguments
			_playerItems = items player;
			_playerAssignedItems = assignedItems player;
			_playerSide = side player;
			
			//decide which uav controller we should give the player
			switch (_playerSide) do
			{
				case BLUFOR: { _uavTerminal = "B_UavTerminal" };
				case OPFOR:	 { _uavTerminal = "O_UavTerminal" };
				default	     { _uavTerminal = "I_UavTerminal" };
			};

			if !(_uavTerminal in _playerAssignedItems) then
			{
				{ player unassignItem _x } forEach ["ItemGPS", "B_UavTerminal", "O_UavTerminal", "I_UavTerminal"]; // Unassign any GPS slot item
				
				if (_uavTerminal in _playerItems) then
				{
					player assignItem _uavTerminal;
				}
				else
				{
					player linkItem _uavTerminal;
				};
			};

			//assign an AI to the vehicle so it can actually be used
			createVehicleCrew _vehicle;

			//create a group that matches the player's side so it doesn't kill them on spawn!
			_group = createGroup _playerSide;
			[_vehicle] joinSilent _group;
			
			player connectTerminalToUav _vehicle; 
		};

		//tell the vehicle to delete itself after dying
		_vehicle addEventHandler ["Killed",{(_this select 0) spawn {sleep 180; deleteVehicle _this}}];
		
		//enable vehicle locking (disabled because of missing script)
		//_vehicle addAction ["Lock / Unlock", "server\functions\unlocklock.sqf", [], 7, true, true, "", "_target distance _this < 7"];
		_vehicle
	};

	_deliverPos = nil;
	_veh = nil;
	_spawnType = "";

	switch(_switch) do 
	{
		//Buy To Player
		case 0: 
		{
			// LAND VEHICLES
			{
				_vehicleArray = _x;
				{
					if (_itemText == _x select 0) exitWith
					{
						_price = _x select 2;
						if ( _price > _playerMoney) then {[_itemText] call _showInsufficientFundsError; breakTo "main"};
						_vehType = _x select 1;
						_deliverPos = (getMarkerPos format ["%1_Spawn_Land", currentOwnerID]);
						_spawnType = "land";

						if (_deliveryMethod == DELIVERY_METHOD_SPAWN) then {
							_veh = [_deliverPos, _vehType, _colorText] call _createAndApplyapplyVehProperties;
						} else {
							_veh = [_vehicleSpawnPosAirdrop, _vehType, _colorText] call _createAndApplyapplyVehProperties;
						};

					};
				} forEach (call _vehicleArray);
			} forEach _landVehicleArrays;
			
			// BOATS
			{
				if (_itemText == _x select 0) exitWith
				{
					_price = _x select 2;
					if ( _price > _playerMoney) then {[_itemText] call _showInsufficientFundsError;;breakTo "main"};				
					_vehType = _x select 1;
					_deliverPos = (getMarkerPos format ["%1_Spawn_Sea", currentOwnerID]);
					_spawnType = "sea";

					if (_deliveryMethod == DELIVERY_METHOD_SPAWN) then {
						_veh = [_deliverPos, _vehType, _colorText] call _createAndApplyapplyVehProperties;
					} else {
						_veh = [_vehicleSpawnPosAirdrop, _vehType, _colorText] call _createAndApplyapplyVehProperties;
					};
				};
			 } forEach (call boatsArray);

			// HELIS
			{
				if (_itemText == _x select 0) exitWith
				{
					_price = _x select 2;
					if ( _price > _playerMoney) then {[_itemText] call _showInsufficientFundsError;;breakTo "main"};				
					_vehType = _x select 1;
						_deliverPos = (getMarkerPos format ["%1_Spawn_Heli", currentOwnerID]);
					_spawnType = "land";

					if (_deliveryMethod == DELIVERY_METHOD_SPAWN) then {
						_veh = [_deliverPos, _vehType, _colorText] call _createAndApplyapplyVehProperties;
					} else {
						_veh = [_vehicleSpawnPosAirdrop, _vehType, _colorText] call _createAndApplyapplyVehProperties;
					};
				};

			} forEach (call helicoptersArray);

			// JETS
			{
				if (_itemText == _x select 0) exitWith
				{
					_price = _x select 2;
					if ( _price > _playerMoney) then {[_itemText] call _showInsufficientFundsError;;breakTo "main"};				
					_vehType = _x select 1;
						_deliverPos = (getMarkerPos format ["%1_Spawn_Air", currentOwnerID]);
					_spawnType = "land";

					if (_deliveryMethod == DELIVERY_METHOD_SPAWN) then {
						_veh = [_deliverPos, _vehType, _colorText] call _createAndApplyapplyVehProperties;
					} else {
						_veh = [_vehicleSpawnPosAirdrop, _vehType, _colorText] call _createAndApplyapplyVehProperties;
					};
				};
			} forEach (call planesArray);
		};
	};

	// Pick a sound to play

	if(_handleMoney == 1) then
	{

		if (_deliveryMethod == DELIVERY_METHOD_AIRDROP) then {
			diag_log "Calling airdrop script";
			serverVehicleHeliDrop = [_veh, _deliverPos, player, _price, currentOwnerID];
			publicVariableServer "serverVehicleHeliDrop";

			_ambientRadioSound = ["RadioAmbient2", "RadioAmbient6", "RadioAmbient8"] call BIS_fnc_selectRandom;
			currentOwnerID say _ambientRadioSound;

			if (_veh isKindOf "Helicopter") then {
					player globalChat format ["A transport helicopter is en route with your %1. It will be dropped in the shallows nearest the store.", _itemText];
			} else {
				if (_veh isKindOf "Ship") then {
					player globalChat format ["A transport helicopter is en route with your %1. It will be dropped in the shallows nearest the store.", _itemText];
				} else {
					player globalChat format ["A transport helicopter is en route with your %1. Keep well clear of the LZ and stand by....", _itemText];
				};
			};

			currentOwnerID setVariable['isDeliveringVehicle', 1, true];
		} else {
			player globalChat format ["Your %1 has spawned outside.", _itemText];
		};

		player setVariable["cmoney",_playerMoney - _price,true];
		_playerMoneyText ctrlSetText format ["Cash: $%1", player getVariable "cmoney"];
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
