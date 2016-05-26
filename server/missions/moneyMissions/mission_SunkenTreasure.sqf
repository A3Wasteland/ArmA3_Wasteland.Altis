// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_WepCache.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args:

if (!isServer) exitwith {};
#include "moneyMissionDefines.sqf";

private ["_cashObjects", "_cash", "_cashPos", "_box1", "_boxPos", "_vehicleClass", "_vehicle"];

_setupVars =
{
	_missionType = "Sunken Treasure";
	_locationsArray = SunkenMissionMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	_box1 = createVehicle ["Box_NATO_Wps_F", _missionPos, [], 0, "None"];
	_box1 setVariable ["R3F_LOG_disabled", true, true];
	_box1 setDir random 360;
	[_box1, "mission_USSpecial"] call fn_refillbox;

	_cashObjects = [];

	for "_i" from 1 to 10 do
	{
		_cash = createVehicle ["Land_Money_F", _missionPos, [], 0, "None"];
		_cash setVariable ["owner", "mission", true];
		//_cashPos = getPosATL _cash;
		//_cashPos set [2, getTerrainHeightASL _cashPos + 1];
		//_cash setPos _cashPos;

		// Money value is set only when AI are dead
		_cashObjects pushBack _cash;
	};

	_vehicleClass = ["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;

	// Vehicle Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle2;
	_vehicle setPosASL _missionPos;
	_vehicle lockDriver true;

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos] call createLargeDivers;

	[_vehicle, _aiGroup] spawn checkMissionVehicleLock;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_missionHintText = format ["A treasure containing <t color='%1'>$50,000</t> and weapons is being recovered.<br/>If you want to capture it, you will need diving gear and an underwater weapon.", moneyMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach _cashObjects;
	deleteVehicle _box1;
};

// _vehicle is automatically deleted or unlocked in missionProcessor depending on the outcome

_successExec =
{
	// Mission complete
	_box1 setVariable ["R3F_LOG_disabled", false, true];
	_vehicle lockDriver false;

	// Give the rewards
	{
		_x setVariable ["cmoney", 5000, true];
		_x setVariable ["owner", "world", true];
	} forEach _cashObjects;

	_successHintMessage = "The treasure has been captured, well done.";
};

_this call moneyMissionProcessor;
