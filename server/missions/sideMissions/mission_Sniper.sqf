// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_Sniper.sqf
//	@file Author: JoSchaap, AgentRev, LouD

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_positions", "_box1", "_box2", "_missionPos", "_randomBox", "_randomBox2"];

_setupVars =
{
	_missionType = "Sniper Nest";
	_locationsArray = SniperMissionMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup,_missionPos] call createsniperGroup;

	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";
	
	_missionHintText = format ["Snipers estão protegendo caixas de ARMAS com vários itens não encontrados para venda. Tente recupera-las! CUIDADO!!! Eles estão totalmente armados e perigosos!", sideMissionColor];
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
};

_successExec =
{
	// Mission completed
	_randomBox = selectRandom ["mission_USLaunchers","mission_HVLaunchers"];
	_randomBox2 = selectRandom ["mission_HVSniper","mission_Main_A3snipers","mission_snipers"];
	_box1 = createVehicle ["Box_East_WpsSpecial_F", _missionPos, [], 2, "None"];
	_box1 setDir random 360;
	[_box1, _randomBox] call fn_refillbox;
	
	_box2 = createVehicle ["Box_IND_WpsSpecial_F", _missionPos, [], 2, "None"];
	_box2 setDir random 360;
	[_box2, _randomBox2] call fn_refillbox;

	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach [_box1, _box2];
	
	_successHintMessage = format ["Os snipers estão mortos. Bom trabalho."];
};

_this call sideMissionProcessor;