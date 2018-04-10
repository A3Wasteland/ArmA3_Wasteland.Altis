// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_APC.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_vehicleClass", "_nbUnits"];

_setupVars =
{
	_vehicleClass = // to specify a vehicleLoadouts variant, simply write "class/variant", e.g. "O_Heli_Light_02_dynamicLoadout_F/orcaDAR"
	[
		["B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F", "B_APC_Tracked_01_AA_F"],
		["O_APC_Wheeled_02_rcws_v2_F", "O_APC_Tracked_02_cannon_F", "O_APC_Tracked_02_AA_F"],
		["I_APC_Wheeled_03_cannon_F", "I_APC_tracked_03_cannon_F"],
		["B_AFV_Wheeled_01_cannon_F", "B_AFV_Wheeled_01_up_cannon_F"] // Tanks DLC
	];

	while {_vehicleClass isEqualType []} do { _vehicleClass = selectRandom _vehicleClass };
	if (_vehicleClass find "/" != -1) then { _vehicleClass = _vehicleClass splitString "/" };

	private _vehicleClassTmp = _vehicleClass;
	if (_vehicleClassTmp isEqualType []) then { _vehicleClassTmp = _vehicleClassTmp select 0 };

	_missionType = switch (true) do
	{
		case ({_vehicleClassTmp isKindOf _x} count ["B_APC_Tracked_01_AA_F", "O_APC_Tracked_02_AA_F"] > 0): { "Anti Aircraft Vehicle" };
		case (_vehicleClassTmp isKindOf "Tank_F"):                                                          { "Infantry Fighting Vehicle" };
		case (_vehicleClassTmp isKindOf "AFV_Wheeled_01_base_F"):                                           { "Armored Fighting Vehicle" };
		default                                                                                             { "Armored Personnel Carrier" };
	};

	_locationsArray = MissionSpawnMarkers;

	_nbUnits = if (missionDifficultyHard) then { AI_GROUP_LARGE } else { AI_GROUP_MEDIUM };
};

_this call mission_VehicleCapture;
