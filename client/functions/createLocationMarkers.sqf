//	@file Version: 1.0
//	@file Name: createGunStoreMarkers.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap
//	@file Args:

private["_markerName", "_marker","_myLocation","_randx","_randy","_markerpos"];
while{true}do{

    _markerName = "myposition";
    _mylocation = getPos player;
    _randx = floor (random (500)) - 250; 
    _randy = floor (random (500)) - 240;
    _markerpos = [(_mylocation select 0) + _randy,(_mylocation select 1) + _randx, _mylocation select 2];
//    _markerpos = _mylocation;
    deleteMarkerLocal _markerName;
	_marker = createMarkerLocal [_markerName, _markerpos];
    _markerName setMarkerColorLocal "ColorRed";
	_markerName setMarkerShapeLocal "ELLIPSE";
	_markerName setMarkerSizeLocal [500, 500];
	_markerName setMarkerBrushLocal "Border";
	_markerName setMarkerAlphaLocal 1.0;
    While {_mylocation distance player < 200}do{
        sleep 5;
    };
};
