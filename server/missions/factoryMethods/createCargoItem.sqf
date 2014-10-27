//	@file Version: 1.0
//	@file Name: createCargoItem.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 26/1/2013 15:19

if(!isServer) exitwith {};

private["_parachuteClass","_dropPosition","_itemClass","_parachute","_cargo","_effectSmoke"];

_parachuteClass = _this select 0;
_dropPosition = _this select 1;
_itemClass = _this select 2;

_parachute = createVehicle [_parachuteClass, _dropPosition, [], 0, "NONE"];
_cargo = createVehicle [_itemClass, _dropPosition, [], 0, "NONE"];
_cargo attachTo [_parachute, [0,0,3]];
_parachute setpos _dropPosition;

if(_itemClass == "Land_stand_small_EP1") then
{
	_cargo setVariable["food",20,true];
};

_effectSmoke = "smokeShellPurple" createVehicle _dropPosition;
_effectSmoke attachto [_cargo, [0,0,0]];