// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: checkMissionVehicleLock.sqf
//	@file Author: AgentRev

if (!isServer) exitwith {};

private "_shepherd";

_vehicle = _this select 0;
_group = _this select 1;

// STOP LEAVING THE VEHICLE, STUPID AI
if (_vehicle isKindOf "LandVehicle") then
{
	_vehicle setUnloadInCombat [false, false];
	_shepherd = _vehicle addEventHandler ["GetOut",
	{
		_unit = _this select 2;
		_veh = assignedVehicle _unit;

		if (canMove _veh) then
		{ 
			[_unit] orderGetIn true;

			if ((assignedVehicleRole _unit) param [0,""] == "Driver") then
			{
				_unit moveInDriver _veh; // bruteforce driver to remain seated
			};
		};
	}];
};

(units _group) allowGetIn true;

while {alive _vehicle && _vehicle getVariable ["R3F_LOG_disabled", false]} do
{
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

if (!isNil "_shepherd") then
{
	_vehicle removeEventHandler ["GetOut", _shepherd];
};
