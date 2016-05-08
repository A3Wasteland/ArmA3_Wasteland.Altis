// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: loadAccount.sqf
//	@file Author: Torndeco, AgentRev

if (!isServer) exitWith {};

private ["_UID", "_bank", "_moneySaving", "_crossMap", "_environment", "_result", "_data", "_location", "_dataTemp", "_ghostingTimer", "_secs", "_columns", "_pvar", "_pvarG"];
_UID = _this;

_bank = 0;
_moneySaving = ["A3W_moneySaving"] call isConfigOn;
_crossMap = ["A3W_extDB_playerSaveCrossMap"] call isConfigOn;
_environment = ["A3W_extDB_Environment", "normal"] call getPublicVar;

if (_moneySaving) then
{
	_result = ["getPlayerBankMoney:" + _UID, 2] call extDB_Database_async;

	if (count _result > 0) then
	{
		_bank = _result select 0;
	};
};

_result = if (_crossMap) then
{
	([format ["checkPlayerSaveXMap:%1:%2", _UID, _environment], 2] call extDB_Database_async) select 0
}
else
{
	([format ["checkPlayerSave:%1:%2", _UID, call A3W_extDB_MapID], 2] call extDB_Database_async) select 0
};

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
		"Thirst"
	];

	_location = ["Stance", "Position", "Direction"];

	if (!_crossMap) then
	{
		_data append _location;
	};

	if (_moneySaving) then
	{
		_data pushBack "Money";
	};

	_result = if (_crossMap) then
	{
		[format ["getPlayerSaveXMap:%1:%2:%3", _UID, _environment, _data joinString ","], 2] call extDB_Database_async;
	}
	else
	{
		[format ["getPlayerSave:%1:%2:%3", _UID, call A3W_extDB_MapID, _data joinString ","], 2] call extDB_Database_async;
	};

	{
		_data set [_forEachIndex, [_data select _forEachIndex, _x]];
	} forEach _result;

	if (_crossMap) then
	{
		_result = [format ["getPlayerSave:%1:%2:%3", _UID, call A3W_extDB_MapID, _location joinString ","], 2] call extDB_Database_async;

		if (count _result == count _location) then
		{
			{
				_location set [_forEachIndex, [_location select _forEachIndex, _x]];
			} forEach _result;

			_data append _location;
		};
	};

	_dataTemp = _data;
	_data = [["PlayerSaveValid", true]];

	_ghostingTimer = ["A3W_extDB_GhostingTimer", 5*60] call getPublicVar;

	if (_ghostingTimer > 0) then
	{
		_result = if (_crossMap) then
		{
			[format ["getTimeSinceServerSwitchXMap:%1:%2:%3", _UID, _environment, call A3W_extDB_ServerID], 2] call extDB_Database_async
		}
		else
		{
			[format ["getTimeSinceServerSwitch:%1:%2:%3", _UID, call A3W_extDB_MapID, call A3W_extDB_ServerID], 2] call extDB_Database_async
		};

		if (count _result > 0) then
		{
			_secs = _result select 0; // [_result select 1] = LastServerID, if _crossMap then [_result select 2] = WorldName

			if (_secs < _ghostingTimer) then
			{
				_data pushBack ["GhostingTimer", _ghostingTimer - _secs];
			};
		};
	};

	_data append _dataTemp;
	_data pushBack ["BankMoney", _bank];
};

// before returning player data, restore global player stats if applicable
if (["A3W_playerStatsGlobal"] call isConfigOn) then
{
	_columns = ["playerKills", "aiKills", "teamKills", "deathCount", "reviveCount", "captureCount"];
	_result = [format ["getPlayerStats:%1:%2", _UID, _columns joinString ","], 2] call extDB_Database_async;

	{
		_pvar = format ["A3W_playerScore_%1_%2", _columns select _forEachIndex, _UID];
		_pvarG = _pvar + "_global";
		missionNamespace setVariable [_pvarG, _x - (missionNamespace getVariable [_pvar, 0])];
		publicVariable _pvarG;
	} forEach _result;
};

_data
