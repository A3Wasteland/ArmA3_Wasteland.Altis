// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: LandConvoy_1.sqf
//	@file Author: AgentRev

// for Tanoa

// starting positions for this route
_starts =
[
	markerPos "LandConvoy_1_1",
	markerPos "LandConvoy_1_2",
	markerPos "LandConvoy_1_3"
];

// starting directions in which the vehicles are spawned on this route
_startDirs =
[
	markerDir "LandConvoy_1_1",
	markerDir "LandConvoy_1_2",
	markerDir "LandConvoy_1_3"
];

// the route
_waypoints =
[
	[11753.6, 2205.20],
	[11022.9, 3874.63],
	[11028.1, 4994.69],
	[11476.3, 6228.67],
	[12756.8, 7204.79],
	[13985.9, 8128.20],
	[14369.2, 8857.41],
	[14554.2, 10434.1],
	[14295.5, 11457.8],
	[13785.6, 11802.2]
];

// to easily create waypoints, go in the editor, create player and preview scenario, place double-click markers in desired order on the map, and run this code:
// copyToClipboard str (allMapMarkers apply {markerPos _x select [0,2]})

// and there you go, positions in clipboard
