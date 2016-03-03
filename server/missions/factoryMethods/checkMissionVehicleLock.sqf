// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: checkMissionVehicleLock.sqf
//	@file Author: AgentRev

if (!isServer) exitwith {};

private ["_vehicle", "_group"];

_vehicle = _this select 0;
_group = _this select 1;

while {alive _vehicle && _vehicle getVariable ["R3F_LOG_disabled", false]} do
{
	_vehicle setUnloadInCombat [false, false]; // STOP LEAVING THE VEHICLE, STUPID AI

	if ({alive _x && group _x == _group} count crew _vehicle > 0) then
	{
		if (locked _vehicle < 3) then { _vehicle lock 3 };
	}
	else
	{
		if (locked _vehicle > 1) then { _vehicle lock 1 };
	};

	sleep 3;
};

_vehicle lock 1;
