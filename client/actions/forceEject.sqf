//	@file Name: forceEject.sqf
//	@file Author: AgentRev

if (!alive player) exitWith {};

private ["_veh", "_push", "_vel"];

_veh = vehicle player;
if (_veh == player) exitWith {};

moveOut player;

if (_veh isKindOf "Plane") then
{
	if (!isTouchingGround _veh) then
	{
		player setDir getDir _veh;
		_push = [vectorUp _veh, 40] call BIS_fnc_vectorMultiply; // Simulate rocket seat ejection
	};
}
else
{
	if ((getPos _veh) select 2 > 4) then
	{
		_push = [([getPosASL _veh, getPosASL player] call BIS_fnc_vectorDiff) call BIS_fnc_unitVector, 5] call BIS_fnc_vectorMultiply; // Push 5m/s away from vehicle
	};
};

if (!isNil "_push") then
{
	player setVelocity ([velocity player, _push] call BIS_fnc_vectorAdd);
};
