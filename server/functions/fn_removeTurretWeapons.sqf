// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_removeTurretWeapons.sqf
//	@file Author: AgentRev

params [["_veh",objNull,[objNull]]];

if (!local _veh) exitWith { [] };

private ["_turretWeapons", "_path"];
_turretWeapons = [];

{
	_path = _x;

	{
		_veh removeWeaponTurret [_x, _path];
		_turretWeapons pushBack [_x, _path];
	} forEach (_veh weaponsTurret _path);
} forEach ([[-1]] + allTurrets _veh);

_turretWeapons
