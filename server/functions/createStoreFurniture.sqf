//	@file Version: 1.0
//	@file Name: createStoreFurniture.sqf
//	@file Author: His_Shadow
//	@file Args:

private ["_storeOwner", "_bPos", "_pDir", "_pDDirMod", "_fName", "_chair", "_desk", "_base", "_deskPos"];

//grab our arguments
_storeOwner = _this select 0;
_bPos = _this select 1;
_pDir = _this select 2;
_pDDirMod = _this select 3;
_fName = _this select 4;
_base = getPos _storeOwner;

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

//create the cashier station
_desk = "Land_CashDesk_F" createVehicle _base;
_deskPos = [(_bPos select 0)+1.2*sin(_pDir),(_bPos select 1)+1.2*cos(_pDir),(_bPos select 2)];
_desk setPos [(_deskPos select 0), (_deskPos select 1), (_deskPos select 2)-.2];
_desk setVelocity [0,0,0];
_desk setDir _pDDirMod;
_desk removeAllEventHandlers "hit";
_desk removeAllEventHandlers "dammaged";
_desk removeAllEventHandlers "handleDamage";
_desk addeventhandler ["hit", {(_this select 0) setdamage 0;}];
_desk addeventhandler ["dammaged", {(_this select 0) setdamage 0;}];
_desk addEventHandler["handledamage", {false}];
_desk allowDamage false;

//_chair disableCollisionWith _desk;
//_chair
