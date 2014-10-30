// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*********************************************************#
# @@ScriptName: updateMarkers.sqf
# @@Author: Nick 'Bewilderbeest' Ludlam <bewilder@recoil.org>
# @@Create Date: 2013-09-15 16:26:30
# @@Modify Date: 2013-09-21 23:45:39
# @@Function:
#*********************************************************/

// duplicated from capturePointMonitor.sqf
_markerColorForSide = {
	private['_side', '_markerColor'];
	_side = _this select 0;
	//diag_log format["_markerColorForSide called with %1", _this];

	_markerColor = "";
	switch (_side) do {
		case "WEST": { _markerColor = "colorblue"; };
		case "EAST": { _markerColor = "colorred"; };
		case "GUER": { _markerColor = "colorgreen"; };
		default { _markerColor = "coloryellow"; };
	};

	//diag_log format["_markerColorForSide returning %1", _markerColor];

	_markerColor
};

// MAIN

{
	private ['_markerName', '_markerOwnerSide', '_color'];
	//diag_log format["OPC marker setup loop %1", _x];
	_markerName = _x select 0;
	_markerOwnerSide = _x select 3;
	if (_markerOwnerSide != "") then {
	    _color = [_markerOwnerSide] call _markerColorForSide;
		_markerName setMarkerColor _color;
		//diag_log format ["OPC setting %1 to %2", _markerName, _color];
	};
} forEach lastCapturePointDetails;
