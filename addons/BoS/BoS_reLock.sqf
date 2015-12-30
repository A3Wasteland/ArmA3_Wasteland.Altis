//	@file Version:
//	@file Name:
//	@file Author: Cael817 based on objectSearchinteraction.sqf from A3W
//	@file Created:

private ["_price", "_playerMoney"];

#define RADIUS 30
_maxLifetime = ["A3W_objectLifetime", 0] call getPublicVar;
_objects = nearestObjects [position player, ["thingX", "Building", "ReammoBox_F"], RADIUS];
_ownedObjects = {typeName _x == "OBJECT" && {!(isNil {_x getVariable "ownerUID"})} && {_x getVariable "objectLocked"}} count _objects;
//_ownedObjects = {typeName _x == "OBJECT" && {_x getVariable ["ownerUID",""] == getPlayerUID player}} count _objects; // Use this if you want only owned objects to be relocked.

_playerMoney = player getVariable "cmoney";
_price = _ownedObjects * 100;
_playerMoney = player getVariable "cmoney";


/*
if (isNIL "_relockedTime") exitWith
{
	_confirmMsg = format ["Normally this action would lock all objects within %1 radius but something went wrong or the Re Locker was already used this session, please try again later / next restart.", RADIUS];
	// Display confirm message
	if ([parseText _confirmMsg, "Information", "OK", false] call BIS_fnc_guiMessage) then
	{};
};*/

if (isNil "reLockedObjectMapMarkers") then {
	// This is the global we use to keep track of map markers
	reLockedObjectMapMarkers = [];
};

if (count reLockedObjectMapMarkers > 0) then {
	{
		deleteMarkerLocal _x;
	} forEach reLockedObjectMapMarkers;
	reLockedObjectMapMarkers = [];
	["Map cleared of previous markers", 5] call mf_notify_client;
};

if (!isNil "_price") then 
{
	// Add total sell value to confirm message
	_confirmMsg = format ["Re locking %1 baseparts/objects will cost you $%2<br/>Range is %3 meters, all relocked objects will be marked on map<br/>Objects will not load in after next restart if older than %4 hours.", _ownedObjects, _price, RADIUS, _maxLifetime];

	// Display confirm message
	if ([parseText _confirmMsg, "Confirm", "OK", true] call BIS_fnc_guiMessage) then
	{	
		// Ensure the player has enough money

		if (_price > _playerMoney) exitWith
		{
			hint format ["You need $%1 to Re Lock %2 objects",  _price, _ownedObjects];
			playSound "FD_CP_Not_Clear_F";
		};
		
		player setVariable["cmoney",(player getVariable "cmoney")-_price,true];
		
		reLockedObjectMapMarkers = [];
		{
		//if(_x getVariable "ownerUID" == getplayerUID player) then 
		if !(isNil {_x getVariable "ownerUID"}) then // Changed so also non owned objects are relocked
		{
		private ["_name","_objPos","_name","_marker"];
		_x setVariable ["baseSaving_hoursAlive", nil, true];
		_x setVariable ["baseSaving_spawningTime", nil, true];
		_x setVariable ["objectLocked",true,true];
		pvar_manualObjectSave = netId _x;
		publicVariableServer "pvar_manualObjectSave";
		//trackObject = _x;
		//publicVariableServer "trackObject";
		//_x setVariable ["ownerUID", getPlayerUID player, true]; //possibly set new owner?
		//_x setVariable ["ownerN", name player, true]; // set this here if not set in R3F?
		_name = gettext(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
		_objPos = getPosATL _x;
		_marker = "reLockedObjectMapMarkers" + (str _forEachIndex);
		_marker = createMarkerLocal [_marker, _objPos];
		_marker setMarkerTypeLocal "waypoint";
		_marker setMarkerPosLocal _objPos;
		_marker setMarkerTextLocal _name;
		_marker setMarkerColorLocal "ColorBlue";
		_marker setMarkerTextLocal _name;
	reLockedObjectMapMarkers pushBack _marker;
	};
} forEach _objects;


if (count reLockedObjectMapMarkers > 0) then {

	["Added Markers for the locked objects, they will be removed in 30 seconds", 5] call mf_notify_client;
	
	}else{
	//["No owned objects found within the set radius", 5] call mf_notify_client;
	[format ["No owned objects found within %1m",RADIUS], 5] call mf_notify_client;	
};
	
sleep 30;

if (count reLockedObjectMapMarkers > 0) then
{
	{
		deleteMarkerLocal _x;
	} forEach reLockedObjectMapMarkers;
	reLockedObjectMapMarkers = [];
	["Map cleared", 5] call mf_notify_client;
};

};
};