// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: createGeneralStoreMarkers.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 28/11/2012 05:19
//	@file Args:

//Creates the markers around general stores.
{
	if (!isPlayer _x && {(vehicleVarName _x) select [0,8] == "GenStore"}) then
	{
		_npcPos = getPosATL _x;

		// General store title
		_markerName = format["marker_shop_title_%1",_x];
		deleteMarkerLocal _markerName;
		_marker = createMarkerLocal [_markerName, _npcPos];
		_markerName setMarkerShapeLocal "ICON";
		
		//_markerName setMarkerTypeLocal "mil_dot";
		_markerName setMarkerTypeLocal "loc_Tourism";
		_markerName setMarkerColorLocal "ColorBlue";
		_markerName setMarkerSizeLocal [1.5,1.5];
		_markerName setMarkerTextLocal "";
	};
} forEach entities "CAManBase";
