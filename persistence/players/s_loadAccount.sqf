//	@file Version: 1.0
//	@file Name: s_loadAccount.sqf
//	@file Author: AgentRev
//	@file Created: 25/02/2014 22:21

if (!isServer) exitWith {};

private ["_UID", "_data", "_getValue"];

_UID = _this;
_data = [];

_getValue =
{
	private ["_name", "_type", "_section", "_value"];
	_name = _this select 0;
	_type = _this select 1;
	_section = [_this, 2, "PlayerSave"] call BIS_fnc_param;

	_value = [_UID call PDB_databaseNameCompiler, _section, _name, _type] call iniDB_read;

	if (!isNil "_value") then
	{
		[_data, [_name, _value]] call BIS_fnc_arrayPush;
	};
};

["Donator", "NUMBER", "PlayerInfo"] call _getValue;

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

["CurrentMuzzle", "STRING"] call _getValue;
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

_data
