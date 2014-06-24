//	@file Name: openParachute.sqf
//	@file Author: AgentRev

if (!alive player) exitWith {};
if (vehicle player != player) exitWith {};

private ["_pos", "_class", "_para"];

// some aircrafts blow up on contact with parachutes, so we have to make sure none's close
waitUntil {sleep 0.1; count (player nearEntities ["Air", 10]) == 0};

if (!alive player) exitWith {};

_pos = player call fn_getPos3D;
_class = if (_pos select 2 < 20) then { "NonSteerable_Parachute_F" } else { "Steerable_Parachute_F" };

_para = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
_para disableCollisionWith player;
_para setDir getDir player;
player moveInDriver _para;

_para spawn
{
	sleep 4.25; // parachute deployment time
	waitUntil {sleep 0.1; isTouchingGround _this || !alive _this || !alive player};
	if (alive player) then { sleep 1.5 };
	deleteVehicle _this;
};
