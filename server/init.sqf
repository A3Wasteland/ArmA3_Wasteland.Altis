//	@file Version: 1.1
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:

if(!X_Server) exitWith {};

A3W_sideMissions = 1;
A3W_serverSpawning = 1;

vChecksum = compileFinal format ["'%1'", call generateKey];

//Execute Server Side Scripts.
[] execVM "server\antihack\setup.sqf";
[] execVM "server\admins.sqf";
[] execVM "server\functions\serverVars.sqf";
_serverCompiledScripts = [] execVM "server\functions\serverCompile.sqf";
[] execVM "server\functions\broadcaster.sqf";
[] execVM "server\functions\relations.sqf";
[] execVM "server\functions\serverTimeSync.sqf";
waitUntil{scriptDone _serverCompiledScripts};

diag_log format["A3W SERVER - Server compile finished"];
"requestCompensateNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore }; 

// load external config
if (loadFile "A3W_Wasteland-config.sqf" != "") then
{
    call compile preprocessFileLineNumbers "A3W_Wasteland-config.sqf";
} else {
		diag_log "[WARNING] A3W configuration file 'A3W_Wasteland-config.sqf' was not found. Using default settings!";
		diag_log "[WARNING] For more information go to http://a3wasteland.com/";
		A3W_buildingLoot = 1;	// loot inside buildings 1-yes 0-no
		A3W_nightTime = 0;		// server starts at 19:00
		A3W_baseSaving = 1;		// requires @inidb mod
		PDB_ServerID = "any";
		Mission_Diff = 0;		// 0-normal  1-hard
};

// Do we need any persistence?
if ((!isNil "A3W_baseSaving" && {A3W_baseSaving > 0} || (call config_player_saving_enabled) == 1)) then {
	// Our custom iniDB methods which fixes some issues with the current iniDB addon release
	call compile preProcessFile "persistence\fn_inidb_custom.sqf";
	diag_log format["[INFO] A3W running with iniDB version %1", ([] call iniDB_version)];

	// Have we got player persistence enabled?
	if ((call config_player_saving_enabled) == 1) then {
		diag_log "[INFO] A3W player saving is ENABLED";
		execVM "persistence\players\s_serverGather.sqf";

		if ((call config_player_donations_enabled) == 1) then {
			diag_log "[INFO] A3W player donations are ENABLED. Players can spawn with additional money";
		} else {
			diag_log "[INFO] A3W player donations are DISABLED";
		};

	} else {
		diag_log "[INFO] A3W player saving is DISABLED";
	};

	// Have we got base saving enabled?
	if (!isNil "A3W_baseSaving" && {A3W_baseSaving > 0}) then
	{
		diag_log "[INFO] A3W base saving is ENABLED";
		execVM "persistence\world\init.sqf";
	} else {
		diag_log "[INFO] A3W base saving is DISABLED";
	};
};

if (!isNil "A3W_nightTime" && {A3W_nightTime > 0}) then
{
    setDate [date select 0, date select 1, date select 2, 21, 0];
};

if (!isNil "A3W_buildingLoot" && {A3W_buildingLoot > 0}) then 
{
	diag_log "[INFO] A3W loot spawning is ENABLED";
	execVM "server\spawning\lootCreation.sqf";
};

if (A3W_serverSpawning == 1) then {
    diag_log format["WASTELAND SERVER - Initializing Server Spawning"];
	_vehSpawn = [] ExecVM "server\functions\vehicleSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _vehSpawn};
    _objSpawn = [] ExecVM "server\functions\objectsSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _objSpawn};
    _heliSpawn = [] ExecVM "server\functions\staticHeliSpawning.sqf";
    waitUntil{sleep 0.1; scriptDone _heliSpawn};
    _boatSpawn = [] ExecVM "server\functions\BoatSpawning.sqf";
    waitUntil{sleep 0.1; scriptDone _boatSpawn};
};

//Execute Server Missions.
if (A3W_sideMissions == 1) then {
	diag_log format["WASTELAND SERVER - Initializing Missions"];
    [] execVM "server\missions\sideMissionController.sqf";
    sleep 5;
    [] execVM "server\missions\mainMissionController.sqf";
};

if (isDedicated) then {
	_id = [] execVM "server\WastelandServClean.sqf";
};
