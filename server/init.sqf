//	@file Version: 1.1
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:

if (!isServer) exitWith {};

externalConfigFolder = "A3Wasteland_settings";

vChecksum = compileFinal format ["'%1'", call generateKey];

//Execute Server Side Scripts.
_serverCompiledScripts = [] execVM "server\antihack\setup.sqf";
waitUntil {scriptDone _serverCompiledScripts};
[] execVM "server\admins.sqf";
[] execVM "server\functions\serverVars.sqf";
_serverCompiledScripts = [] execVM "server\functions\serverCompile.sqf";
[] execVM "server\functions\broadcaster.sqf";
[] execVM "server\functions\relations.sqf";
[] execVM (externalConfigFolder + "\init.sqf");
waitUntil {scriptDone _serverCompiledScripts};

// Broadcast server rules
if (loadFile (externalConfigFolder + "\serverRules.sqf") != "") then
{
	[[[call compile preprocessFileLineNumbers (externalConfigFolder + "\serverRules.sqf")], "client\functions\defineServerRules.sqf"], "BIS_fnc_execVM", true, true] call TPG_fnc_MP;
};

diag_log "WASTELAND SERVER - Server Compile Finished";

"requestCompensateNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore };

// Default config
A3W_buildingLoot = 1;        // Spawn and respawn Loot inside buildings in citys (0 = no, 1 = yes)
A3W_startHour = 6;           // In-game hour at mission start (0 to 23)
A3W_moonLight = 1;           // Moon light during night (0 = no, 1 = yes)
A3W_missionsDifficulty = 0;  // Missions difficulty (0 = normal, 1 = hard)
A3W_serverMissions = 1;      // Server main & side missions (0 = no, 1 = yes)
A3W_serverSpawning = 1;      // Vehicle, object, and loot spawning (0 = no, 1 = yes)
A3W_boxSpawning = 1;         // If serverSpawning = 1, also spawn ammo boxes in some towns (0 = no, 1 = yes)
A3W_boatSpawning = 1;        // If serverSpawning = 1, also spawn boats at marked areas near coasts (0 = no, 1 = yes)
A3W_heliSpawning = 1;        // If serverSpawning = 1, also spawn helicopters in some towns and airfields (0 = no, 1 = yes)
A3W_planeSpawning = 1;       // If serverSpawning = 1, also spawn planes at some airfields (0 = no, 1 = yes)
A3W_baseBuilding = 1;        // If serverSpawning = 1, also spawn basebuilding parts in towns (0 = no, 1 = yes)
A3W_baseSaving = 0;          // Save base objects between restarts (0 = no, 1 = yes) - requires iniDB mod 
PDB_ServerID = "any";        // iniDB saves prefix (change this in case you run multiple servers from the same folder)

// load external config
if (loadFile (externalConfigFolder + "\main_config.sqf") != "") then
{
    call compile preprocessFileLineNumbers (externalConfigFolder + "\main_config.sqf");
}
else
{
	diag_log format["[WARNING] A3W configuration file '%1\main_config.sqf' was not found. Using default settings!", externalConfigFolder];
	diag_log "[WARNING] For more information go to http://a3wasteland.com/";
};

// Do we need any persistence?
if (["A3W_baseSaving", 0] call getPublicVar > 0 || {["config_player_saving_enabled", 0] call getPublicVar > 0}) then
{
	// Our custom iniDB methods which fixes some issues with the current iniDB addon release
	call compile preProcessFile "persistence\fn_inidb_custom.sqf";
	diag_log format["[INFO] A3W running with iniDB version %1", ([] call iniDB_version)];

	// Have we got player persistence enabled?
	if (["config_player_saving_enabled", 0] call getPublicVar > 0) then {
		diag_log "[INFO] A3W player saving is ENABLED";
		execVM "persistence\players\s_serverGather.sqf";

		if (["config_player_donations_enabled", 0] call getPublicVar > 0) then {
			diag_log "[INFO] A3W player donations are ENABLED. Players can spawn with additional money";
		} else {
			diag_log "[INFO] A3W player donations are DISABLED";
		};
	} else {
		diag_log "[INFO] A3W player saving is DISABLED";
	};

	// Have we got base saving enabled?
	if (["A3W_baseSaving", 0] call getPublicVar > 0) then
	{
		diag_log "[INFO] A3W base saving is ENABLED";
		execVM "persistence\world\init.sqf";
	} else {
		diag_log "[INFO] A3W base saving is DISABLED";
	};
};

if (!isNil "A3W_startHour" || !isNil "A3W_moonLight") then
{
	private ["_monthDay", "_startHour"];
	_monthDay = if (["A3W_moonLight", 0] call getPublicVar > 0) then { 10 } else { 25 };
	_startHour = ["A3W_startHour", date select 2] call getPublicVar;
	setDate [2035, 6, _monthDay, _startHour, 0];
};

if (["A3W_buildingLoot", 0] call getPublicVar > 0) then 
{
	diag_log "[INFO] A3W loot spawning is ENABLED";
	execVM "server\spawning\lootCreation.sqf";
};

[] execVM "server\functions\serverTimeSync.sqf";

if (["A3W_serverSpawning", 0] call getPublicVar > 0) then
{
    diag_log "WASTELAND SERVER - Initializing Server Spawning";
	
	if (["A3W_heliSpawning", 0] call getPublicVar > 0) then
	{
		_heliSpawn = [] execVM "server\functions\staticHeliSpawning.sqf";
		waitUntil {sleep 0.1; scriptDone _heliSpawn};
	};
	
	_vehSpawn = [] execVM "server\functions\vehicleSpawning.sqf";
	waitUntil {sleep 0.1; scriptDone _vehSpawn};
	
	if (["A3W_planeSpawning", 0] call getPublicVar > 0) then
	{
		_planeSpawn = [] execVM "server\functions\planeSpawning.sqf";
		waitUntil {sleep 0.1; scriptDone _planeSpawn};
	};
	
	if (["A3W_boatSpawning", 0] call getPublicVar > 0) then
	{
		_boatSpawn = [] execVM "server\functions\boatSpawning.sqf";
		waitUntil {sleep 0.1; scriptDone _boatSpawn};
	};
	
	if (["A3W_baseBuilding", 0] call getPublicVar > 0) then
	{
		_objSpawn = [] execVM "server\functions\objectsSpawning.sqf";
		waitUntil {sleep 0.1; scriptDone _objSpawn};
	};
	
	if (["A3W_boxSpawning", 0] call getPublicVar > 0) then
	{
		_boxSpawn = [] execVM "server\functions\boxSpawning.sqf";
		waitUntil {sleep 0.1; scriptDone _boxSpawn};
	};
};

// Hooks for new players connecting, in case we need to manually update state
onPlayerConnected "[_id, _name] execVM 'server\functions\onPlayerConnected.sqf'";

if (count (["config_territory_markers", []] call getPublicVar) > 0) then
{
	diag_log "[INFO] A3W territory capturing is ENABLED";
	[] ExecVM "territory\server\monitorTerritories.sqf";
};

//Execute Server Missions.
if (["A3W_serverMissions", 0] call getPublicVar > 0) then
{
	diag_log "WASTELAND SERVER - Initializing Missions";
    [] execVM "server\missions\sideMissionController.sqf";
    sleep 5;
    [] execVM "server\missions\mainMissionController.sqf";
	sleep 5;
	[] execVM "server\missions\moneyMissionController.sqf";
};

// Start clean-up loop
[] execVM "server\WastelandServClean.sqf";
