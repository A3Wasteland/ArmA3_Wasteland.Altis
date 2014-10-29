// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: canPushWatercraft.sqf
//	@file Author: AgentRev

private ["_veh", "_pos", "_vel"];

_veh = vehicle player;
_pos = getPosASL _veh;
_vel = _this select 0;

(
	_veh != player &&
	driver _veh == player &&
	isEngineOn _veh &&
	{getNumber (configFile >> "CfgVehicles" >> typeOf _veh >> "canFloat") > 0 &&
	{getTerrainHeightASL _pos < 1} &&
	{_pos select 2 <= 5} &&
	{vectorMagnitude velocity _veh <= abs _vel + 1} &&
	{if (_vel < 0) then { _veh call getFwdVelocity < 0.5 } else { _veh call getFwdVelocity > -0.5 }}}
)
