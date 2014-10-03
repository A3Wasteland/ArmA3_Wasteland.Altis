//	@file Version: 1.1
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:

if (!isServer) exitWith {};

externalConfigFolder = "\A3Wasteland_settings";

vChecksum = compileFinal format ["'%1'", call generateKey];

//Execute Server Side Scripts.
call compile preprocessFileLineNumbers "server\antihack\setup.sqf";
[] execVM "server\admins.sqf";
[] execVM "server\functions\serverVars.sqf";
_serverCompileHandle = [] spawn compile preprocessFileLineNumbers "server\functions\serverCompile.sqf"; // For some reason, scriptDone stays stuck on false on Linux servers when using execVM for this line...
[] execVM "server\functions\broadcaster.sqf";
[] execVM "server\functions\relations.sqf";
[] execVM (externalConfigFolder + "\init.sqf");

waitUntil {scriptDone _serverCompileHandle};

// Broadcast server rules
if (loadFile (externalConfigFolder + "\serverRules.sqf") != "") then
{
	[[[call compile preprocessFileLineNumbers (externalConfigFolder + "\serverRules.sqf")], "client\functions\defineServerRules.sqf"], "BIS_fnc_execVM", true, true] call TPG_fnc_MP;
};

diag_log "WASTELAND SERVER - Server Compile Finished";

"requestCompensateNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore };

// load default config
call compile preprocessFileLineNumbers "server\default_config.sqf";

// load external config
if (loadFile (externalConfigFolder + "\main_config.sqf") != "") then
{
	call compile preprocessFileLineNumbers (externalConfigFolder + "\main_config.sqf");
}
else
{
	diag_log format["[WARNING] A3W configuration file '%1\main_config.sqf' was not found. Using default settings!", externalConfigFolder];
	diag_log "[WARNING] For more information go to http://forums.a3wasteland.com/";
};

A3W_startingMoney = compileFinal str A3W_startingMoney;
A3W_showGunStoreStatus = compileFinal str A3W_showGunStoreStatus;
A3W_gunStoreIntruderWarning = compileFinal str A3W_gunStoreIntruderWarning;
A3W_playerSaving = compileFinal str A3W_playerSaving;
A3W_combatAbortDelay = compileFinal str A3W_combatAbortDelay;
A3W_unlimitedStamina = compileFinal str A3W_unlimitedStamina;
A3W_bleedingTime = compileFinal str A3W_bleedingTime;
A3W_teamPlayersMap = compileFinal str A3W_teamPlayersMap;
A3W_remoteBombStoreRadius = compileFinal str A3W_remoteBombStoreRadius;

// Broadcast config variables
publicVariable "A3W_startingMoney";
publicVariable "A3W_showGunStoreStatus";
publicVariable "A3W_gunStoreIntruderWarning";
publicVariable "A3W_playerSaving";
publicVariable "A3W_combatAbortDelay";
publicVariable "A3W_unlimitedStamina";
publicVariable "A3W_bleedingTime";
publicVariable "A3W_teamPlayersMap";
publicVariable "A3W_remoteBombStoreRadius";

_playerSavingOn = ["A3W_playerSaving"] call isConfigOn;
_baseSavingOn = ["A3W_baseSaving"] call isConfigOn;
_boxSavingOn = ["A3W_boxSaving"] call isConfigOn;
_staticWeaponSavingOn = ["A3W_staticWeaponSaving"] call isConfigOn;
_warchestSavingOn = ["A3W_warchestSaving"] call isConfigOn;
_warchestMoneySavingOn = ["A3W_warchestMoneySaving"] call isConfigOn;
_beaconSavingOn = ["A3W_spawnBeaconSaving"] call isConfigOn;

_serverSavingOn = (_baseSavingOn || _boxSavingOn || _staticWeaponSavingOn || _warchestSavingOn || _warchestMoneySavingOn || _beaconSavingOn);

_setupPlayerDB = [] spawn {}; // blank script to feed scriptDone a non-nil value

