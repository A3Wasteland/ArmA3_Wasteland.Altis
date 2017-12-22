// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getObjectProperties.sqf
//	@file Author: AgentRev

#include "functions.sqf"

private ["_obj", "_class", "_pos", "_dir", "_damage", "_allowDamage", "_variables", "_owner", "_weapons", "_magazines", "_items", "_backpacks", "_turretMags", "_ammoCargo", "_fuelCargo", "_repairCargo"];
_obj = _this select 0;

_class = typeOf _obj;

_pos = ASLtoATL getPosWorld _obj;
{ _pos set [_forEachIndex, _x call fn_numToStr] } forEach _pos;
_dir = [vectorDir _obj, vectorUp _obj];
_damage = damage _obj;
_allowDamage = if (_obj getVariable ["allowDamage", false]) then { 1 } else { 0 };

_variables = [];

switch (true) do
{
	case (_obj isKindOf "Land_Sacks_goods_F"):
	{
		_variables pushBack ["food", _obj getVariable ["food", 20]];
	};
	case (_obj isKindOf "Land_BarrelWater_F"):
	{
		_variables pushBack ["water", _obj getVariable ["water", 20]];
	};
};

switch (true) do
{
	case (_obj call _isBox):
	{
		_variables pushBack ["cmoney", (_obj getVariable ["cmoney", 0]) call fn_numToStr];
	};
	case (_obj call _isWarchest):
	{
		_variables pushBack ["a3w_warchest", true];
		_variables pushBack ["R3F_LOG_disabled", true];
		_variables pushBack ["side", str (_obj getVariable ["side", sideUnknown])];
	};
	case (_obj call _isBeacon):
	{
		_variables pushBack ["a3w_spawnBeacon", true];
		_variables pushBack ["R3F_LOG_disabled", true];
		_variables pushBack ["side", str (_obj getVariable ["side", sideUnknown])];
		_variables pushBack ["packing", false];
		_variables pushBack ["groupOnly", _obj getVariable ["groupOnly", false]];
		_variables pushBack ["ownerName", toArray (_obj getVariable ["ownerName", "[Beacon]"])];
	};
};

_owner = _obj getVariable ["ownerUID", ""];

_r3fSide = _obj getVariable "R3F_Side";

if (!isNil "_r3fSide") then
{
	_variables pushBack ["R3F_Side", str _r3fSide];
};

_weapons = [];
_magazines = [];
_items = [];
_backpacks = [];

if (_class call fn_hasInventory) then
{
	// Save weapons & ammo
	//_weapons = (getWeaponCargo _obj) call cargoToPairs;
	//_magazines = (getMagazineCargo _obj) call cargoToPairs;
	//_items = (getItemCargo _obj) call cargoToPairs;
	//_backpacks = (getBackpackCargo _obj) call cargoToPairs;

	private _cargo = _obj call fn_containerCargoToPairs;
	_weapons = _cargo select 0;
	_magazines = _cargo select 1;
	_items = _cargo select 2;
	_backpacks = _cargo select 3;
};

_turretMags = [];

if (_staticWeaponSavingOn && {_class call _isStaticWeapon}) then
{
	{
		if (_x select 0 != "FakeWeapon") then
		{
			_turretMags pushBack [_x select 0, _x select 2];
		};
	} forEach magazinesAllTurrets _obj;
};

_ammoCargo = getAmmoCargo _obj;
_fuelCargo = getFuelCargo _obj;
_repairCargo = getRepairCargo _obj;

// Fix for -1.#IND
if (isNil "_ammoCargo" || {!finite _ammoCargo}) then { _ammoCargo = 0 };
if (isNil "_fuelCargo" || {!finite _fuelCargo}) then { _fuelCargo = 0 };
if (isNil "_repairCargo" || {!finite _repairCargo}) then { _repairCargo = 0 };

[
	["Class", _class],
	["Position", _pos],
	["Direction", _dir],
	["Damage", _damage],
	["AllowDamage", _allowDamage],
	["OwnerUID", _owner],
	["Variables", _variables],

	["Weapons", _weapons],
	["Magazines", _magazines],
	["Items", _items],
	["Backpacks", _backpacks],

	["TurretMagazines", _turretMags],

	["AmmoCargo", _ammoCargo],
	["FuelCargo", _fuelCargo],
	["RepairCargo", _repairCargo]
]
