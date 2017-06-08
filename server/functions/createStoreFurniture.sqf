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

private _deskPos = _bPos vectorAdd ([[0, -0.7, 0], -_pDDirMod] call BIS_fnc_rotateVector2D);

private _topPos = _deskPos vectorAdd [0,0,0.25];
private _downPos = _deskPos vectorAdd [0,0,-0.25];
private _intersects = (lineIntersectsSurfaces [_topPos, _downPos, _storeOwner, objNull, true, 1, "GEOM", "NONE"]) select {_x = _x select 3; isNull _x || (!isHidden _x && {typeOf _x == "" || _x isKindOf "Building"})};
private "_vecUp";

if !(_intersects isEqualTo []) then
{
	_vecUp = _intersects select 0 select 1;
};

private _desk = createSimpleObject ["Land_CashDesk_F", _deskPos];
_desk allowDamage false;
_desk setDir _pDDirMod;

if (!isNil "_vecUp") then
{
	_desk setVectorUp _vecUp;
};

_desk setVariable ["R3F_LOG_disabled", true, true];
_desk disableCollisionWith _storeOwner;

_desk
