// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: loadAccount.sqf
//	@file Author: Torndeco, AgentRev

if (!isServer) exitWith {};

private ["_UID", "_bank", "_moneySaving", "_result", "_data", "_columns"];
_UID = _this;

_bank = 0;
_moneySaving = ["A3W_moneySaving"] call isConfigOn;

if (_moneySaving) then
{
	_result = ["getPlayerBankMoney:" + _UID, 2] call extDB_Database_async;

	if (count _result > 0) then
	{
		_bank = _result select 0;
	};
};

_result = ([format ["checkPlayerSave:%1:%2", _UID, call A3W_extDB_MapID], 2] call extDB_Database_async) select 0;

if (!_result) then
{
	_data =
	[
		["PlayerSaveValid", false],
		["BankMoney", _bank]
	];
}
else
{
	// The order of these values is EXTREMELY IMPORTANT!
	_data =
	[
		"Damage",
		"HitPoints",

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

		"Hunger",
		"Thirst",

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
	_data pushBack ["PlayerSaveValid", true];
};

_data
