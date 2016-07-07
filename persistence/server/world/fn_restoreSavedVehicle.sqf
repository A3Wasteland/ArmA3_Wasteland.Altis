// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_restoreSavedVehicle.sqf
//	@file Author: AgentRev

#define STR_TO_SIDE(VAL) ([sideUnknown,BLUFOR,OPFOR,INDEPENDENT,CIVILIAN,sideLogic] select ((["WEST","EAST","GUER","CIV","LOGIC"] find toUpper (VAL)) + 1))

_pos = _pos apply { if (_x isEqualType "") then { parseNumber _x } else { _x } };

private _isUAV = (round getNumber (configFile >> "CfgVehicles" >> _class >> "isUav") > 0);

private ([["_flying"],[]] select isNil "_flying");
_flying = (!isNil "_flying" && {_flying > 0});

_veh = createVehicle [_class, _pos, [], if (isNil "_safeDistance") then { 0 } else { _safeDistance }, ["","FLY"] select (_isUAV && _flying)];
_veh allowDamage false;
_veh hideObjectGlobal true;

private _velMag = vectorMagnitude velocity _veh;

if (isNil "_safeDistance") then
{
	_veh setPosWorld ATLtoASL _pos;
};

if (!isNil "_dirAngle") then
{
	_veh setDir _dirAngle;
};

if (!isNil "_dir") then
{
	_veh setVectorDirAndUp _dir;
};

private _uavSide = if (isNil "_playerSide") then { sideUnknown } else { _playerSide };

{
	_x params ["_var", "_val"];

	switch (_var) do
	{
		case "uavSide":
		{
			if (_uavSide isEqualTo sideUnknown) then { _uavSide = STR_TO_SIDE(_val) };
		};
	};

	_veh setVariable [_var, _val, true];
} forEach _variables;

// UAV AI
if (_isUAV) then
{
	createVehicleCrew _veh;

	if (_flying) then
	{
		if (isNil "_vel" || {count _vel < 3}) then
		{
			_vel = (vectorDir _veh) vectorMultiply _velMag;
		};

		_veh setVelocity _vel;
		_veh flyInHeight (((_veh call fn_getPos3D) select 2) max 500);
	};

	[_veh, _flying, _uavSide] spawn
	{
		params ["_uav", "_flying", "_uavSide"];
		private "_grp";

		waitUntil {_grp = group _uav; !isNull _grp};

		if (_uavSide != sideUnknown && side _uav != _uavSide) then
		{
			_grp = createGroup _uavSide;
			(crew _uav) joinSilent _grp;
		};

		_grp setCombatMode "BLUE"; // hold fire

		if (_flying) then
		{
			_wp = (group _uav) addWaypoint [getPosATL _uav, 0];
			_wp setWaypointType "MOVE";
		};

		{
			[_x, ["UAV","",""]] remoteExec ["A3W_fnc_setName", 0, _x];
		} forEach crew _uav;
	};
};

[_veh, false] call vehicleSetup;

if (!isNil "_vehicleID") then
{
	_veh setVariable ["A3W_vehicleID", _vehicleID, true];
	_veh setVariable ["A3W_vehicleSaved", true, true];
	A3W_vehicleIDs pushBack _vehicleID;
};

_veh setVariable ["vehSaving_hoursUnused", _hoursUnused];
_veh setVariable ["vehSaving_lastUse", diag_tickTime];
_veh setVariable ["vehSaving_hoursAlive", _hoursAlive];
_veh setVariable ["vehSaving_spawningTime", diag_tickTime];

_veh allowDamage true;
_veh setDamage _damage;
{ _veh setHitPointDamage _x } forEach _hitPoints;

_veh setFuel _fuel;

if (!isNil "_textures") then
{
	_veh setVariable ["BIS_enableRandomization", false, true];

	private _objTextures = [];

	{
		_texture = _x select 0;
		{
			_veh setObjectTextureGlobal [_x, _texture];
			[_objTextures, _x, _texture] call fn_setToPairs;
		} forEach (_x select 1);
	} forEach _textures;

	_veh setVariable ["A3W_objectTextures", _objTextures, true];
};

if (!isNil "_owner") then
{
	_veh setVariable ["ownerUID", _owner, true];

	if (!isNil "_lockState" && ["A3W_vehicleLocking"] call isConfigOn) then
	{
		[_veh, _lockState] call A3W_fnc_setLockState;
	};
};

clearWeaponCargoGlobal _veh;
clearMagazineCargoGlobal _veh;
clearItemCargoGlobal _veh;
clearBackpackCargoGlobal _veh;

if (!isNil "_weapons") then
{
	{ _veh addWeaponCargoGlobal _x } forEach _weapons;
};
if (!isNil "_magazines") then
{
	[_veh, _magazines] call processMagazineCargo;
};
if (!isNil "_items") then
{
	{ _veh addItemCargoGlobal _x } forEach _items;
};
if (!isNil "_backpacks") then
{
	{
		_x params ["_bpack"];

		if (!(_bpack isKindOf "Weapon_Bag_Base") || {{_bpack isKindOf _x} count ["B_UAV_01_backpack_F", "B_Static_Designator_01_weapon_F", "O_Static_Designator_02_weapon_F"] > 0}) then
		{
			_veh addBackpackCargoGlobal _x;
		};
	} forEach _backpacks;
};

if (!isNil "_turretMags" && !isNil "_turretMags3" && {_turretMags isEqualTo [] && _turretMags3 isEqualTo []}) then
{
	// for vehicles saved from A3 v1.56 and onwards, remove all default mags because empty ones are saved
	{ _veh removeMagazineTurret [_x select 0, _x select 1] } forEach magazinesAllTurrets _veh;
}
else
{
	// for older vehicle saves, mark all default mags as empty so it can still be resupplied to its default ammo capacity
	_veh setVehicleAmmo 0;
};

// Remove all turret weapons to ensure they are reloaded properly
private _turretWeapons = _veh call fn_removeTurretWeapons;

if (!isNil "_turretMags3") then
{
	private _magsAdded = [];
	private "_magPathStr";

	{
		_x params ["_mag", "_path", "_ammoCoef"];

		_magPathStr = toLower (_mag + str _path);

		if (_magPathStr in _magsAdded) then
		{
			_veh addMagazineTurret [_mag, _path];
		}
		else
		{
			_magsAdded pushBack _magPathStr;
		};

		_veh setMagazineTurretAmmo [_mag, _ammoCoef * getNumber (configFile >> "CfgMagazines" >> _mag >> "count"), _path];
	} forEach _turretMags3;
};
if (!isNil "_turretMags") then
{
	{ _veh addMagazine _x } forEach _turretMags;
};
if (!isNil "_turretMags2") then
{
	{ _veh addMagazineTurret _x } forEach _turretMags2;
};

// Re-add all turret weapons to ensure they are reloaded properly
{ _veh addWeaponTurret _x } forEach _turretWeapons;

if (!isNil "_ammoCargo") then { _veh setAmmoCargo _ammoCargo };
if (!isNil "_fuelCargo") then { _veh setFuelCargo _fuelCargo };
if (!isNil "_repairCargo") then { _veh setRepairCargo _repairCargo };

//reload _veh;
_veh hideObjectGlobal false;
