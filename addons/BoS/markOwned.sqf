//	@file Version: 1.0
//	@file Name: markOwned.sqf
//	@file Author: Cael817 Cael817, based on objectSearchinteraction.sqf from A3W
//	@file Created: 20150129 17:02

#define RADIUS 1000
_maxLifetime = ["A3W_objectLifetime", 0] call getPublicVar;
_objects = nearestObjects [position player, ["Landvehicle", "Ship", "Air", "Building", "ReammoBox_F", "thingX"], 1000];


if (isNil "ownedObjectMapMarkers") then {
	// This is the global we use to keep track of map markers
	ownedObjectMapMarkers = [];
};

if (count ownedObjectMapMarkers > 0) then {

	{
		deleteMarkerLocal _x;
	} forEach ownedObjectMapMarkers;
	ownedObjectMapMarkers = [];
	["Map cleared of previous markers", 5] call mf_notify_client;
};

ownedObjectMapMarkers = [];
_relockTime = [];
{
	if(_x getVariable "ownerUID" == getplayerUID player) then
	
	{
	private ["_name","_objPos","_name","_marker"];
	_name = gettext(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
	_objPos = getPosATL _x;
	_relockTime = _x getVariable ["baseSaving_hoursAlive", 0];
	_marker = "ownedObjectMapMarkers" + (str _forEachIndex);
	_marker = createMarkerLocal [_marker,_objPos];
	_marker setMarkerTypeLocal "waypoint";
	_marker setMarkerPosLocal _objPos;
	//_marker setMarkerTextLocal _name;
	_marker setMarkerSizeLocal [0.6,0.6];

	if ((_maxLifetime - _relockTime) < 32) then
	{
		_marker setMarkerColorLocal "ColorOrange";
		_marker setMarkerTextLocal _name + "Relock within 24h";
	}else{
		if (_relockTime < 0.1) then{
		_marker setMarkerColorLocal "ColorBlue";
		_marker setMarkerTextLocal _name + "Object was locked this session";
		}else{
		_marker setMarkerColorLocal "ColorBlue";
		_marker setMarkerTextLocal _name + format ["%1 Hours since locked" , _relockTime];
	};
	};
	ownedObjectMapMarkers pushBack _marker;
	};
} forEach _objects;
	//hint format ["_relockTime is %1 _maxLifetime is %2", _relockTime, _maxLifetime];
	if (count ownedObjectMapMarkers > 0) then {

		["Added Markers for your objects on the map, they will be removed in 30 seconds", 5] call mf_notify_client;
		
		}else{
		
		//["No owned objects found within the set radius", 5] call mf_notify_client;
		[format ["No owned objects found within %1m",RADIUS], 5] call mf_notify_client;	
		
	};
	
sleep 30;
	
	if (count ownedObjectMapMarkers > 0) then {

		{
			deleteMarkerLocal _x;
		} forEach ownedObjectMapMarkers;
		ownedObjectMapMarkers = [];
		["Map cleared", 5] call mf_notify_client;
	};
