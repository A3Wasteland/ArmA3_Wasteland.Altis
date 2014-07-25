//	@file Name: c_applyPlayerData.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};

private ["_data", "_name", "_value"];

_data = _this;

removeAllWeapons player;
removeAllAssignedItems player;
removeUniform player;
removeVest player;
removeBackpack player;
removeGoggles player;
removeHeadgear player;

{
	_name = _x select 0;
	_value = _x select 1;

	switch (_name) do
	{
		case "Donator": { player setVariable ["isDonator", _value > 0] };
		case "Damage": { player setDamage _value };
		case "Hunger": { hungerLevel = _value };
		case "Thirst": { thirstLevel = _value };
		case "Money": { player setVariable ["cmoney", _value, true] };
		case "Position": { waitUntil {sleep 0.1; preloadCamera _value}; player setPosATL _value };
		case "Direction": { player setDir _value };
		case "Uniform":
		{
			// If uniform cannot be worn by player due to different team, try to convert it, else give default instead
			if (_value != "") then
			{
				if ([player, _value] call canWear) then
				{
					player addUniform _value;
				}
				else
				{
					_newUniform = [player, _value] call uniformConverter;

					if ([player, _newUniform] call canWear) then
					{
						player addUniform _newUniform;
					}
					else
					{
						player addUniform ([player, "uniform"] call getDefaultClothing);
					}
				};
			};
		};
		case "Vest": { if (_value != "") then { player addVest _value } };
		case "Backpack": { if (_value != "") then { player addBackpack _value } };
		case "Goggles": { if (_value != "") then { player addGoggles _value } };
		case "Headgear":
		{
			// If wearing one of the default headgears, give the one belonging to actual team instead
			if (_value != "") then
			{
				_defHeadgear = [player, "headgear"] call getDefaultClothing;
				_defHeadgears =
				[
					[typeOf player, "headgear", BLUFOR] call getDefaultClothing,
					[typeOf player, "headgear", OPFOR] call getDefaultClothing,
					[typeOf player, "headgear", INDEPENDENT] call getDefaultClothing
				];

				if (_value != _defHeadgear && {_defHeadgear != ""} && {{_value == _x} count _defHeadgears > 0}) then
				{
					player addHeadgear _defHeadgear;
				}
				else
				{
					player addHeadgear _value;
				};
			};
		};
		case "LoadedMagazines": { { player addMagazine _x } forEach _value };
		case "PrimaryWeapon": { player addWeapon _value; removeAllPrimaryWeaponItems player };
		case "SecondaryWeapon": { player addWeapon _value };
		case "HandgunWeapon": { player addWeapon _value; removeAllHandgunItems player };
		case "PrimaryWeaponItems": { { if (_x != "") then { player addPrimaryWeaponItem _x } } forEach _value };
		case "SecondaryWeaponItems": { { if (_x != "") then { player addSecondaryWeaponItem _x } } forEach _value };
		case "HandgunItems": { { if (_x != "") then { player addHandgunItem _x } } forEach _value };
		case "AssignedItems":
		{
			{
				if ([player, _x] call isAssignableBinocular) then
				{
					player addWeapon _x;
				}
				else
				{
					player linkItem _x;
				};
			} forEach _value;
		};
		case "CurrentWeapon": { player selectWeapon _value };
		case "Stance": { player switchMove ([player, _value] call getFullMove) };
		case "UniformWeapons": { { (uniformContainer player) addWeaponCargoGlobal _x } forEach _value };
		case "UniformItems": { { (uniformContainer player) addItemCargoGlobal _x } forEach _value };
		case "UniformMagazines": { { (uniformContainer player) addMagazineCargoGlobal _x } forEach _value };
		case "VestWeapons": { { (vestContainer player) addWeaponCargoGlobal _x } forEach _value };
		case "VestItems": { { (vestContainer player) addItemCargoGlobal _x } forEach _value };
		case "VestMagazines": { { (vestContainer player) addMagazineCargoGlobal _x } forEach _value };
		case "BackpackWeapons": { { (backpackContainer player) addWeaponCargoGlobal _x } forEach _value };
		case "BackpackItems": { { (backpackContainer player) addItemCargoGlobal _x } forEach _value };
		case "BackpackMagazines": { { (backpackContainer player) addMagazineCargoGlobal _x } forEach _value };
		case "PartialMagazines": { { player addMagazine _x } forEach _value };
		case "WastelandItems": { { [_x select 0, _x select 1, true] call mf_inventory_add } forEach _value };
	};
} forEach _data;
