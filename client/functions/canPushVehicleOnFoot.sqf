// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: canPushVehicleOnFoot.sqf
//	@file Author: AgentRev

private ["_veh", "_vPos", "_pPos", "_vel"];

_veh = cursorTarget;
_vPos = getPosASL _veh;
_pPos = getPosASL player;
_vel = _this select 0;

(
	vehicle player == player &&
	_veh isKindOf "AllVehicles" &&
	{!(_veh isKindOf "Man") &&
	{count crew _veh == 0} &&
	{!canMove _veh || (_veh isKindOf "Ship_F" && {!surfaceIsWater _vPos || _vPos select 2 > -0.9})} &&
	{_pPos select 2 >= -1.5} &&
	{_pPos vectorDistance _vPos < 10} &&
	{vectorMagnitude velocity _veh <= abs _vel + 1}}
)
