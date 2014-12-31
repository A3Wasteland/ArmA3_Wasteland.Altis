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

// Corpse deletion on disconnect if player alive and player saving on + inventory save
addMissionEventHandler ["HandleDisconnect",
{
	_unit = _this select 0;
	_id = _this select 1;
	_uid = _this select 2;
	_name = _this select 3;

	if (alive _unit && (_unit getVariable ["FAR_isUnconscious", 0] == 0) && {!isNil "isConfigOn" && {["A3W_playerSaving"] call isConfigOn}}) then
	{
		if (!(_unit getVariable ["playerSpawning", false]) && typeOf _unit != "HeadlessClient_F") then
		{
			[_uid, [], [_unit, false] call fn_getPlayerData] spawn fn_saveAccount;
		};

		deleteVehicle _unit;
	};

	if (!isNil "fn_onPlayerDisconnected") then
	{
		[_id, _uid, _name] spawn fn_onPlayerDisconnected;
	};

	false
}];

//Execute Server Side Scripts.
call compile preprocessFileLineNumbers "server\antihack\setup.sqf";
[] execVM "server\admins.sqf";
[] execVM "server\functions\serverVars.sqf";
_serverCompileHandle = [] spawn compile preprocessFileLineNumbers "server\functions\serverCompile.sqf"; // scriptDone stays stuck on false when using execVM on Linux
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
	"A3W_purchasedVehicleSaving",
	"A3W_missionVehicleSaving",
	"A3W_missionFarAiDrawLines",
	"A3W_extDB_ServerID",
	"A3W_extDB_PlayerSave_ServerID",
	"A3W_extension",
	"A3W_vehicleThermals",
	"A3W_firstPersonCamOnFoot",
	"A3W_firstPersonCamNotDriver",
	"A3W_resupplyCostPR",
	"A3W_territoryAllowed"
];

["A3W_join", "onPlayerConnected", { [_id, _uid, _name] spawn fn_onPlayerConnected }] call BIS_fnc_addStackedEventHandler;

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
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	_savingMethod = ["A3W_savingMethod", "profile"] call getPublicVar;
	if (_savingMethod == "iniDBI") then { _savingMethod = "iniDB" };

	// extDB
	if (_savingMethod == "extDB") then
	{
		_version = "extDB" callExtension "9:VERSION";

		if (parseNumber _version >= 20) then
		{
			A3W_savingMethodName = compileFinal "'extDB'";
			A3W_savingMethodDir = compileFinal "'extDB'";
			A3W_extDB_ConfigName = compileFinal str (["A3W_extDB_ConfigName", "A3W"] call getPublicVar);
			A3W_extDB_IniName = compileFinal str (["A3W_extDB_IniName", "a3wasteland"] call getPublicVar);
		}
		else
		{
			if (_version != "") then
			{
				diag_log format "[INFO] ### extDB startup cancelled!";
				diag_log format ["[INFO] ### A3W requires extDB v20 or later: v%1 detected", _result];
			}
			else
			{
				diag_log "[INFO] ### A3W NOT running with extDB!";
			};

			_savingMethod = "profile"; // fallback
		};
	};

	// iniDB
	if (_savingMethod == "iniDB") then
	{
		_verIniDB = "iniDB" callExtension "version";

		if (_verIniDB != "") then
		{
			A3W_savingMethodName = compileFinal (if (parseNumber _verIniDB > 1) then { "'iniDBI'" } else { "'iniDB'" });
			A3W_savingMethodDir = compileFinal "'default'";
			diag_log format ["[INFO] ### A3W running with %1 v%2", call A3W_savingMethodName, _verIniDB];
		}
		else
		{
			diag_log "[INFO] ### A3W NOT running with iniDB!";
			_savingMethod = "profile"; // fallback
		};
	};

	if (_savingMethod == "profileNamespace") then { _savingMethod = "profile" };

	// profileNamespace
	if (_savingMethod == "profile") then
	{
		A3W_savingMethodName = compileFinal "'profileNamespace'";
		A3W_savingMethodDir = compileFinal "'default'";
		diag_log format ["[INFO] ### Saving method = %1", call A3W_savingMethodName];
	};

	A3W_savingMethod = compileFinal str _savingMethod;
	publicVariable "A3W_savingMethod";

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	call compile preProcessFileLineNumbers format ["persistence\server\setup\%1\init.sqf", call A3W_savingMethodDir];

	if (_playerSavingOn) then
	{
		_setupPlayerDB = [] spawn compile preprocessFileLineNumbers "persistence\server\players\setupPlayerDB.sqf"; // scriptDone stays stuck on false on Linux servers when using execVM

		// profileNamespace doesn't save antihack logs
		if (_savingMethod != "profile") then
		{
			_setupPlayerDB spawn
			{
				waitUntil {scriptDone _this};

				["A3W_flagCheckOnJoin", "onPlayerConnected", { [_uid, _name] spawn fn_kickPlayerIfFlagged }] call BIS_fnc_addStackedEventHandler;

				{ [getPlayerUID _x, name _x] call fn_kickPlayerIfFlagged } forEach (call allPlayers);
			};
		};
	};

	[_playerSavingOn, _serverSavingOn, _vehicleSavingOn] spawn
	{
		_playerSavingOn = _this select 0;
		_serverSavingOn = _this select 1;
		_vehicleSavingOn = _this select 2;

		_objectIDs = [];
		_vehicleIDs = [];

		if (_serverSavingOn) then
		{
			_objectIDs = call compile preprocessFileLineNumbers "persistence\server\world\oLoad.sqf";
		};
		if (_vehicleSavingOn) then
		{
			_vehicleIDs = call compile preprocessFileLineNumbers "persistence\server\world\vLoad.sqf";
		};

		if (_serverSavingOn || {_playerSavingOn && call A3W_savingMethod == "profile"}) then
		{
			[_objectIDs, _vehicleIDs] execVM "persistence\server\world\oSave.sqf";
			waitUntil {!isNil "A3W_oSaveReady"};
		};
	};

	{
		diag_log format ["[INFO] A3W %1 = %2", _x select 0, if (_x select 1) then { "ON" } else { "OFF" }];
	}
	forEach
	[
		["playerSaving", _playerSavingOn],
		["baseSaving", _baseSavingOn],
		["vehicleSaving", _vehicleSavingOn],
		["boxSaving", _boxSavingOn],
		["staticWeaponSaving", _staticWeaponSavingOn],
		["warchestSaving", _warchestSavingOn],
		["warchestMoneySaving", _warchestMoneySavingOn],
		["spawnBeaconSaving", _beaconSavingOn]
	];
};

if (isNil "A3W_savingMethod") then
{
	A3W_savingMethod = compileFinal "'none'";
	publicVariable "A3W_savingMethod";
};

call compile preprocessFileLineNumbers "server\missions\setupMissionArrays.sqf";
call compile preprocessFileLineNumbers "server\functions\createTownMarkers.sqf";

_createTriggers = [] spawn compile preprocessFileLineNumbers "territory\server\createCaptureTriggers.sqf"; // scriptDone stays stuck on false when using execVM on Linux

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
