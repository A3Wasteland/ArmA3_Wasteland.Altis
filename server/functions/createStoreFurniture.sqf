// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createStoreFurniture.sqf
//	@file Author: His_Shadow
//	@file Args:

if (!isServer) exitWith {};

private ["_storeOwner", "_bPos", "_pDir", "_pDDirMod", "_chair", "_desk", "_base", "_deskPos"];

//grab our arguments
_storeOwner = _this select 0;
_bPos = _this select 1;
_pDir = _this select 2;
_pDDirMod = _this select 3;
_base = getPosATL _storeOwner;

//create the bench NOTE: was going to use a plastic chair, but the bench looks nicer
//_chair = "Land_Bench_F" createVehicle _base;
//_chair setVelocity [0,0,0];
//_chair setPos [(_bPos select 0), (_bPos select 1), (_bPos select 2) - .2];
//_chair setDir _pDir + 90;
//_chair removeAllEventHandlers "hit";
//_chair removeAllEventHandlers "dammaged";
//_chair removeAllEventHandlers "handleDamage";
//_chair addeventhandler ["hit", {(_this select 0) setdamage 0;}];
//_chair addeventhandler ["dammaged", {(_this select 0) setdamage 0;}];
//_chair addEventHandler["handledamage", {false}];
//_chair allowDamage false;
//_chair enableSimulation false;

_pDDirMod = _pDDirMod + 180; // desk model is inverted

_bPos set [2, (_bPos select 2) + 0.05];
_deskPos = ASLtoATL ((ATLtoASL _bPos) vectorAdd ([[0, -0.8, 0], -_pDDirMod] call BIS_fnc_rotateVector2D));

//create the cashier station.
_desk = createVehicle ["Land_CashDesk_F", _base, [], 0, "None"];
_desk allowDamage false;
_desk setPosATL _deskPos;
_desk setDir _pDDirMod;
_desk setVariable ["R3F_LOG_disabled", true, true];
_desk disableCollisionWith _storeOwner;

//_chair disableCollisionWith _desk;
//_chair

_desk
