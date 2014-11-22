// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:

if (!isServer) exitWith {};

externalConfigFolder = "\A3Wasteland_settings";

vChecksum = compileFinal str call A3W_fnc_generateKey;

// Corpse deletion on disconnect if player alive and player saving on
addMissionEventHandler ["HandleDisconnect",
{
	if (isNil "isConfigOn" || {["A3W_playerSaving"] call isConfigOn}) then
	{
		_unit = _this select 0;
		if (alive _unit) then { deleteVehicle _unit };
	};
}];

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
	[[[call compile preprocessFileLineNumbers (externalConfigFolder + "\serverRules.sqf")], "client\functions\defineServerRules.sqf"], "BIS_fnc_execVM", true, true] call A3W_fnc_MP;
};

diag_log "WASTELAND SERVER - Server Compile Finished";

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

// compileFinal & broadcast client config variables
{
	missionNamespace setVariable [_x, compileFinal str (missionNamespace getVariable _x)];
	publicVariable _x;
}
forEach
[
	"A3W_startingMoney",
	"A3W_showGunStoreStatus",
	"A3W_gunStoreIntruderWarning",
	"A3W_playerSaving",
	"A3W_combatAbortDelay",
	"A3W_unlimitedStamina",
	"A3W_bleedingTime",
	"A3W_teamPlayersMap",
	"A3W_remoteBombStoreRadius",
	"A3W_vehiclePurchaseCooldown",
	"A3W_globalVoiceWarnTimer",
	"A3W_globalVoiceMaxWarns",
	"A3W_antiHackMinRecoil",
	"A3W_spawnBeaconCooldown",
	"A3W_spawnBeaconSpawnHeight",
	"A3W_extDB_ServerID",
	"A3W_extDB_PlayerSave_ServerID",
	"A3W_extension",
	"A3W_vehicleThermals",
	"A3W_firstPersonCamOnFoot",
	"A3W_firstPersonCamNotDriver",
	"A3W_resupplyCostPR",
	"A3W_serverNumber"
];


_playerSavingOn = ["A3W_playerSaving"] call isConfigOn;
_baseSavingOn = ["A3W_baseSaving"] call isConfigOn;
_boxSavingOn = ["A3W_boxSaving"] call isConfigOn;
_staticWeaponSavingOn = ["A3W_staticWeaponSaving"] call isConfigOn;
_warchestSavingOn = ["A3W_warchestSaving"] call isConfigOn;
_warchestMoneySavingOn = ["A3W_warchestMoneySaving"] call isConfigOn;
_beaconSavingOn = ["A3W_spawnBeaconSaving"] call isConfigOn;
vehicleThermalsOn = ["A3W_vehicleThermals"] call isConfigOn;

_purchasedVehicleSavingOn = ["A3W_purchasedVehicleSaving"] call isConfigOn;
_missionVehicleSavingOn = ["A3W_missionVehicleSaving"] call isConfigOn;

_serverSavingOn = (_baseSavingOn || _boxSavingOn || _staticWeaponSavingOn || _warchestSavingOn || _warchestMoneySavingOn || _beaconSavingOn || _purchasedVehicleSavingOn || _missionVehicleSavingOn);
_vehicleSavingOn = (_purchasedVehicleSavingOn || _purchasedVehicleSavingOn);

_setupPlayerDB = scriptNull;

// Do we need any persistence?

