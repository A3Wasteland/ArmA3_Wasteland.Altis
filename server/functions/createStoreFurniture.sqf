// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createStoreFurniture.sqf
//	@file Author: His_Shadow, AgentRev
//	@file Args:

if (!isServer) exitWith {};

params ["_storeOwner", "_bPos", "_pDir", "_pDDirMod"];

_pDDirMod = _pDDirMod + 180;

private _deskPos = _bPos vectorAdd ([[0, -0.8, 0], -_pDDirMod] call BIS_fnc_rotateVector2D);

private _desk = createSimpleObject ["Land_CashDesk_F", _deskPos];
_desk allowDamage false;
_desk setDir _pDDirMod;
_desk setVariable ["R3F_LOG_disabled", true, true];
_desk disableCollisionWith _storeOwner;

_desk
