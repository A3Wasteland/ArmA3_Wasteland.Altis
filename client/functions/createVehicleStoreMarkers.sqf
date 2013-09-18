//	@file Version: 1.0
//	@file Name: createVehicleStoreMarkers.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 28/11/2012 05:19
//	@file Args:

_vehicleStores = ["move_VehStore1","move_VehStore2","move_VehStore3","move_VehStore4"];

//Creates the markers around vehicle stores.
{
	_unit = (getMarkerPos _x);
	// Vehicle store title    
    _markerName = format["marker_shop_title_%1",_x];
    deleteMarkerLocal _markerName;
	_marker = createMarkerLocal [_markerName, _unit];
	_markerName setMarkerShapeLocal "ICON";
    _markerName setMarkerTypeLocal "mil_dot";
    _markerName setMarkerColorLocal "ColorOrange";
	_markerName setMarkerSizeLocal [1,1];
	_markerName setMarkerTextLocal "Vehicle Store";

} forEach _vehicleStores;

