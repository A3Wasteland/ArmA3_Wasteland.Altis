//	@file Version: 1.0
//	@file Name: createTownMarkers.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 28/11/2012 05:19
//	@file Args:

{
    _pos = getMarkerPos (_x select 0);
    _markerName = format["marker%1",_forEachIndex];
	_marker = createMarkerLocal [_markerName, _pos];
	_marker setMarkerShapeLocal "ELLIPSE";
	_marker setMarkerSizeLocal [_x select 1, _x select 1];
	_marker setMarkerColorLocal "ColorBlue";
    _marker setMarkerBrushLocal "SolidBorder";
	_marker setMarkerAlphaLocal 0.3;   
}forEach (call cityList);