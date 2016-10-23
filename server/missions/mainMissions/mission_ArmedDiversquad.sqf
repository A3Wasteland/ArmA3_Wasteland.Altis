// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedDiversquad.sqf
//	@file Author: JoSchaap, AgentRev

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_box1", "_box2", "_boxPos", "_vehicleClass", "_vehicle", "_randomBox", "_randomBox2"];

_setupVars =
{
	_missionType = "Armed Diving Expedition";
	_locationsArray = SunkenMissionMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	_randomBox = selectRandom ["mission_USLaunchers","mission_Main_A3snipers","mission_Uniform","mission_DLCLMGs","mission_ApexRifles"];
	_randomBox2 = selectRandom ["mission_USSpecial","mission_HVSniper","mission_DLCRifles","mission_HVLaunchers"];
	_box1 = createVehicle ["Box_IND_WpsSpecial_F", _missionPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;

	_box2 = createVehicle ["Box_NATO_WpsSpecial_F", _missionPos, [], 5, "None"];
	_box2 setDir random 360;
	[_box2, _randomBox2] call fn_refillbox;

	{
		_boxPos = getPosASL _x;
		_boxPos set [2, getTerrainHeightASL _boxPos + 1];
		_x setPos _boxPos;
		_x setVariable ["R3F_LOG_disabled", true, true];
	} forEach [_box1, _box2];

	_vehicleClass = ["B_Boat_Armed_01_minigun_F", "O_Boat_Armed_01_hmg_F", "I_Boat_Armed_01_minigun_F"] call BIS_fnc_selectRandom;

	// Vehicle Class, Position, Fuel, Ammo, Damage, Special
	_vehicle = [_vehicleClass, _missionPos] call createMissionVehicle2;
	_vehicle setPosASL _missionPos;
	_vehicle lockDriver true;

	[_vehicle, [
		["itm", "U_B_Wetsuit", 2],
		["itm", "U_O_Wetsuit", 2],
		["itm", "U_I_Wetsuit", 2],
		["itm", "V_RebreatherB", 2],
		["itm", "G_Diving", 2],
		["wep", "arifle_SDAR_F", 2],
		["mag", "20Rnd_556x45_UW_mag", 8]
	]] call processItems;

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos] call createLargeDivers;

	[_vehicle, _aiGroup] spawn checkMissionVehicleLock;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _vehicleClass >> "picture");
	_missionHintText = "An armed expedition is trying to recover sunken ammo crates.<br/>You will need diving gear and an underwater weapon to complete the mission.";
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_box1, _box2];
};

// _vehicle is automatically deleted or unlocked in missionProcessor depending on the outcome

_successExec =
{
	// Mission complete
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];
	_vehicle lockDriver false;

	_successHintMessage = "The sunken crates have been captured. Well done.";
};

_this call mainMissionProcessor;
