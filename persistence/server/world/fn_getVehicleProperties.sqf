// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_getVehicleProperties.sqf
//	@file Author: AgentRev

private ["_veh", "_flying", "_class", "_purchasedVehicle", "_missionVehicle", "_pos", "_dir", "_vel", "_fuel", "_damage", "_hitPoints", "_variables", "_owner", "_doubleBSlash", "_textures", "_tex", "_texArr", "_weapons", "_magazines", "_items", "_backpacks", "_turretMags", "_turretMags2", "_turretMags3", "_hasDoorGuns", "_turrets", "_path", "_ammoCargo", "_fuelCargo", "_repairCargo", "_props"];

_veh = _this select 0;
_flying = if (count _this > 1) then { _this select 1 } else { false };

_class = typeOf _veh;
_purchasedVehicle = _veh getVariable ["A3W_purchasedVehicle", false];
_missionVehicle = (_veh getVariable ["A3W_missionVehicle", false] && !(_veh getVariable ["R3F_LOG_disabled", false]));

_pos = ASLtoATL getPosWorld _veh;
{ _pos set [_forEachIndex, _x call fn_numToStr] } forEach _pos;
_dir = [vectorDir _veh, vectorUp _veh];
_vel = velocity _veh;
_fuel = fuel _veh;
_damage = damage _veh;
_hitPoints = [];

{
	_hitPoint = configName _x;
	_hitPoints set [count _hitPoints, [_hitPoint, _veh getHitPointDamage _hitPoint]];
} forEach (_class call getHitPoints);

_variables = [];

switch (true) do
{
	case _purchasedVehicle:
	{
		_variables pushBack ["A3W_purchasedVehicle", true];
	};
	case _missionVehicle:
	{
		_variables pushBack ["A3W_missionVehicle", true];
	};
};

_owner = _veh getVariable ["ownerUID", ""];

_doubleBSlash = (call A3W_savingMethod == "extDB");

_textures = [];
{
	_tex = _x select 1;

	if (_doubleBSlash) then
	{
		_texArr = [];

		{
			_texArr pushBack _x;

			if (_x == 92) then // backslash
			{
				_texArr pushBack 92; // double it
			};
		} forEach toArray _tex;

		_tex = toString _texArr;
	};

	[_textures, _tex, [_x select 0]] call fn_addToPairs;
} forEach (_veh getVariable ["A3W_objectTextures", []]);

_weapons = [];
_magazines = [];
_items = [];
_backpacks = [];

if (_class call fn_hasInventory) then
{
	// Save weapons & ammo
	_weapons = (getWeaponCargo _veh) call cargoToPairs;
	_magazines = _veh call fn_magazineAmmoCargo;
	_items = (getItemCargo _veh) call cargoToPairs;
	_backpacks = (getBackpackCargo _veh) call cargoToPairs;
};

_turretMags = magazinesAmmo _veh;
_turretMags2 = [];
_turretMags3 = [];
_hasDoorGuns = isClass (configFile >> "CfgVehicles" >> _class >> "Turrets" >> "RightDoorGun");

_turrets = allTurrets [_veh, false];

if !(_class isKindOf "B_Heli_Transport_03_unarmed_F") then
{
	_turrets = [[-1]] + _turrets; // only add driver turret if not unarmed Huron, otherwise flares get saved twice
};

if (_hasDoorGuns) then
{
	// remove left door turret, because its mags are already returned by magazinesAmmo
	{
		if (_x isEqualTo [1]) exitWith
		{
			_turrets set [_forEachIndex, 1];
		};
	} forEach _turrets;

	_turrets = _turrets - [1];
};

{
	_path = _x;

	{
		if ([_turretMags, _x, -1] call fn_getFromPairs == -1 || _hasDoorGuns) then
		{
			if (_veh currentMagazineTurret _path == _x && {count _turretMags3 == 0}) then
			{
				_turretMags3 pushBack [_x, _path, [_veh currentMagazineDetailTurret _path] call getMagazineDetailAmmo];
			}
			else
			{
				_turretMags2 pushBack [_x, _path];
			};
		};
	} forEach (_veh magazinesTurret _path);
} forEach _turrets;

_ammoCargo = getAmmoCargo _veh;
_fuelCargo = getFuelCargo _veh;
_repairCargo = getRepairCargo _veh;

// Fix for -1.#IND
if (isNil "_ammoCargo" || {!finite _ammoCargo}) then { _ammoCargo = 0 };
if (isNil "_fuelCargo" || {!finite _fuelCargo}) then { _fuelCargo = 0 };
if (isNil "_repairCargo" || {!finite _repairCargo}) then { _repairCargo = 0 };

_props =
[
	["Class", _class],
	["Position", _pos],
	["Direction", _dir],
	["Velocity", _vel],
	["Fuel", _fuel],
	["Damage", _damage],
	["HitPoints", _hitPoints],
	["OwnerUID", _owner],
	["Variables", _variables],
	["Textures", _textures],

	["Weapons", _weapons],
	["Magazines", _magazines],
	["Items", _items],
	["Backpacks", _backpacks],

	["TurretMagazines", _turretMags],
	["TurretMagazines2", _turretMags2],
	["TurretMagazines3", _turretMags3],

	["AmmoCargo", _ammoCargo],
	["FuelCargo", _fuelCargo],
	["RepairCargo", _repairCargo]
];

// If flying and not UAV, do not save current pos/dir/vel
if (_flying && {getNumber (configFile >> "CfgVehicles" >> _class >> "isUav") <= 0}) then
{
	_props deleteRange [1,3];
};

_props
