// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: loadAccount.sqf
//	@file Author: Torndeco, AgentRev

if (!isServer) exitWith {};

private ["_UID", "_bank", "_moneySaving", "_donator", "_donatorEnabled", "_teamkiller", "_tkCount", "_tkAutoKickEnabled", "_tkKickAmount", "_customUniformEnabled", "_uniformNumber", "_result", "_data", "_columns"];
_UID = _this;

_bank = 0;
_donator = 0;
_teamkiller = 0;
_tkCount = 0;
_tkKickAmount = 0;
_uniformNumber = 0;
_moneySaving = ["A3W_moneySaving"] call isConfigOn;
_donatorEnabled = ["A3W_donatorEnabled"] call isConfigOn;
_tkAutoKickEnabled = ["A3W_tkAutoKickEnabled"] call isConfigOn;
_tkKickAmount = ["A3W_tkKickAmount", 0] call getPublicVar;
_customUniformEnabled = ["A3W_customUniformEnabled"] call isConfigOn;


if (_donatorEnabled) then
{
	_result = ["getPlayerDonatorLevel:" + _UID, 2] call extDB_Database_async;

	if (count _result > 0) then
	{
		_donator = _result select 0;
	};
};

if (_customUniformEnabled) then
{
	_result = ["getPlayerCustomUniform:" + _UID, 2] call extDB_Database_async;

	if (count _result > 0) then
	{
		_uniformNumber = _result select 0;
	};
};

if (_moneySaving) then
{
	_result = ["getPlayerBankMoney:" + _UID, 2] call extDB_Database_async;

	if (count _result > 0) then
	{
		_bank = _result select 0;
	};
};

if (_tkAutoKickEnabled) then
{
	_result = ["getPlayerTeamKiller:" + _UID, 2] call extDB_Database_async;

	if (count _result > 0) then
	{
		_teamkiller = _result select 0;
	}
	else
	{
		_result = ["getPlayerTKCount:" + _UID, 2] call extDB_Database_async;
		
		if (count _result > 0) then
		{
			_tkcount = _result select 0;
			
			if (_tkcount > _tkKickAmount) then
			{
				_teamkiller = 1;
			}
			else
			{
				_teamkiller = 0;
			};
		}
	};
};

_result = ([format ["checkPlayerSave:%1:%2", _UID, call A3W_extDB_MapID], 2] call extDB_Database_async) select 0;

if (!_result) then
{
	_data =
	[
		["PlayerSaveValid", false],
		["BankMoney", _bank],
		["DonatorLevel", _donator],
		["CustomUniform", _uniformNumber]
	];
}
else
{
	// The order of these values is EXTREMELY IMPORTANT!
	_data =
	[
		"Damage",
		"HitPoints",
		"Hunger",
		"Thirst",

		"LoadedMagazines",

		"PrimaryWeapon",
		"SecondaryWeapon",
		"HandgunWeapon",

		"PrimaryWeaponItems",
		"SecondaryWeaponItems",
		"HandgunItems",

		"AssignedItems",

		"CurrentWeapon",
		"Stance",

		"Uniform",
		"Vest",
		"Backpack",
		"Goggles",
		"Headgear",

		"UniformWeapons",
		"UniformItems",
		"UniformMagazines",

		"VestWeapons",
		"VestItems",
		"VestMagazines",

		"BackpackWeapons",
		"BackpackItems",
		"BackpackMagazines",

		"WastelandItems",

		"Position",
		"Direction"
	];

	if (_moneySaving) then
	{
		_data pushBack "Money";
	};

	_columns = "";

	{
		_columns = _columns + ((if (_columns != "") then { "," } else { "" }) + _x);
	} forEach _data;

	_result = [format ["getPlayerSave:%1:%2:%3", _UID, call A3W_extDB_MapID, _columns], 2] call extDB_Database_async;

	{
		_data set [_forEachIndex, [_data select _forEachIndex, _x]];
	} forEach _result;

	_data pushBack ["BankMoney", _bank];
	_data pushBack ["DonatorLevel", _donator];
	_data pushBack ["CustomUniform", _uniformNumber];
	_data pushBack ["PlayerSaveValid", true];
};

_data
