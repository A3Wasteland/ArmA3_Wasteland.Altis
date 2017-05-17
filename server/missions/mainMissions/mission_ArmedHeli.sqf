// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_ArmedHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits", "_variant"];

_setupVars =
{
	_vehicleClass = selectRandom
	[
		["B_Heli_Light_01_dynamicLoadout_F", "pawneeNormal"],
		"B_Heli_Transport_01_F",
		"B_Heli_Attack_01_dynamicLoadout_F",
		["O_Heli_Light_02_dynamicLoadout_F", "orcaDAGR"],
		"O_Heli_Attack_02_dynamicLoadout_F",
		"I_Heli_light_03_dynamicLoadout_F"
	];

	if (_vehicleClass isEqualType []) then
	{
		_variant = _vehicleClass param [1,"",[""]];
		_vehicleClass = _vehicleClass select 0;
	};

	_missionType = "Armed Helicopter";
	_locationsArray = MissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_VehicleCapture;
