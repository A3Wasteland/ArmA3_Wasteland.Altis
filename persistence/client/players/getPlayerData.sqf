// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getPlayerData.sqf
//	@file Author: AgentRev

private ["_player", "_saveLocation", "_data", "_hitPoints", "_hpDamage", "_pos", "_loadedMags", "_mag", "_ammo", "_loaded", "_type", "_wastelandItems"];
_player = _this select 0;
_saveLocation = if (count _this > 1) then { _this select 1 } else { true };

_data = if (_player == player) then {
	[
		["Hunger", ["hungerLevel", 0] call getPublicVar],
		["Thirst", ["thirstLevel", 0] call getPublicVar]
	]
} else {
	[]
};

_hitPoints = [];
_hpDamage = getAllHitPointsDamage _player;

{
	_hitPoints pushBack [_x, (_hpDamage select 2) select _forEachIndex];
} forEach (_hpDamage select 0);

{ _data pushBack _x } forEach
[
	["Damage", damage _player],
	["HitPoints", _hitPoints],
	["Money", _player getVariable ["cmoney", 0]] // Money is always saved, but only restored if A3W_moneySaving = 1
];

// Only save those when on ground or underwater (you probably wouldn't want to spawn 500m in the air if you get logged off in flight)
if (_saveLocation && {isTouchingGround vehicle _player || {(getPos _player) select 2 < 0.5 || (getPosASL _player) select 2 < 0.5}}) then
{
	_pos = getPosATL _player;
	{ _pos set [_forEachIndex, _x call fn_numToStr] } forEach _pos;

	_data pushBack ["Position", _pos];
	_data pushBack ["Direction", getDir _player];

	if (vehicle _player == player) then
	{
		_data pushBack ["CurrentWeapon", currentWeapon player];
		_data pushBack ["Stance", [player, ["P"]] call getMoveParams];
	};
};

{ _data pushBack _x } forEach
[
	["Uniform", uniform _player],
	["Vest", vest _player],
	["Backpack", backpack _player],
	["Goggles", goggles _player],
	["Headgear", headgear _player],

	["PrimaryWeapon", primaryWeapon _player],
	["SecondaryWeapon", secondaryWeapon _player],
	["HandgunWeapon", handgunWeapon _player],

	["PrimaryWeaponItems", primaryWeaponItems _player],
	["SecondaryWeaponItems", secondaryWeaponItems _player],
	["HandgunItems", handgunItems _player],

	["AssignedItems", assignedItems _player]
];


_loadedMags = [];

{
	_mag = _x select 0;
	_ammo = _x select 1;
	_loaded = _x select 2;
	_type = _x select 3;

	// if loaded in weapon, not empty, and not hand grenade
	if (_loaded && _ammo > 0 && _type != 0) then
	{
		_loadedMags pushBack [_mag, _ammo];
	};
} forEach magazinesAmmoFull _player;

{ _data pushBack _x } forEach
[
	["UniformWeapons", (getWeaponCargo uniformContainer _player) call cargoToPairs],
	["UniformItems", (getItemCargo uniformContainer _player) call cargoToPairs],
	["UniformMagazines", (uniformContainer _player) call fn_magazineAmmoCargo],

	["VestWeapons", (getWeaponCargo vestContainer _player) call cargoToPairs],
	["VestItems", (getItemCargo vestContainer _player) call cargoToPairs],
	["VestMagazines", (vestContainer _player) call fn_magazineAmmoCargo],

	["BackpackWeapons", (getWeaponCargo backpackContainer _player) call cargoToPairs],
	["BackpackItems", (getItemCargo backpackContainer _player) call cargoToPairs],
	["BackpackMagazines", (backpackContainer _player) call fn_magazineAmmoCargo],

	["LoadedMagazines", _loadedMags]
];

if (_player == player) then
{
	_wastelandItems = [];
	{
		if (_x select 1 > 0) then
		{
			_wastelandItems pushBack [_x select 0, _x select 1];
		};
	} forEach call mf_inventory_all;

	_data pushBack ["WastelandItems", _wastelandItems];
};

// Uniform and backpack texture saving
_uniformTexture = uniformContainer _player getVariable ["uniformTexture", ""];

if (call A3W_savingMethod == "extDB") then
{
	_uniformTexture = (_uniformTexture splitString "\") joinString "\\";
/*	_texArr = [];

	{
		_texArr pushBack _x;

		if (_x == 92) then // backslash
		{
			_texArr pushBack 92; // double it
		};
	} forEach toArray _uniformTexture;

	_uniformTexture = toString _texArr;*/
};

_backpackTexture = backpackContainer _player getVariable ["backpackTexture", ""];

if (call A3W_savingMethod == "extDB") then
{
	_backpackTexture = (_backpackTexture splitString "\") joinString "\\";
/*	_btexArr = [];

	{
		_btexArr pushBack _x;

		if (_x == 92) then // backslash
		{
			_btexArr pushBack 92; // double it
		};
	} forEach toArray _backpackTexture;

	_backpackTexture = toString _btexArr;*/
};

{ _data pushBack _x } forEach
[
	["UniformTexture", _uniformTexture],
	["BackpackTexture", _backpackTexture]
];

_data
