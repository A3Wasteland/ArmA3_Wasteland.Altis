//	@file Version: 1.0
//	@file Name: loadAccount.sqf
//	@file Author: AgentRev
//	@file Created: 25/02/2014 22:21

if (!isServer) exitWith {};

private ["_player_uid", "_data", "_playerSaveValid", "_getValue"];

_player = _this;
_player_uid = getPlayerUID _player;

_data = [];


if ((_player_uid call PDB_playerFileName) call PDB_exists) then
{

	_playerSaveValid = ([_player_uid call PDB_playerFileName, "PlayerSave", "Position", "STRING"] call PDB_read != ""); // iniDB_read
	_data pushBack ["PlayerSaveValid", _playerSaveValid];

	_getValue =
	{
		private ["_key", "_type", "_section", "_value"];
		_key = _this select 0;
		_type = _this select 1;
		_section = if (count _this > 2) then { _this select 2 } else { "PlayerSave" };

		_value = [_player_uid call PDB_playerFileName, _section, _key, _type] call PDB_read; // iniDB_read

		if (!isNil "_value") then
		{
			_data pushBack [_key, _value];
		};
	};

	["Donator", "NUMBER", "PlayerInfo"] call _getValue;
	["BankMoney", "NUMBER", "PlayerInfo"] call _getValue; // Not implemented in vanilla mission

	["Damage", "NUMBER"] call _getValue;
	["Hunger", "NUMBER"] call _getValue;
	["Thirst", "NUMBER"] call _getValue;

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

	["PartialMagazines", "ARRAY"] call _getValue;

	["WastelandItems", "ARRAY"] call _getValue;

	["Position", "ARRAY"] call _getValue;
	["Direction", "NUMBER"] call _getValue;
}
else
{
	[_player_uid call PDB_playerFileName, "PlayerInfo", "UID", _player_uid] call PDB_write; // iniDB_write
	[_player_uid call PDB_playerFileName, "PlayerInfo", "Name", name _player] call PDB_write; // iniDB_write
};

_data