// Do we need any persistence?
if (_playerSavingOn || _serverSavingOn) then
{
	_verIniDB = "iniDB" callExtension "version";

	if (_verIniDB == "") then
	{
		A3W_savingMethod = compileFinal "1";
		A3W_savingMethodName = compileFinal "'profileNamespace'";

		diag_log "[INFO] ### A3W NOT running with iniDB!";
		diag_log format ["[INFO] ### Saving method = %1", call A3W_savingMethodName];
	}
	else
	{
		A3W_savingMethod = compileFinal "2";

		if (parseNumber _verIniDB > 1) then
		{
			A3W_savingMethodName = compileFinal "'iniDBI'";
		}
		else
		{
			A3W_savingMethodName = compileFinal "'iniDB'";
		};

		diag_log format ["[INFO] ### A3W running with %1 v%2", call A3W_savingMethodName, _verIniDB];
	};

	call compile preProcessFileLineNumbers "persistence\fn_inidb_custom.sqf";

	diag_log format ["[INFO] ### Saving method = %1", call A3W_savingMethodName];

	// Have we got player persistence enabled?
	if (_playerSavingOn) then
	{
		_setupPlayerDB = [] spawn compile preprocessFileLineNumbers "persistence\players\s_setupPlayerDB.sqf"; // For some reason, scriptDone stays stuck on false on Linux servers when using execVM for this line...
	};

	[_serverSavingOn, _playerSavingOn] spawn
	{
		_serverSavingOn = _this select 0;
		_playerSavingOn = _this select 1;

		if (_serverSavingOn) then
		{
			call compile preprocessFileLineNumbers "persistence\world\oLoad.sqf";
		};

		if (_serverSavingOn || (_playerSavingOn && ["A3W_savingMethod", 1] call getPublicVar == 1)) then
		{
			execVM "persistence\world\oSave.sqf";
		};
	};

	{
		diag_log format ["[INFO] A3W %1 = %2", _x select 0, if (_x select 1) then { "ON" } else { "OFF" }];
	}
	forEach
	[
		["playerSaving", _playerSavingOn],
		["baseSaving", _baseSavingOn],
		["boxSaving", _boxSavingOn],
		["staticWeaponSaving", _staticWeaponSavingOn],
		["warchestSaving", _warchestSavingOn],
		["warchestMoneySaving", _warchestMoneySavingOn],
		["spawnBeaconSaving", _beaconSavingOn]
	];
};

call compile preprocessFileLineNumbers "server\functions\createTownMarkers.sqf";

_createTriggers = [] spawn compile preprocessFileLineNumbers "territory\server\createCaptureTriggers.sqf"; // For some reason, scriptDone stays stuck on false on Linux servers when using execVM for this line...

[_setupPlayerDB, _createTriggers] spawn
{
	waitUntil {sleep 0.1; {scriptDone _x} count _this == count _this};
	A3W_serverSetupComplete = compileFinal "true";
	publicVariable "A3W_serverSetupComplete";
};

if (!isNil "A3W_startHour" || !isNil "A3W_moonLight") then
{
	private ["_monthDay", "_startHour"];
	_monthDay = if (["A3W_moonLight"] call isConfigOn) then { 9 } else { 24 };
	_startHour = ["A3W_startHour", date select 2] call getPublicVar;
	setDate [2035, 6, _monthDay, _startHour, 0];
};

if ((isNil "A3W_buildingLoot" && {["A3W_buildingLootWeapons"] call isConfigOn || {["A3W_buildingLootSupplies"] call isConfigOn}}) || {["A3W_buildingLoot"] call isConfigOn}) then
{
	diag_log "[INFO] A3W loot spawning is ENABLED";
	execVM "addons\Lootspawner\Lootspawner.sqf";
};

[] execVM "server\functions\serverTimeSync.sqf";

if (["A3W_serverSpawning"] call isConfigOn) then
{
	diag_log "WASTELAND SERVER - Initializing Server Spawning";

	if (["A3W_heliSpawning"] call isConfigOn) then
	{
		call compile preprocessFileLineNumbers "server\functions\staticHeliSpawning.sqf";
	};

	if (["A3W_vehicleSpawning"] call isConfigOn) then
	{
		call compile preprocessFileLineNumbers "server\functions\vehicleSpawning.sqf";
	};

	if (["A3W_planeSpawning"] call isConfigOn) then
	{
		call compile preprocessFileLineNumbers "server\functions\planeSpawning.sqf";
	};

	if (["A3W_boatSpawning"] call isConfigOn) then
	{
		call compile preprocessFileLineNumbers "server\functions\boatSpawning.sqf";
	};

	if (["A3W_baseBuilding"] call isConfigOn) then
	{
		call compile preprocessFileLineNumbers "server\functions\objectsSpawning.sqf";
	};

	if (["A3W_boxSpawning"] call isConfigOn) then
	{
		call compile preprocessFileLineNumbers "server\functions\boxSpawning.sqf";
	};
};

["A3W_quit", "onPlayerDisconnected", { [_id, _uid, _name] spawn fn_onPlayerDisconnected }] call BIS_fnc_addStackedEventHandler;

if (count (["config_territory_markers", []] call getPublicVar) > 0) then
{
	diag_log "[INFO] A3W territory capturing is ENABLED";
	[] execVM "territory\server\monitorTerritories.sqf";
}
else
{
	diag_log "[INFO] A3W territory capturing is DISABLED";
};

//Execute Server Missions.
if (["A3W_serverMissions"] call isConfigOn) then
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
