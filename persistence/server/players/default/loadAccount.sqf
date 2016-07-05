// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: loadAccount.sqf
//	@file Author: AgentRev

params ["_UID", "_player"];
private ["_data", "_saveValid", "_getValue"];

if !((_UID call PDB_playerFileName) call PDB_exists) exitWith { [] }; // iniDB_exists

_data = [];

_saveValid = ([_UID call PDB_playerFileName, "PlayerSave", "Position", "STRING"] call PDB_read != ""); // iniDB_read
_data pushBack ["PlayerSaveValid", _saveValid];

_getValue =
{
	private ["_name", "_type", "_section", "_value"];
	_name = _this select 0;
	_type = _this select 1;
	_section = if (count _this > 2) then { _this select 2 } else { "PlayerSave" };

	_value = [_UID call PDB_playerFileName, _section, _name, _type] call PDB_read; // iniDB_read

	if (!isNil "_value") then
	{
		_data pushBack [_name, _value];
	};
};

["Donator", "NUMBER", "PlayerInfo"] call _getValue;
["BankMoney", "NUMBER", "PlayerInfo"] call _getValue;
["Bounty", "NUMBER", "PlayerInfo"] call _getValue;
["BountyKills", "ARRAY", "PlayerInfo"] call _getValue;

if (["A3W_privateStorage"] call isConfigOn) then
{
	["PrivateStorage", "ARRAY", "PlayerInfo"] call _getValue;
};

["Damage", "NUMBER"] call _getValue;
["HitPoints", "ARRAY"] call _getValue;

if (["A3W_moneySaving"] call isConfigOn) then
{
	["Money", "NUMBER"] call _getValue;
};

["LoadedMagazines", "ARRAY"] call _getValue;

["PrimaryWeapon", "STRING"] call _getValue;
["SecondaryWeapon", "STRING"] call _getValue;
["HandgunWeapon", "STRING"] call _getValue;

["PrimaryWeaponItems", "ARRAY"] call _getValue;
["SecondaryWeaponItems", "ARRAY"] call _getValue;
["HandgunItems", "ARRAY"] call _getValue;

["AssignedItems", "ARRAY"] call _getValue;

["CurrentWeapon", "STRING"] call _getValue;
["Stance", "STRING"] call _getValue;

["Uniform", "STRING"] call _getValue;
["Vest", "STRING"] call _getValue;
["Backpack", "STRING"] call _getValue;
["Goggles", "STRING"] call _getValue;
["Headgear", "STRING"] call _getValue;

["UniformWeapons", "ARRAY"] call _getValue;
["UniformItems", "ARRAY"] call _getValue;
["UniformMagazines", "ARRAY"] call _getValue;

["VestWeapons", "ARRAY"] call _getValue;
["VestItems", "ARRAY"] call _getValue;
["VestMagazines", "ARRAY"] call _getValue;

["BackpackWeapons", "ARRAY"] call _getValue;
["BackpackItems", "ARRAY"] call _getValue;
["BackpackMagazines", "ARRAY"] call _getValue;

["PartialMagazines", "ARRAY"] call _getValue; // legacy

["WastelandItems", "ARRAY"] call _getValue;

["Hunger", "NUMBER"] call _getValue;
["Thirst", "NUMBER"] call _getValue;

["Position", "ARRAY"] call _getValue;
["Direction", "NUMBER"] call _getValue;

_data
