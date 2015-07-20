// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_HackLaptop.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "extraMissionDefines.sqf";

private ["_bunker", "_laptop", "_obj", "_randomGroup", "_vehicleName"];

_setupVars =
{
	_missionType = "Enemy Laptop";

	_locationsArray = MissionSpawnMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	_bunker = createVehicle ["Land_BagBunker_Small_F", [_missionPos select 0, _missionPos select 1], [], 0, "CAN COLLIDE"];

	_missionPos = getPosASL _bunker;

	_laptop = createVehicle ["Land_Laptop_unfolded_F", _missionPos, [], 0, "CAN COLLIDE"];
	_laptop setPosASL [_missionPos select 0, (_missionPos select 1) - 0.25, _missionPos select 2];

	_obj = createVehicle ["I_HMG_01_high_F", _missionPos,[], 10,"None"]; 
	_obj setPosASL [_missionPos select 0, (_missionPos select 1) + 2, _missionPos select 2];

	AddLaptopHandler = _laptop;
	publicVariable "AddLaptopHandler";

	_laptop setVariable [ "Done", false, true ];

	// NPC Randomizer 
	_randomGroup = [createGroup1,createGroup2,createGroup3,createGroup4,createGroup5] call BIS_fnc_selectRandom;
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos] spawn _randomGroup;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";	
	
	_vehicleName = "Laptop";
	_missionHintText = format ["A <t color='%2'>%1</t> with enemy bank accounts has been spotted, go hack it.", _vehicleName, extraMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec =
{
	AddLaptopHandler = _laptop;
	publicVariable "AddLaptopHandler";
};
_waitUntilCondition = nil;
_waitUntilSuccessCondition = { _laptop getVariable ["Done", false] };
_ignoreAiDeaths = true;

_failedExec =
{
	// Mission failed
	RemoveLaptopHandler = _laptop;
	publicVariable "RemoveLaptopHandler";
	{ deleteVehicle _x } forEach [_bunker, _obj, _laptop];
};

_successExec =
{
	// Mission completed
	RemoveLaptopHandler = _laptop;
	publicVariable "RemoveLaptopHandler";
	{ deleteVehicle _x } forEach [_bunker, _laptop];

	_successHintMessage = format ["The laptop is hacked and the smugglers are dead. The weapons and money are yours!"];
};

_this call extraMissionProcessor;