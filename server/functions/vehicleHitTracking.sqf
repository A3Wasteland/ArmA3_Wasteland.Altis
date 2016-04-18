// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleHitTracking.sqf
//	@file Author: AgentRev

private ["_vehicle", "_selection", "_damage", "_source", "_ammo", "_class", "_hitPoint", "_killerVehicle"];

_vehicle = _this select 0;
_selection = _this select 1;
_damage = _this select 2;
_source = _this select 3;
_ammo = _this select 4;

if (!alive _vehicle) exitWith {};

_class = typeOf _vehicle;

_aboutToExplode = false;
_dead = false;

// The damage table below was built from analysis of damage models from Arma 3 v1.34; it is very unlikely to be fully compatible with other BIS titles

if (_selection == "") then
{
	if (_damage >= 1) exitWith
	{
		_dead = true;
	};

	if ((_class isKindOf "LandVehicle" && _damage >= 0.98) ||
	    {_class isKindOf "Air" && _damage > 0.99}) exitWith
	{
		_aboutToExplode = true;
	};
};

if (!_dead && !_aboutToExplode) then
{
	if (_damage > 0.9) exitWith
	{
		_hitPoint = _vehicle getVariable ["A3W_hitPoint_" + _selection, ""];

		if ((_class isKindOf "Car" && _hitPoint == "HitFuel") ||
		    {_class isKindOf "Tank" && _hitPoint == "HitHull"} ||
		    {_class isKindOf "Air" && (_hitPoint == "HitEngine" || _hitPoint == "HitHRotor") && !isTouchingGround _vehicle}) exitWith
		{
			_aboutToExplode = true;
		};
	};
};

_killerVehicle = _vehicle getVariable ["FAR_killerVehicle", objNull];

if (_dead || (_aboutToExplode && isNull _killerVehicle)) then
{
	if (_dead && _source in crew _vehicle) then // Vehicle crash
	{
		if (isNull _killerVehicle) then
		{
			_uavOwner = (uavControl _vehicle) select 0;
			if (isPlayer _uavOwner) then { _source = _uavOwner };

			[_vehicle, _source, _ammo] call FAR_setKillerInfo;
			_vehicle setVariable ["FAR_killerVehicle", _vehicle call FAR_findKiller, true];
		};
	}
	else
	{
		if (_source != _vehicle) then
		{
			if (_ammo in ["","FuelExplosion"] && !isNull _source) then // Killed by explosion
			{
				_vehicle setVariable ["FAR_killerVehicle", _source getVariable ["FAR_killerVehicle", objNull], true];
				_vehicle setVariable ["FAR_killerAmmo", _source getVariable ["FAR_killerAmmo", ""], true];
				//diag_log format ["vehicleHitTracking2: %1 - %2", typeOf _vehicle, typeOf _source, typeOf (_vehicle getVariable ["FAR_killerVehicle", objNull])];
			}
			else // Killed by direct hit
			{
				[_vehicle, _source, _ammo] call FAR_setKillerInfo;
				_vehicle setVariable ["FAR_killerVehicle", _vehicle call FAR_findKiller, true];
				//diag_log format ["vehicleHitTracking: %1 - %2", typeOf _vehicle, typeOf (_vehicle getVariable ["FAR_killerVehicle", objNull])];
			};
		};
	};

	//diag_log format ["vehicleHitTracking3: %1, %2, %3", typeOf _vehicle, typeOf _source, _ammo];
};
