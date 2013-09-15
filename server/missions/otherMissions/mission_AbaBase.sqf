//	@file Version: 1.0
//	@file Name: mission_Base.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 08/12/2012 04:56
//	@file Args:

//Side Mission Colour = #4BC9B0 - Turquoise 
//Main Mission Colour = #52bf90 - Light blue
//Fail Mission Colour = #FF1717 - Light red
//Fail Mission Colour = #17FF41 - Light green
//Sub Colour = #FFF - White

if (!isServer) exitwith {};

diag_log format["WASTELAND SERVER - Mission Started"];
private ["_base","_unitsAlive","_playerPresent","_missionType","_successTextColour","_mainTextColour","_failTextColour","_subTextColour","_picture","_vehicleName","_rad","_centerPos","_missionTimeOut","_missionDelayTime","_missionTriggerRadius","_missionPlayerRadius","_flatAreas","_randomArea","_hint","_startTime","_currTime","_result","_tank", "_randomPos"];

//Mission Initialization.
_rad=20000;
_result = 0;
_missionType = "Capture Military Base";
_mainTextColour = "#52bf90";
_successTextColour = "#17FF41";
_failTextColour = "#FF1717";
_subTextColour = "#FFFFFF";
_missionTimeOut = 1800;
_missionDelayTime = 1200;
_missionPlayerRadius = 50;

_GotLoc = false;
while {!_GotLoc} do 
{
	_randomIndex = random (count MissionSpawnMarkers - 1);

	//If the index of the mission markers array is false then break the loop and finish up doing the mission
	if (!((MissionSpawnMarkers select _randomIndex) select 1)) then 
	{
		_selectedMarker = MissionSpawnMarkers select _randomIndex select 0;
		_randomPos = getMarkerPos _selectedMarker;
		MissionSpawnMarkers select _randomIndex set[1, true];
		_GotLoc = true;
	};
};

//ensure the rest of the script doesn't continue until we are done
waitUntil {_GotLoc};

//Tell everyone their will be a mission soon.
_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 Minutes</t>", _missionDelayTime / 60, _mainTextColour, _subTextColour];
[_hint] call hintBroadcast;

//Wait till the mission is ready to be ran.
diag_log format["WASTELAND SERVER - Mission Waiting to run"];
_startTime = floor(time);
waitUntil
{ 
    sleep 1;
    _currTime = floor(time);
    if(_currTime - _startTime >= _missionDelayTime) then {_result = 1;};	
    (_result == 1)
};
diag_log format["WASTELAND SERVER - Mission Resumed"];
_result = 0;

//Add marker to client marker array.
clientMissionMarkers set [count clientMissionMarkers,["Base_Marker",_randomPos,"Capture Military Base"]];
publicVariable "clientMissionMarkers";

_veh = ["outpostUS1"] call BIS_fnc_selectRandom;
_base = [_veh, 0, _randomPos] execVM "server\functions\createBase.sqf";

_vehicleName = "Outpost";
_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>A<t color='%3'> %2</t>, has been spotted near the marker go capture it.</t>", _missionType, _vehicleName, _mainTextColour, _subTextColour];
[_hint] call hintBroadcast;

_group = createGroup civilian;
[_group,_randomPos]execVM "server\missions\createUnits\largeGroup.sqf";
[_group, _randomPos] call BIS_fnc_taskDefend;

diag_log format["WASTELAND SERVER - Mission Waiting to be Finished"];
_startTime = floor(time);
waitUntil
{
    sleep 1; 
	_playerPresent = false;
    _currTime = floor(time);
    if(_currTime - _startTime >= _missionTimeOut) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _tank <= _missionPlayerRadius)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units _CivGrpM);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _tank) == 1)
};

if(_result == 1) then
{
	//Mission Failed.
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Objective failed, better luck next time</t>", _missionType, _vehicleName, _failTextColour, _subTextColour];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Mission Failed"];
} else {
	//Mission Complete.
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>The base has been captured, use what you found to help you crush the enemy</t>", _missionType, _vehicleName, _successTextColour, _subTextColour];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Mission Finished"];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false]; 

//Remove marker from client marker array.
{
    if(_x select 0 == "Base_Marker") then
    {
    	clientMissionMarkers set [_forEachIndex, "REMOVETHISCRAP"];
		clientMissionMarkers = clientMissionMarkers - ["REMOVETHISCRAP"];
        publicVariable "clientMissionMarkers";    
    };
}forEach clientMissionMarkers;
mainMissionRunning = false;
