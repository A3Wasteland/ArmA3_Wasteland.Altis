// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_vehicleKilledServer.sqf
//	@file Author: AgentRev

params ["_veh"];

_veh call A3W_fnc_setItemCleanup;

if (!isNil "fn_manualVehicleDelete") then
{
	[objNull, _veh getVariable "A3W_vehicleID"] call fn_manualVehicleDelete;
	_veh setVariable ["A3W_vehicleSaved", false, false];
};

{
	if (isAgent teamMember _x) then
	{
		deleteVehicle _x;
	};
} forEach crew _vehicle;

// Stop vehicle siren
if (isClass (configFile >> "CfgVehicles" >> (typeOf _veh) >> "UserActions" >> "siren_stop")) then
{
	[_veh,'CustomSoundController1',0,0.4] remoteExec ['BIS_fnc_setCustomSoundController'];
};
