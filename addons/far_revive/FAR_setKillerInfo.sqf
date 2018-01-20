// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_setKillerInfo.sqf
//	@file Author: AgentRev

params ["_target", "_source", "_ammo", ["_instigator",objNull]];

private _targetGroup = group _target;
private _targetSide = side _targetGroup;
private _targetVehicle = vehicle _target;
private _sourceVehicle = vehicle _source;

private _killer = _source;
private _killerVehicle = _sourceVehicle;
private _killerWeapon = "";
private _killerDistance = -1;

// chain-reaction tracking
if (_targetVehicle == _target) then
{
	// roadkilled by vehicle wreck, or killed by nearby vehicle explosion
	if (!isNull _killerVehicle && !alive _killerVehicle && {!(_killerVehicle isKindOf "Man") && _ammo in ["","FuelExplosion","FuelExplosionBig"]}) then
	{
		_killer = _sourceVehicle getVariable ["FAR_killerUnit", objNull];
	};
}
else
{
	// target inside exploding vehicle
	if (!isNull _targetVehicle && !alive _targetVehicle && _source in [objNull, _target, _targetVehicle]) then
	{
		_killer = _targetVehicle getVariable ["FAR_killerUnit", objNull];
		_killerVehicle = _targetVehicle getVariable ["FAR_killerVehicle", _targetVehicle];
	};
};

// killed by vehicle
if (!(_killer isKindOf "Man") || (_ammo == "" && _targetVehicle != _sourceVehicle)) then // if _killer is Man but _ammo is "" then 99% chance it's a roadkill, so we consider it as killed by vehicle
{
	if (!isNull _instigator) then
	{
		_killer = _instigator; // killed by turret gunner (new method)
	}
	else
	{
		if (isNull _killerVehicle) exitWith {}; // unsolved death

		private _suspects = (crew _killerVehicle) select {alive _x || isPlayer _x};

		if (count _suspects == 0) exitWith {}; // crushed by empty vehicle

		private _firstCrew = _suspects select 0;
		private _firstCrewGroup = group _firstCrew;
		private _driver = driver _killerVehicle;

		if (_ammo == "") then
		{
			if (!isNull _driver) then // roadkill with driver still seated
			{
				_killer = _driver;

				if (isAgent teamMember _driver && !isNull (_driver getVariable ["A3W_driverAssistOwner", objNull])) then // driver assist roadkill
				{
					private _effComm = effectiveCommander _killerVehicle;
					if (alive _effComm || isPlayer _effComm) then { _killer = _effComm };
				};

				_target setVariable ["A3W_deathCause_local", ["roadkill"]];
			};
		}
		else
		{
			private _shooter = [_target, _killerVehicle, _ammo] call fn_findTurretShooter; // killed by turret gunner (old method)
			if (!isNull _shooter) then { _killer = _shooter };
		};

		// if roadkill but driver bailed out or turret kill but gunner bailed out, and the first crewmember is an enemy, award him the kill
		if !(_killer isKindOf "Man") then
		{
			if (_targetSide == sideUnknown || !([_firstCrewGroup, _targetGroup] call A3W_fnc_isFriendly)) then
			{
				_killer = _firstCrew;
			};
		};
	};
};

// killed by UAV
if (isUavConnected _killerVehicle && {isNull _killer || {getText (configFile >> "CfgVehicles" >> typeOf _killer >> "simulation") == "UAVPilot"}}) then
{
	private _uavOwner = (uavControl _killerVehicle) select 0;
	if (!isNull _uavOwner) then { _killer = _uavOwner };
};

// find murder explosive
if (_ammo isKindOf "TimeBombCore") then // all vanilla mines
{
	_killerWeapon = getText (configFile >> "CfgAmmo" >> _ammo >> "defaultMagazine");
}
else
{
	if ((_ammo isKindOf "GrenadeHand" || _ammo isKindOf "IRStrobeBase") && !(_ammo isKindOf "G_40mm_Smoke")) then // all vanilla throwables
	{
		private _magsCfg = (format ["getText (_x >> 'ammo') == '%1'", _ammo]) configClasses (configFile >> "CfgMagazines");

		if !(_magsCfg isEqualTo []) then
		{
			_killerWeapon = configName (_magsCfg select 0);
		};
	}
};

if (_killer isKindOf "Man") then
{
	// find murder weapon
	if (_killerWeapon == "") then
	{
		private _shooter = [_killer, _killerVehicle] select (unitIsUAV _killerVehicle && _killer != _source); // if (unitIsUAV _killerVehicle && _killer == _source) then killer shot from UGV passenger seat
		private _compatibleWeapons = [_shooter, _ammo] call fn_compatibleWeapons;

		if !(_compatibleWeapons isEqualTo []) then
		{
			if (_shooter isKindOf "Man") then
			{
				_killerWeapon = currentMuzzle _shooter;

				// player switched weapon while bullet in flight, tag first compatible weapon
				if ({_x == _killerWeapon} count _compatibleWeapons == 0) then
				{
					_killerWeapon = _compatibleWeapons select 0;
				};
			}
			else
			{
				_killerWeapon = _compatibleWeapons select 0;
			};
		};
	};
}
else
{
	_killer = objNull;
};

private _killerEntity = [_killer, _killerVehicle] select (isNull _killer || (unitIsUAV _killerVehicle && _killer != _source));

if (!isNull _killerEntity) then
{
	_killerDistance = _target distance _killerEntity;
};

private _killerUnit = [objNull, _killer] select (_killer isKindOf "Man");
private _killerVehicleVar = [_killerVehicle, _killer] select isNull _killerVehicle;
private _killerAI = (!isNull _killer && !isPlayer _killer && isNil {_killer getVariable "cmoney"});

[
	_target,
	[
		["FAR_killerVehicle", _killerVehicleVar],
		["FAR_killerVehicleClass", typeOf _killerVehicleVar],
		["FAR_killerUnit", _killerUnit],
		["FAR_killerName", name _killerUnit],
		["FAR_killerUID", getPlayerUID _killerUnit],
		["FAR_killerGroup", group _killerUnit],
		["FAR_killerSide", side group _killerUnit],
		["FAR_killerFriendly", [_killerUnit, _target] call A3W_fnc_isFriendly],
		["FAR_killerAI", _killerAI],
		["FAR_killerWeapon", _killerWeapon],
		["FAR_killerAmmo", _ammo],
		["FAR_killerDistance", _killerDistance],
		["FAR_killerSuspects", []] // always empty, used to mark completion of data collection
	]
] call A3W_fnc_setVarServer;

//systemChat format ["FAR_setKillerInfo: %1", [typeOf _killer, typeOf _killerVehicle, _killerWeapon, _ammo, _killerDistance]];
//systemChat format ["FAR_setKillerInfo: %1", [typeOf _target, name _target, typeOf _source, _ammo, _suspects, _instigator]];
//diag_log format ["FAR_setKillerInfo: %1", [typeOf _target, name _target, typeOf _source, _ammo, _suspects, _instigator]];
