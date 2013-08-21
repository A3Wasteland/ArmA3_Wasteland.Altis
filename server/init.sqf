//	@file Version: 1.1
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:
#include "setup.sqf"
if(!X_Server) exitWith {};

sideMissions = 1;
serverSpawning = 1;

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


diag_log format["WASTELAND SERVER - Server Compile Finished"];
"requestCompensateNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore }; 

// load external config
if (loadFile "GoT_Wasteland-config.sqf" != "") then
{
    call compile preprocessFileLineNumbers "GoT_Wasteland-config.sqf";
} else {
		diag_log "[ERROR] GoT Wasteland v2.3 configuration could not be loaded";
		diag_log "[ERROR] GoT Wasteland v2.3 requires additional files";
		diag_log "[ERROR] You can download the full package on: www.got2dayz.nl";
		diag_log "[INFO] Setting default settings due to lack of config-file";
		GoT_buildingsloot = 1;
		GoT_nightTime = 0;
		GoT_baseSaving = 0;
		PDB_ServerID = "any";
};

if (!isNil "GoT_nightTime" && {GoT_nightTime > 0}) then
{
    setDate [date select 0, date select 1, date select 2, 21, 0];
};

if (!isNil "GoT_baseSaving" && {GoT_baseSaving > 0}) then
{
    diag_log "[GoT Wasteland - Initializing base-saving]";
    execVM "persistentscripts\init.sqf";
};

if (!isNil "GoT_buildingsloot" && {GoT_buildingsloot > 0}) then 
{
	diag_log format["GOT WASTELAND - Lootspawner started"];
	execVM "server\spawning\lootCreation.sqf";
};

if (serverSpawning == 1) then {
    diag_log format["WASTELAND SERVER - Initializing Server Spawning"];
	_vehSpawn = [] ExecVM "server\functions\vehicleSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _vehSpawn};
    _objSpawn = [] ExecVM "server\functions\objectsSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _objSpawn};
    _objSpawn2 = [] ExecVM "server\functions\objectsSpawning2.sqf";
	waitUntil{sleep 0.1; scriptDone _objSpawn2};
    _heliSpawn = [] ExecVM "server\functions\staticHeliSpawning.sqf";
    waitUntil{sleep 0.1; scriptDone _heliSpawn};
    _boatSpawn = [] ExecVM "server\functions\BoatSpawning.sqf";
    waitUntil{sleep 0.1; scriptDone _boatSpawn};
};

//Execute Server Missions.
if (sideMissions == 1) then {
	diag_log format["WASTELAND SERVER - Initializing Missions"];
    [] execVM "server\missions\sideMissionController.sqf";
    sleep 5;
    [] execVM "server\missions\mainMissionController.sqf";
};

if (isDedicated) then {
	_id = [] execVM "server\WastelandServClean.sqf";
};
