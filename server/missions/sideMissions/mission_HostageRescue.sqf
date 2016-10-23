// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_HostageRescue.sqf
//	@file Author: JoSchaap, AgentRev, GriffinZS, RickB, soulkobk

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_nbUnits", "_camonet", "_hostage", "_obj1", "_obj2", "_obj3", "_chair", "_randomBox", "_randomBox2", "_box1", "_box2"];

_setupVars =
{
	_missionType = "Rescue Arms Dealer";
	_locationsArray = [ForestMissionMarkers, MissionSpawnMarkers] select (ForestMissionMarkers isEqualTo []);
	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;

	//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
	{ deleteVehicle _x } forEach _baseToDelete; 

	_camonet = createVehicle ["Land_Shed_06_F", [_missionPos select 0, _missionPos select 1], [], 0, "CAN COLLIDE"];
	_camonet allowdamage false;
	_camonet setDir random 360;
	_camonet setVariable ["R3F_LOG_disabled", false];

	_missionPos = getPosATL _camonet;

	_chair = createVehicle ["Land_Slums02_pole", _missionPos, [], 0, "CAN COLLIDE"];
	_chair setPosATL [_missionPos select 0, _missionPos select 1, _missionPos select 2];

	_hostage = createVehicle ["C_Nikos_aged", _missionPos, [], 0, "CAN COLLIDE"];
	_hostage setPosATL [_missionPos select 0, _missionPos select 1, _missionPos select 2];
	waitUntil {alive _hostage};
	[_hostage, "Acts_AidlPsitMstpSsurWnonDnon_loop"] call switchMoveGlobal;
	_hostage disableAI "anim";

	_obj1 = createVehicle ["I_GMG_01_high_F", _missionPos,[], 10,"None"]; 
	_obj1 setPosATL [(_missionPos select 0) - 2, (_missionPos select 1) + 2, _missionPos select 2];

	_obj2 = createVehicle ["I_HMG_01_high_F", _missionPos,[], 10,"None"]; 
	_obj2 setPosATL [(_missionPos select 0) - 2, (_missionPos select 1) - 2, _missionPos select 2];

	_obj3 = createVehicle ["I_HMG_01_high_F", _missionPos,[], 10,"None"]; 
	_obj3 setPosATL [(_missionPos select 0) + 2, (_missionPos select 1) - 2, _missionPos select 2];

	_randomBox = selectRandom ["mission_USLaunchers","mission_Main_A3snipers","mission_Uniform","mission_DLCLMGs","mission_ApexRifles"];
	_randomBox2 = selectRandom ["mission_USSpecial","mission_HVSniper","mission_DLCRifles","mission_HVLaunchers"];

	_box1 = createVehicle ["Box_NATO_WpsSpecial_F", _missionPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;

	_box2 = createVehicle ["Box_East_WpsSpecial_F", _missionPos, [], 5, "None"];
	_box2 setDir random 360;
	[_box2, _randomBox2] call fn_refillbox;

	{ _x setVariable ["R3F_LOG_disabled", true, true] } forEach [_box1, _box2];

	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits] call createCustomGroup4;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";

	_missionHintText = format ["<br/>An arms dealer has been kidnapped by bandits!<br/> Free him and get some of his high value gear!", sideMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = {!alive _hostage};

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_camonet, _obj1, _obj2, _obj3, _hostage, _chair, _box1, _box2];
	_failedHintMessage = format ["<br/>The arms dealer is dead! Bandits now have the gear."];
};

_successExec =
{
	// Mission completed
	{ deleteVehicle _x } forEach [_camonet, _obj1, _obj2, _obj3, _hostage, _chair];
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];
	_successHintMessage = format ["<br/>Well done! You saved the life of the arms dealer. Grab his gear to use in the fight."];
};

_this call sideMissionProcessor;