//	@file Version: 1.0
//	@file Name: createGeneralStoreMarkers.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 28/11/2012 05:19
//	@file Args:

_generalStores = ["generalStore1","generalStore2","generalStore3","generalStore4","generalStore5"];

//Creates the markers around general stores.
waitUntil {{!isNull(missionNamespace getVariable _x) && ((getPos(missionNamespace getVariable _x) distance [0,0,0]) > 100)} count _generalStores == count _generalStores};
{
	_unit = missionNamespace getVariable _x;

	// General store title    
    _markerName = format["marker_shop_title_%1",_x];
    deleteMarkerLocal _markerName;
	_marker = createMarkerLocal [_markerName, getPos _unit];
	_markerName setMarkerShapeLocal "ICON";
    _markerName setMarkerTypeLocal "mil_dot";
    _markerName setMarkerColorLocal "ColorOrange";
	_markerName setMarkerSizeLocal [1,1];
	_markerName setMarkerTextLocal "General Store";

} forEach _generalStores;

