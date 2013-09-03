{deleteMarkerLocal _x;} forEach currentMissionsMarkers;
currentMissionsMarkers = [];

{
	private ["_marker"];
    
    _marker = createMarkerLocal [_x select 0, _x select 1];
	_marker setMarkerTypeLocal "mil_destroy";
    _marker setMarkerSizeLocal [1.25, 1.25];
	_marker setMarkerColorLocal "ColorRed";
	_marker setMarkerTextLocal (_x select 2);
    
	currentMissionsMarkers = currentMissionsMarkers + [_x select 0];
} forEach clientMissionMarkers;