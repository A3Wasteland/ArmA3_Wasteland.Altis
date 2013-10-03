//	@file Version: 1.0
//	@file Name: createGeneralStoreMarkers.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 28/11/2012 05:19
//	@file Args:

_generalStores = ["move_GenStore1","move_GenStore2","move_GenStore3","move_GenStore4"];

//Creates the markers around general stores.
{
	_markerPos = (getMarkerPos _x);

	// General store title    
    _markerName = format["marker_shop_title_%1",_x];
    deleteMarkerLocal _markerName;
	_marker = createMarkerLocal [_markerName, _markerPos];
	_markerName setMarkerShapeLocal "ICON";
    _markerName setMarkerTypeLocal "mil_dot";
    _markerName setMarkerColorLocal "ColorOrange";
	_markerName setMarkerSizeLocal [1,1];
	_markerName setMarkerTextLocal "General Store";

} forEach _generalStores;

