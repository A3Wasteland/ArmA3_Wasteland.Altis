// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: populateVehicles.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args: [int _switch]

#define vehicleManagementDialog 12000
#define vehicleManagementListBox 12001
#define vehicleWeaponsText 12003
#define vehicleUsersText 12004
#define vehicleDamageText 12005
#define vehicleSpeedText 12006

disableSerialization;

private ["_switch","_vehicle","_vehicleType","_vehicleClass","_dialog","_vehicleListBox","_weaponText","_userText","_damageText","_speedText","_check"];
_uid = getPlayerUID player;
if (_uid call isAdmin) then
{
	_switch = _this select 0;
	_allVehicles = vehicles;

	_dialog = findDisplay vehicleManagementDialog;
	_vehicleListBox = _dialog displayCtrl vehicleManagementListBox;
	_weaponText = _dialog displayCtrl vehicleWeaponsText;
	_userText = _dialog displayCtrl vehicleUsersText;
	_damageText = _dialog displayCtrl vehicleDamageText;
	_speedText = _dialog displayCtrl vehicleSpeedText;

	lbClear _vehicleListBox;
	_weaponText ctrlSetText format["Weapons:"];
	_speedText ctrlSetText format["Speed:"];
	_userText ctrlSetText format["Users:"];
	_damageText ctrlSetText format["Damage:"];

	switch (_switch) do
	{
		case 0:
		{
			{
				_vehicleType = typeOf _x;
				_vehicleClass = "";

				switch (true) do
				{
					case (_vehicleType isKindOf "MotorCycle"):
					{
						_vehicleClass = "Motorcycle";
					};
					case (_vehicleType isKindOf "Truck_F"):
					{
						_vehicleClass = "Truck";
					};
					case (_vehicleType isKindOf "Car" && !(_vehicleType isKindOf "Wheeled_APC_F")):
					{
						_vehicleClass = "Car";
					};
				};

				if (_vehicleClass != "") then
				{
					_index = _vehicleListBox lbAdd format ["[Class: %1] [Type: %2]", _vehicleClass, _vehicleType];
					_vehicleListBox lbSetData [_index, str _x];
				};

			} forEach _allVehicles;
		};
		case 1:
		{
			{
				_vehicleType = typeOf _x;

				if (_vehicleType isKindOf "Helicopter") then
				{
					_index = _vehicleListBox lbAdd format ["[Class: Helicopter] [Type: %1]", _vehicleType];
					_vehicleListBox lbSetData [_index, str _x];
				};

			} forEach _allVehicles;
		};
		case 2:
		{
			{
				_vehicleType = typeOf _x;

				if (_vehicleType isKindOf "Plane") then
				{
					_index = _vehicleListBox lbAdd format ["[Class: Plane] [Type: %1]", _vehicleType];
					_vehicleListBox lbSetData [_index, str _x];
				};

			} forEach _allVehicles;
		};
		case 3:
		{
			{
				_vehicleType = typeOf _x;
				_vehicleClass = "";

				if (_vehicleType isKindOf "Tank") then
				{
					_vehicleClass = "Tank";
				};

				if (_vehicleType isKindOf "Wheeled_APC_F") then
				{
					_vehicleClass = "APC";
				};

				if (_vehicleClass != "") then
				{
					_index = _vehicleListBox lbAdd format ["[Class: %1] [Type: %2]", _vehicleClass, _vehicleType];
					_vehicleListBox lbSetData [_index, str _x];
				};

			} forEach _allVehicles;
		};
		case 4:
		{
			private ["_hackedVehicles", "_hackedVehicle", "_vehicleOwner", "_ownerInfo"];
			_hackedVehicles = call findHackedVehicles;

			lbClear _vehicleListBox;

			{
				_hackedVehicle = _x select 0;
				_vehicleOwner = _x select 1;

				if (_vehicleOwner == "") then
				{
					_ownerInfo = "[Unknown owner]";
				}
				else
				{
					if (_hackedVehicle isKindOf "ReammoBox_F") then
					{
						_ownerInfo = format ["[Owner: %1]", _vehicleOwner];
					}
					else
					{
						_ownerInfo = format ["[Last driver: %1]", _vehicleOwner];
					};
				};

				_vehicleType = typeOf _hackedVehicle;
				_vehicleClass = "";

				switch (true) do
				{
					case (_vehicleType isKindOf "MotorCycle"):
					{
						_vehicleClass = "Motorcycle";
					};
					case (_vehicleType isKindOf "Truck_F"):
					{
						_vehicleClass = "Truck";
					};
					case (_vehicleType isKindOf "Wheeled_APC_F"):
					{
						_vehicleClass = "APC";
					};
					default
					{
						{
							if (_vehicleType isKindOf _x) exitWith
							{
								_vehicleClass = _x;
							};
						} forEach ["Car", "Helicopter", "Plane", "Tank"];

						if (_vehicleType isKindOf "ReammoBox_F") then
						{
							_vehicleClass = "Ammo Box";
						};
					};
				};

				if (_vehicleClass != "") then
				{
					_index = _vehicleListBox lbAdd format ["[Class: %1] [Type: %2] %3", _vehicleClass, _vehicleType, _ownerInfo];
					_vehicleListBox lbSetData [_index, str _hackedVehicle];
				};

			} forEach _hackedVehicles;
		};
	};
};
