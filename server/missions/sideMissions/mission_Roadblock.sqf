// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_Roadblock.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private [ "_box1", "_barGate", "_bunker1","_bunker2","_obj1","_obj2"];

_setupVars =
{
	_missionType = "Roadblock";
	_reinforceChance = 75; // Chance of reinforcements being called
	_minReinforceGroups = 1; //minimum number of paradrop groups that will respond to call
	_maxReinforceGroups = 3; //maximum number of paradrop groups that will respond to call
};

_setupObjects =
{
	_missionLocation = ["RoadBlock_1","RoadBlock_2","RoadBlock_3","RoadBlock_4","RoadBlock_5","RoadBlock_6","RoadBlock_7","RoadBlock_8","RoadBlock_9","RoadBlock_10"] call BIS_fnc_selectRandom;
	_missionPos = markerPos _missionLocation;
	_markerDir = markerDir _missionLocation;
	
	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete; 	
	
_bargate = createVehicle ["Land_BarGate_F", _missionPos, [], 0, "NONE"];
_bargate setDir _markerDir;
_bunker1 = createVehicle ["Land_BagBunker_Small_F", _bargate modelToWorld [6.5,-2,-4.1], [], 0, "NONE"];
_obj1 = createVehicle ["I_GMG_01_high_F", _bargate modelToWorld [6.5,-2,-4.1], [], 0, "NONE"];
_bunker1 setDir _markerDir;
_bunker2 = createVehicle ["Land_BagBunker_Small_F", _bargate modelToWorld [-8,-2,-4.1], [], 0, "NONE"];
_obj2 = createVehicle ["I_GMG_01_high_F", _bargate modelToWorld [-8,-2,-4.1], [], 0, "NONE"];
_bunker2 setDir _markerDir;

	// NPC Randomizer 
_randomGroup = [createGroup1,createGroup2,createGroup3,createGroup4,createGroup5,createGroup6,createGroup7,createGroup8,createGroup9,createGroup10] call BIS_fnc_selectRandom;
_aiGroup  = createGroup CIVILIAN;
[_aiGroup, _missionPos] spawn _randomGroup;


		
	
	_missionHintText = format ["Enemies have set up an illegal roadblock and are searching vehicles! They need to be stopped!", sideMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	
	{ deleteVehicle _x } forEach [_barGate, _bunker1, _bunker2, _obj1, _obj2];
	
};

_successExec =
{
	// Mission completed
	
	_randomBox = ["mission_USLaunchers","mission_USSpecial","mission_Main_A3snipers","mission_TOP_Sniper","mission_TOP_Gear1","airdrop_DLC_Rifles","airdrop_DLC_LMGs","airdrop_Snipers"] call BIS_fnc_selectRandom;
	_randomCase = ["Box_FIA_Support_F","Box_FIA_Wps_F","Box_FIA_Ammo_F","Box_NATO_Wps_F","Box_East_WpsSpecial_F","Box_IND_WpsSpecial_F"] call BIS_fnc_selectRandom;
	
	_box1 = createVehicle [_randomCase, _missionPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;
	// Mission completed

	

	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1];
//	{ deleteVehicle _x } forEach [_barGate, _bunker1, _bunker2, _obj1, _obj2];
	

	_successHintMessage = format ["The roadblock has been dismantled."];
};

_this call sideMissionProcessor;
