// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleHitTracking.sqf
//	@file Author: AgentRev

params ["_vehicle", "_selection", "_damage", "_source", "_ammo", "_instigator", "_hitPoint"];

if (!alive _vehicle) exitWith {};

private _class = typeOf _vehicle;
private _aboutToExplode = false;
private _dead = false;

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
	if (_damage > 0.9) then
	{
		//private _hitPoint = _vehicle getVariable ["A3W_hitPoint_" + _selection, ""];

		if (_class isKindOf "Tank" && _hitPoint == "HitHull") exitWith
		{
			_aboutToExplode = true;
		};

		if (_class isKindOf "Air" && (getPos _vehicle) select 2 > 3) then
		{
			if (_hitPoint == "HitHRotor") exitWith
			{
				_aboutToExplode = true;
			};

			private _engine1 = _veh getHitPointDamage "HitEngine";
			private _engine2 = _veh getHitPointDamage "HitEngine2";

			if ((_hitPoint == "HitEngine" && (isNil "_engine2" || {_engine2 > 0.9})) || {_hitPoint == "HitEngine2" && (isNil "_engine1" || {_engine1 > 0.9})}) then
			{
				_aboutToExplode = true;
			};
		};
	};
};

private _killerVehicle = _vehicle getVariable ["FAR_killerVehicle", objNull];

if (_dead || (_aboutToExplode && isNull _killerVehicle)) then
{
	//systemChat format ["veh %1, source %2, ammo %3, insti %4, pilot %5, conn %6", typeof _vehicle, typeof _source, _ammo, typeof _instigator, typeof (_vehicle call fn_findPilot), isUavConnected _vehicle];

	if (isNull _instigator && (isNull _source || (vehicle _source == _vehicle && _ammo == ""))) then // vehicle crash
	{
		if (isNull _killerVehicle) then
		{
			//systemChat str [_vehicle, _vehicle call fn_findPilot, _ammo];
			[_vehicle, _vehicle call fn_findPilot, _ammo] call FAR_setKillerInfo;
		};
	}
	else
	{
		//systemChat "else";
		[_vehicle, _source, _ammo, _instigator] call FAR_setKillerInfo;
		//diag_log format ["vehicleHitTracking: %1 - %2", typeOf _vehicle, typeOf (_vehicle getVariable ["FAR_killerVehicle", objNull])];
	};

	//diag_log format ["vehicleHitTracking3: %1, %2, %3", typeOf _vehicle, typeOf _source, _ammo];
};
