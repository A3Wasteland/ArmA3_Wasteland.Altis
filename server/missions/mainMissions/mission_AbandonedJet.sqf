// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_AbandonedJet.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_vehicle", "_vehicleName", "_vehDeterminer", "_vehicleClass"];

_setupVars =
{
	_vehicleClass =
	[
		"I_Plane_Fighter_03_CAS_F", 
		"B_Plane_CAS_01_F",
		"O_Plane_CAS_02_F"
	] call BIS_fnc_selectRandom;

	_missionType = "Abandoned Jet";
	_locationsArray = MissionSpawnMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	// Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle;

	// Remove AGM missiles for balance
	switch (true) do
	{
		case (_vehicle isKindOf "Plane_CAS_01_base_F"):
		{
			_vehicle setMagazineTurretAmmo ["6Rnd_Missile_AGM_02_F", 0, [-1]];
		};
		case (_vehicle isKindOf "Plane_CAS_02_base_F"):
		{
			_vehicle setMagazineTurretAmmo ["4Rnd_Missile_AGM_01_F", 0, [-1]];
		};
	};

	// Reset all flares to 60
	if (_vehicleClass isKindOf "Air") then
	{
		{
			if (["CMFlare", _x] call fn_findString != -1) then
			{
				_vehicle removeMagazinesTurret [_x, [-1]];
			};
		} forEach getArray (configFile >> "CfgVehicles" >> _vehicleClass >> "magazines");

		_vehicle addMagazineTurret ["60Rnd_CMFlare_Chaff_Magazine", [-1]];
	};

	reload _vehicle;

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos,12,15] spawn createCustomGroup3;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "displayName");

	_vehDeterminer = if ("AEIMO" find (_vehicleName select [0,1]) != -1) then { "An" } else { "A" };

	_missionHintText = format ["%1 <t color='%3'>%2</t> has been immobilized, go get it for your team!", _vehDeterminer, _vehicleName, mainMissionColor];	
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
//_waitUntilCondition = nil;
_waitUntilCondition = {!alive _vehicle};

_failedExec =
{
	// Mission failed
	deleteVehicle _vehicle;
};

_successExec =
{
	// Mission completed
	_vehicle lock 1;
	_vehicle setVariable ["R3F_LOG_disabled", false, true];

	_successHintMessage = format ["The %1 has been captured, well done.", _vehicleName];
};

_this call mainMissionProcessor;