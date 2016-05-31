// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: CfgFunctions.hpp
//	@file Author: AgentRev

class ClientDir
{
	class preInit {preInit = 1; file = "client\preInit.sqf";};
	//class postInit {postInit = 1; file = "client\postInit.sqf";};

	class fixUniVestBug {postInit = 1; file = "client\functions\fn_fixUniVestBug.sqf";};
	class getTeamMarkerColor {file = "territory\client\getTeamMarkerColor.sqf";};
	class setSpawnTimestamps {file = "client\functions\fn_setSpawnTimestamps.sqf";};
	class updateTerritoryMarkers {file = "territory\client\updateTerritoryMarkers.sqf";};

	class markerLogEntry {file = "client\functions\fn_markerLogEntry.sqf";};
	class markerLogEvent {file = "client\functions\fn_markerLogEvent.sqf";};
	class markerLogInsert {file = "client\functions\fn_markerLogInsert.sqf";};
	class markerLogParams {file = "client\functions\fn_markerLogParams.sqf";};
	class markerLogPvar {file = "client\functions\fn_markerLogPvar.sqf";};
	class markerLogInit {preInit = 1; file = "client\functions\fn_markerLogInit.sqf";};
};
