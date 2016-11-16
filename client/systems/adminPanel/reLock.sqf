// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: reLock.sqf
//	@file Author: LouD
//	@file Created: 15-08-2015

#define RADIUS 30
_maxLifetime = ["A3W_objectLifetime", 0] call getPublicVar;
_objects = nearestObjects [position player, ["thingX", "Building", "ReammoBox_F"], RADIUS];
_ownedObjects = {typeName _x == "OBJECT" && {!(isNil {_x getVariable "ownerUID"})} && {_x getVariable "objectLocked"}} count _objects;

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

_confirmMsg = format ["Re locking %1 baseparts/objects<br/>Range is %2 meters, all relocked objects will be marked on map<br/>Objects will not load in after next restart if older than %3 hours.", _ownedObjects, RADIUS, _maxLifetime];

if ([parseText _confirmMsg, "Confirm", "OK", true] call BIS_fnc_guiMessage) then
{	
	reLockedObjectMapMarkers = [];
	{
		if !(isNil {_x getVariable "ownerUID"}) then // Also non owned objects are relocked
		{
			private ["_name","_objPos","_name","_marker"];
			_x setVariable ["baseSaving_hoursAlive", nil, true];
			_x setVariable ["baseSaving_spawningTime", nil, true];
			_x setVariable ["objectLocked",true,true];
			pvar_manualObjectSave = netId _x;
			publicVariableServer "pvar_manualObjectSave";
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

	if (count reLockedObjectMapMarkers > 0) then 
	{
		["Added Markers for the locked objects, they will be removed in 30 seconds", 5] call mf_notify_client;
	}
	else
	{
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