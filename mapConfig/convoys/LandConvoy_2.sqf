// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: LandConvoy_2.sqf
//	@file Author: AgentRev

// for Tanoa

// starting positions for this route
_starts =
[
	markerPos "LandConvoy_2_1",
	markerPos "LandConvoy_2_2",
	markerPos "LandConvoy_2_3"
];

// starting directions in which the vehicles are spawned on this route
_startDirs =
[
	markerDir "LandConvoy_2_1",
	markerDir "LandConvoy_2_2",
	markerDir "LandConvoy_2_3"
];

// the route
_waypoints =
[
	[11449.4, 9738.05],
	[10027.4, 9607.99],
	[9114.16, 10132.5],
	[8344.92, 9771.78],
	[7662.87, 8552.73],
	[7078.49, 7853.49],
	[6469.92, 7368.74],
	[5164.45, 8791.95],
	[4606.45, 8817.87],
	[4335.51, 8431.59]
];

// to easily create waypoints, go in the editor, create player and preview scenario, place double-click markers in desired order on the map, and run this code:
// copyToClipboard str (allMapMarkers apply {markerPos _x select [0,2]})

// and there you go, positions in clipboard
