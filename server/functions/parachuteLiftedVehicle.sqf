// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: parachuteLiftedVehicle.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_veh", "_heli", "_faction", "_type", "_objectBB", "_objectMinBB", "_objectMaxBB", "_objectCenterX", "_objectCenterY", "_vel", "_para"];

_veh = _this;

if (typeName _veh == "STRING") then { _veh = objectFromNetId _veh };
if (isNull _veh) exitWith {};

_heli = attachedTo _veh;

_faction = faction driver _heli;
_type = if (_faction == "") then { "B" } else { toUpper toString [(toArray _faction) select 0] };

if !(_type in ["B","O","I"]) then { _type = "B" }; // mah boi, this parachute is what all true warriors strive for

_objectBB = _veh call fn_boundingBoxReal;
_objectMinBB = _objectBB select 0;
_objectMaxBB = _objectBB select 1;

_objectCenterX = (_objectMinBB select 0) + (((_objectMaxBB select 0) - (_objectMinBB select 0)) / 2);
_objectCenterY = (_objectMinBB select 1) + (((_objectMaxBB select 1) - (_objectMinBB select 1)) / 2);

_vel = velocity _veh;
[["detach", netId _veh], "A3W_fnc_towingHelper", _veh] call A3W_fnc_MP;
waitUntil {isNull attachedTo _veh};
uiSleep 0.01;
//_veh setVelocity _vel;

_para = createVehicle [format ["%1_parachute_02_F", _type], [0,0,999999], [], 0, "NONE"];

pvar_disableCollision = [netId _para, netId _heli];
(owner _heli) publicVariableClient "pvar_disableCollision";

_para disableCollisionWith _heli;
_para disableCollisionWith _veh;
//_para allowDamage false;

_para setDir getDir _veh;
_para setPosATL getPosATL _veh;

_para attachTo [_veh, [_objectCenterX, _objectCenterY, 0]];
uiSleep 2;

detach _para;
_veh attachTo [_para, [0 - _objectCenterX, 0 - _objectCenterY, 0]];

while {(getPos _veh) select 2 > 3 && attachedTo _veh == _para} do
{
	_para setVectorUp [0,0,1];
	_para setVelocity [0, 0, (velocity _para) select 2];
	uiSleep 0.1;
};

if (attachedTo _veh == _para) then
{
	[["detach", netId _veh], "A3W_fnc_towingHelper", _veh] call A3W_fnc_MP;
	waitUntil {isNull attachedTo _veh};
	_veh setVectorUp [0,0,1];
};

_delTime = diag_tickTime + 5;
waitUntil {uiSleep 0.1; isNull _para || {diag_tickTime >= _delTime}};

deleteVehicle _para;