if (_playerSavingOn || _serverSavingOn) then
{
	_persistence = "default";

	switch (call A3W_extension) do {
		case "iniDB": {  // iniDB
					_result = "iniDB" callExtension "version";
					if (_result == "") exitWith
					{
					// Fall Back to ProfileNameSpace
						A3W_savingMethod = compileFinal "1";
						A3W_savingMethodName = compileFinal "'profileNamespace'";
						diag_log "[INFO] ### A3W NOT running with iniDB!";
						diag_log format ["[INFO] ### Saving method = %1", call A3W_savingMethodName];
						call compile preProcessFileLineNumbers format["persistence\server\%1\init.sqf", _persistence];
					};

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
					call compile preProcessFileLineNumbers format["persistence\server\%1\init.sqf", _persistence];
				};
		case "extDB": {  // extDB
					_result = "extDB" callExtension "9:VERSION";
					if (parseNumber _result < 19) exitWith
					{
						// Fall Back to ProfileNameSpace
						A3W_savingMethod = compileFinal "1";
						diag_log "[INFO] ### A3W NOT running with extDB!";
						if (_result != "") then {diag_log format["[INFO] ### A3W Requires extDB v19 or later: extDB v%1 Detected", _result];};

						A3W_savingMethodName = compileFinal "'profileNamespace'";
						diag_log format ["[INFO] ### Saving method = %1", call A3W_savingMethodName];
					};

					_persistence = "extDB";
					_result = [] call compile preProcessFileLineNumbers format["persistence\server\%1\init.sqf", _persistence];

					if (_result) then {
						A3W_savingMethod = compileFinal "3";
						A3W_savingMethodName = compileFinal "'extDB'";
					}
					else
					{
						_persistence = "default";
						diag_log "[INFO] ### A3W extDB failed to start!";
						A3W_savingMethod = compileFinal "1";
						A3W_savingMethodName = compileFinal "'profileNamespace'";
						diag_log format ["[INFO] ### Saving method = %1", call A3W_savingMethodName];
						call compile preProcessFileLineNumbers format["persistence\server\%1\init.sqf", _persistence];
					};
				};
		default {  // Profile Space
					A3W_savingMethod = compileFinal "1";
					A3W_savingMethodName = compileFinal "'profileNamespace'";
					diag_log format ["[INFO] ### Saving method = %1", call A3W_savingMethodName];
					call compile preProcessFileLineNumbers format["persistence\server\%1\init.sqf", _persistence];
				};
	};


	// Have we got player persistence enabled?
	if (_playerSavingOn) then
	{
		_setupPlayerDB = [_persistence] spawn compile preprocessFileLineNumbers format["persistence\server\%1\players\setupPlayerDB.sqf", _persistence]; // For some reason, scriptDone stays stuck on false on Linux servers when using execVM for this line...
	};

	[_serverSavingOn, _playerSavingOn, _vehicleSavingOn, _purchasedVehicleSavingOn, _missionVehicleSavingOn, _persistence] spawn
	{
		_serverSavingOn = _this select 0;
		_playerSavingOn = _this select 1;
		_vehicleSavingOn = _this select 2;
		_purchasedVehicleSavingOn = _this select 3;
		_missionVehicleSavingOn = _this select 4;
		_persistence = _this select 5;
		_serverObjectsIDs = [];
		_serverVehiclesIDs = [];

		if (_serverSavingOn) then
		{
			_serverObjectsIDs = [] call compile preprocessFileLineNumbers format["persistence\server\%1\world\oLoad.sqf", _persistence];
		};
		if (_vehicleSavingOn) then
		{
			_serverVehiclesIDs = [] call compile preprocessFileLineNumbers format["persistence\server\%1\world\vLoad.sqf", _persistence];
		};
		
		if ((_serverSavingOn && _vehicleSavingOn) || (_playerSavingOn && _vehicleSavingOn && ["A3W_savingMethod", 1] call getPublicVar == 1)) then
		{
			[_serverObjectsIDs, _serverVehiclesIDs, _purchasedVehicleSavingOn, _missionVehicleSavingOn] execVM format["persistence\server\%1\world\oSave.sqf", _persistence];
		};
		
		/*if (_serverSavingOn || (_playerSavingOn && ["A3W_savingMethod", 1] call getPublicVar == 1)) then
		{
			[_serverObjectsIDs] execVM format["persistence\server\%1\world\oSave.sqf", _persistence];
		}; */
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

call compile preprocessFileLineNumbers "server\missions\setupMissionArrays.sqf";
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

	if (["A3W_baseBuilding"] call isConfigOn || ["A3W_essentialsSpawning"] call isConfigOn) then
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

// Consolidate all store NPCs in a single group
[] spawn
{
	_storeGroup = createGroup sideLogic;
	{
		if (!isPlayer _x && {[["GenStore","GunStore","VehStore"], vehicleVarName _x] call fn_startsWith}) then
		{
			[_x] joinSilent _storeGroup;
		};
	} forEach entities "CAManBase";
};

//Execute Server Missions.
if (["A3W_serverMissions"] call isConfigOn) then
{
	diag_log "WASTELAND SERVER - Initializing Missions";
	[] execVM "server\missions\masterController.sqf";
};

// Start clean-up loop
[] execVM "server\WastelandServClean.sqf";
