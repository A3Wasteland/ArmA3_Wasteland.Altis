// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_geoCache.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev, edit by CRE4MPIE & LouD
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf"

private ["_geoPos", "_geoCache", "_randomBox", "_randomCase", "_box1", "_para"];

_setupVars =
{
	_missionType = "GeoCache";
	_locationsArray = MissionSpawnMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	_geoPos = _missionPos vectorAdd ([[25 + random 20, 0, 0], random 360] call BIS_fnc_rotateVector2D);	
	_geoCache = createVehicle ["Land_SurvivalRadio_F",[(_geoPos select 0), (_geoPos select 1),0],[], 0, "NONE"];

	_missionHintText = "A GeoCache foi marcado no mapa. Há um pequeno objeto escondido perto do marcador. Encontre-o e uma recompensa via aérea! será entregue";
};

_ignoreAiDeaths = true;
_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;
_waitUntilSuccessCondition = {{isPlayer _x && _x distance _geoPos < 5} count playableUnits > 0};

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach [_GeoCache];
};

_successExec =
{
	// Mission completed
	{ deleteVehicle _x } forEach [_GeoCache];
	
	_randomBox = selectRandom ["mission_USLaunchers","mission_USSpecial","airdrop_LMGs"];
	_randomCase = ["Box_FIA_Support_F","Box_FIA_Wps_F","Box_FIA_Ammo_F"] call BIS_fnc_selectRandom;
	
	_box1 = createVehicle [_randomCase,[(_geoPos select 0), (_geoPos select 1),200],[], 0, "NONE"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1];

	playSound3D ["A3\data_f_curator\sound\cfgsounds\air_raid.wss", _box1, false, _box1, 15, 1, 1500];
	
	_para = createVehicle [format ["I_parachute_02_F"], [0,0,999999], [], 0, ""];

	_para setDir getDir _box1;
	_para setPosATL getPosATL _box1;

	_para attachTo [_box1, [0, 0, 0]];
	uiSleep 2;

	detach _para;
	_box1 attachTo [_para, [0, 0, 0]];

	while {(getPos _box1) select 2 > 3 && attachedTo _box1 == _para} do
	{
		_para setVectorUp [0,0,1];
		_para setVelocity [0, 0, (velocity _para) select 2];
		uiSleep 0.1;
	};
	
	_successHintMessage = "As fontes GEOCACHE foram entregues por pára-quedas!";
};

_this call sideMissionProcessor;