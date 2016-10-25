// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_Sniper.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_positions", "_boxes1", "_currBox1", "_box1", "_obj", "_tent"];

_setupVars =
{
	_missionType = "Sniper Overwatch";
	_locationsArray = MissionSpawnMarkers;
};

	
_setupObjects =
{
	_missionPos = markerPos _missionLocation;
		//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete; 
	
	
	_randomBox = ["mission_TOP_Gear1","mission_TOP_Sniper","mission_USSpecial","mission_USLaunchers","mission_USSpecial","mission_Main_A3snipers"] call BIS_fnc_selectRandom;
	_box1 = createVehicle ["Box_NATO_AmmoOrd_F", _missionPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;
	
	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_box1];
	
	_obj = createVehicle ["I_GMG_01_high_F", _missionPos,[], 10,"None"]; 
	_obj setPosATL [_missionPos select 0, (_missionPos select 1) + 2, _missionPos select 2];
	_tent = createVehicle ["CamoNet_INDP_big_F", _missionPos, [], 3, "None"];
	_tent allowDamage false;
	_tent setDir random 360;
	_tent setVariable ["R3F_LOG_disabled", false];
	//_missionPos = getPosASL _tent;
	
	
	_aiGroup = createGroup CIVILIAN;
    [_aiGroup,_missionPos] spawn createcustomGroup3;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";
	
	_missionHintText = format ["A small group of Snipers are setting up overwatch. Head to the marked area and Take them out! Be careful they are fully armed and dangerous!", sideMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_box1, _tent, _obj];
	
};

_successExec =
{
	// Mission completed
	
	_successHintMessage = format ["The snipers are dead! Well Done!"];
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1];
};

_this call sideMissionProcessor;
