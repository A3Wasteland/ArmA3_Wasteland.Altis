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
[] execVM "server\functions\serverTimeSync.sqf";
[] execVM (externalConfigFolder + "\init.sqf");
waitUntil {scriptDone _serverCompiledScripts};

diag_log "WASTELAND SERVER - Server Compile Finished";

"requestCompensateNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore };

// Default config
A3W_buildingLoot = 0;		// Loot inside buildings (0 = no, 1 = yes)
A3W_startHour = 6;			// In-game hour at mission start (0 to 23)
A3W_moonLight = 1;			// Moon light during night (0 = no, 1 = yes)
A3W_baseSaving = 0;			// Save base objects between restarts (0 = no, 1 = yes) - requires iniDB mod 
A3W_missionsDifficulty = 0;	// Missions difficulty (0 = normal, 1 = hard)
A3W_sideMissions = 0;      // Side missions (0 = no, 1 = yes)
A3W_serverSpawning = 0;     // Vehicle, object, and loot spawning (0 = no, 1 = yes)0
A3W_boxSpawning = 0;		// if spawning is enabled, also spawn ammo boxes arround the map (0 = no, 1 = yes)
A3W_boatSpawning = 0;		// if spawning is enabled, also spawn boats near marked areas at coasts (0 = no, 1 = yes)
A3W_baseBuilding = 0;		// if spawning is enabled, also spawn basebuilding parts arround the map (0 = no, 1 = yes)
PDB_ServerID = "any";       // iniDB savefile prefix (change per server incase you run multiple servers from the same folder)

// load external config
if (loadFile (externalConfigFolder + "\main_config.sqf") != "") then
{
    call compile preprocessFileLineNumbers (externalConfigFolder + "\main_config.sqf");
}
else
{
	diag_log "[WARNING] A3W configuration file '" + externalConfigFolder + "\main_config.sqf' was not found. Using default settings!";
	diag_log "[WARNING] For more information go to http://a3wasteland.com/";
};

// Do we need any persistence?
if (["A3W_baseSaving", 0] call getPublicVar > 0 || {call config_player_saving_enabled == 1}) then
{
	// Our custom iniDB methods which fixes some issues with the current iniDB addon release
	call compile preProcessFile "persistence\fn_inidb_custom.sqf";
	diag_log format["[INFO] A3W running with iniDB version %1", ([] call iniDB_version)];

	// Have we got player persistence enabled?
	if (call config_player_saving_enabled == 1) then {
		diag_log "[INFO] A3W player saving is ENABLED";
		execVM "persistence\players\s_serverGather.sqf";

		if (call config_player_donations_enabled == 1) then {
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
	setDate [date select 0, date select 1, _monthDay, _startHour, 0];
};

if (["A3W_buildingLoot", 0] call getPublicVar > 0) then 
{
	diag_log "[INFO] A3W loot spawning is ENABLED";
	execVM "server\spawning\lootCreation.sqf";
};

if (A3W_serverSpawning == 1) then {
    diag_log "WASTELAND SERVER - Initializing Server Spawning";
	_vehSpawn = [] ExecVM "server\functions\vehicleSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _vehSpawn};
	if (A3W_baseBuilding == 1) then {
		_objSpawn = [] ExecVM "server\functions\objectsSpawning.sqf";
		waitUntil{sleep 0.1; scriptDone _objSpawn};
	};
	if (A3W_boxSpawning == 1) then {
		_boxSpawn = [] ExecVM "server\functions\boxSpawning.sqf";
		waitUntil{sleep 0.1; scriptDone _boxSpawn};
	};
    _heliSpawn = [] ExecVM "server\functions\staticHeliSpawning.sqf";
    waitUntil{sleep 0.1; scriptDone _heliSpawn};
	if (A3W_boatSpawning == 1) then {
		_boatSpawn = [] ExecVM "server\functions\BoatSpawning.sqf";
		waitUntil{sleep 0.1; scriptDone _boatSpawn};
	};
};

// Set up our store owner dudes
[] execVM "server\functions\initStoreOwners.sqf";

// Hooks for new players connecting, in case we need to manually update state
onPlayerConnected "[_id, _name] execVM ""server\functions\onPlayerConnected.sqf""";

if (count (call config_territory_markers) > 0) then {
	diag_log "[INFO] A3W territory capturing is ENABLED";
	[] ExecVM "territory\server\monitorTerritories.sqf";
};

//Execute Server Missions.
if (A3W_sideMissions == 1) then {
	diag_log "WASTELAND SERVER - Initializing Missions";
    [] execVM "server\missions\sideMissionController.sqf";
    sleep 5;
    [] execVM "server\missions\mainMissionController.sqf";
};

// Start clean-up loop
[] execVM "server\WastelandServClean.sqf";
