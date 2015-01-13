// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_forceOpenParachute.sqf
//	@file Author: AgentRev

if (!alive player) exitWith {};
if (vehicle player != player) exitWith {};

openParachuteTimestamp = diag_tickTime;

private ["_wait", "_pos", "_para"];
_wait = false;
_pos = getPosATL player;

if (_pos select 2 < 10) then
{
	_para = createVehicle ["NonSteerable_Parachute_F", _pos, [], 0, "FLY"];
	_para setPosATL _pos;
	_para setDir 0;
}
else
{
	_wait = true;
	_para = createVehicle ["Steerable_Parachute_F", _pos, [], 0, "CAN_COLLIDE"];
	_para setDir getDir player;
};

_para disableCollisionWith player;
player moveInDriver _para;
_para setVelocity [0,0,0];

[_para, _wait, diag_tickTime] spawn
{
	_para = _this select 0;
	_wait = _this select 1;
	_startTime = _this select 2;

	if (vehicle player == _para && animationState player != "para_pilot") then
	{
		[player, "para_pilot"] call switchMoveGlobal;
	};

	if (_wait) then
	{
		sleep (4.25 - (diag_tickTime - _startTime)); // parachute deployment time
	}
	else
	{
		sleep (0.5 - (diag_tickTime - _startTime));
	};

	waitUntil {isTouchingGround _para || !alive _para};

	if (!isNull _para) then
	{
		_para setVelocity [0,0,0];
		sleep 0.5;
		if (vehicle player == _para) then { moveOut player };
		sleep 1.5;
		deleteVehicle _para;
	};
};
