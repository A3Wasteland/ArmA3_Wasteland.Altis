// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:

// All the "hasInterface" and "isServer" checks are to allow this file to be executed on a headless client to offload object saving

if (!isServer && hasInterface) exitWith {};

externalConfigFolder = "\A3Wasteland_settings";

if (isServer) then
{
	vChecksum = compileFinal str call A3W_fnc_generateKey;

	// Corpse deletion on disconnect if player alive and player saving on + inventory save
	addMissionEventHandler ["HandleDisconnect",
	{
		_unit = _this select 0;
		_id = _this select 1;
		_uid = _this select 2;
		_name = _this select 3;

		diag_log format ["HandleDisconnect - %1 - alive: %2 - local: %3", [_name, _uid], alive _unit, local _unit];

		if (alive _unit) then
		{
			if (!(_unit call A3W_fnc_isUnconscious) && {!isNil "isConfigOn" && {["A3W_playerSaving"] call isConfigOn}}) then
			{
				if (!(_unit getVariable ["playerSpawning", false]) && getText (configFile >> "CfgVehicles" >> typeOf _unit >> "simulation") != "headlessclient") then
				{
					[_uid, [], [_unit, false] call fn_getPlayerData] spawn fn_saveAccount;
				};

				deleteVehicle _unit;
			};
		}
		else
		{
			if (vehicle _unit != _unit && !isNil "fn_ejectCorpse") then
			{
				_unit spawn fn_ejectCorpse;
			};
		};

		false
	}];

	//Execute Server Side Scripts.
	call compile preprocessFileLineNumbers "server\antihack\setup.sqf";
	[] execVM "server\admins.sqf";
};

[] execVM "server\functions\serverVars.sqf";

if (isServer) then
{
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

if (isServer) then
{
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
		"A3W_disableGlobalVoice",
		"A3W_antiHackMinRecoil",
		"A3W_spawnBeaconCooldown",
		"A3W_spawnBeaconSpawnHeight",
		"A3W_purchasedVehicleSaving",
		"A3W_missionVehicleSaving",
		"A3W_missionFarAiDrawLines",
		"A3W_atmEnabled",
		"A3W_atmMaxBalance",
		"A3W_atmTransferFee",
		"A3W_atmTransferAllTeams",
		"A3W_atmEditorPlacedOnly",
		"A3W_atmMapIcons",
		"A3W_atmRemoveIfDisabled",
		"A3W_uavControl",
		"A3W_townSpawnCooldown",
		"A3W_survivalSystem",
		"A3W_extDB_GhostingAdmins",
		"A3W_hcPrefix",
		"A3W_hcObjCaching",
		"A3W_hcObjCachingID",
		"A3W_hcObjSaving",
		"A3W_hcObjSavingID"
	];

	["A3W_join", "onPlayerConnected", { [_id, _uid, _name] spawn fn_onPlayerConnected }] call BIS_fnc_addStackedEventHandler;
	["A3W_quit", "onPlayerDisconnected", { diag_log format ["onPlayerDisconnected - %1", [_name, _uid]] }] call BIS_fnc_addStackedEventHandler;
};

_playerSavingOn = ["A3W_playerSaving"] call isConfigOn;
_baseSavingOn = ["A3W_baseSaving"] call isConfigOn;
_boxSavingOn = ["A3W_boxSaving"] call isConfigOn;
_staticWeaponSavingOn = ["A3W_staticWeaponSaving"] call isConfigOn;
_warchestSavingOn = ["A3W_warchestSaving"] call isConfigOn;
_warchestMoneySavingOn = ["A3W_warchestMoneySaving"] call isConfigOn;
_beaconSavingOn = ["A3W_spawnBeaconSaving"] call isConfigOn;
_timeSavingOn = ["A3W_timeSaving"] call isConfigOn;
_weatherSavingOn = ["A3W_weatherSaving"] call isConfigOn;

_purchasedVehicleSavingOn = ["A3W_purchasedVehicleSaving"] call isConfigOn;
_missionVehicleSavingOn = ["A3W_missionVehicleSaving"] call isConfigOn;

_objectSavingOn = (_baseSavingOn || _boxSavingOn || _staticWeaponSavingOn || _warchestSavingOn || _warchestMoneySavingOn || _beaconSavingOn);
_vehicleSavingOn = (_purchasedVehicleSavingOn || _purchasedVehicleSavingOn);
_hcObjSavingOn = ["A3W_hcObjSaving"] call isConfigOn;

if (_hcObjSavingOn) then
{
	A3W_hcObjSaving_unitName = format ["%1%2", ["A3W_hcPrefix", "A3W_HC"] call getPublicVar, ["A3W_hcObjSavingID", 2] call getPublicVar];

	if (!isServer && {vehicleVarName player == A3W_hcObjSaving_unitName}) then
	{
		diag_log "WASTELAND HEADLESS - Object saving enabled";
		A3W_hcObjSaving_isClient = compileFinal "true";

		if (_timeSavingOn || _weatherSavingOn) then
		{
			"currentDate" addPublicVariableEventHandler ("client\functions\clientTimeSync.sqf" call mf_compile);
			drn_DynamicWeather_MainThread = [] execVM "addons\scripts\DynamicWeatherEffects.sqf";
		};
	};
};

_setupPlayerDB = scriptNull;

#define MIN_EXTDB_VERSION 49

// Do we need any persistence?
if (_playerSavingOn || _objectSavingOn || _vehicleSavingOn || _timeSavingOn || _weatherSavingOn) then
{
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	_savingMethod = ["A3W_savingMethod", "profile"] call getPublicVar;
	if (_savingMethod == "extDB2") then { _savingMethod = "extDB" };

	// extDB
	if (_savingMethod == "extDB") then
	{
		_version = "extDB2" callExtension "9:VERSION";

		if (parseNumber _version >= MIN_EXTDB_VERSION) then
		{
			A3W_savingMethodName = compileFinal "'extDB'";
			A3W_savingMethodDir = compileFinal "'extDB'";
			A3W_extDB_ConfigName = compileFinal str (["A3W_extDB_ConfigName", "A3W"] call getPublicVar);
			A3W_extDB_IniName = compileFinal str (["A3W_extDB_IniName", "a3wasteland"] call getPublicVar);
			A3W_extDB_RconName = compileFinal str (["A3W_extDB_RconName", "A3W"] call getPublicVar);
		}
		else
		{
			if (_version != "") then
			{
				diag_log format "[INFO] ███ extDB2 startup cancelled!";
				diag_log format ["[INFO] ███ A3W requires extDB2 v%1 or later: v%2 detected", MIN_EXTDB_VERSION, _result];
			}
			else
			{
				diag_log "[INFO] ███ A3W NOT running with extDB!";
			};

			_savingMethod = "profile"; // fallback
		};
	};

	if (_savingMethod == "iniDBI") then { _savingMethod = "iniDB" };

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
			diag_log "[INFO] ███ A3W NOT running with iniDB!";
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

	if (isServer) then
	{
		A3W_savingMethod = compileFinal str _savingMethod;
		publicVariable "A3W_savingMethod";
	};

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	call compile preProcessFileLineNumbers format ["persistence\server\setup\%1\init.sqf", call A3W_savingMethodDir];

	if (isServer && _playerSavingOn) then
	{
		_setupPlayerDB = [] spawn compile preprocessFileLineNumbers "persistence\server\players\setupPlayerDB.sqf"; // scriptDone stays stuck on false when using execVM on Linux

		// profileNamespace doesn't save antihack logs
		if (_savingMethod != "profile") then
		{
			_setupPlayerDB spawn
			{
				waitUntil {scriptDone _this};

				["A3W_flagCheckOnJoin", "onPlayerConnected", { [_uid, _name] spawn fn_kickPlayerIfFlagged }] call BIS_fnc_addStackedEventHandler;

				{ [getPlayerUID _x, name _x] call fn_kickPlayerIfFlagged } forEach (call fn_allPlayers);
			};
		};
	};

	[_playerSavingOn, _objectSavingOn, _vehicleSavingOn, _timeSavingOn, _weatherSavingOn, _hcObjSavingOn] spawn
	{
		_playerSavingOn = _this select 0;
		_objectSavingOn = _this select 1;
		_vehicleSavingOn = _this select 2;
		_timeSavingOn = _this select 3;
		_weatherSavingOn = _this select 4;
		_hcObjSavingOn = _this select 5;

		_oSave = (_objectSavingOn || _vehicleSavingOn || _timeSavingOn || {_playerSavingOn && call A3W_savingMethod == "profile"});

		if (_oSave) then
		{
			[_objectSavingOn, _vehicleSavingOn] call compile preprocessFileLineNumbers "persistence\server\world\precompile.sqf";
		};

		if (isServer) then
		{
			A3W_objectIDs = [];
			A3W_vehicleIDs = [];

			if (_objectSavingOn) then
			{
				call compile preprocessFileLineNumbers "persistence\server\world\oLoad.sqf";
			};

			if (_vehicleSavingOn) then
			{
				call compile preprocessFileLineNumbers "persistence\server\world\vLoad.sqf";
			};
		};

		if (_oSave) then
		{
			if (isServer && _hcObjSavingOn) then
			{
				call compile preprocessFileLineNumbers "persistence\server\world\oSaveSetup.sqf";

				_hcUnit = objNull;
				_firstRun = true;

				_key = call A3W_fnc_generateKey;
				A3W_hcObjSaving_serverKey = compileFinal str _key;
				A3W_hcObjSaving_serverReady = compileFinal "true";
				A3W_hcObjSaving_mergeIDs = compileFinal "true";

				"pvar_hcObjSaving_setVariable" addPublicVariableEventHandler compileFinal ("_val = _this select 1; if (_val select 0 == '" + _key + "') then { (_val select 1) setVariable (_val select 2) }");
				"pvar_hcObjSaving_setTickTime" addPublicVariableEventHandler compileFinal ("_val = _this select 1; if (_val select 0 == '" + _key + "') then { (_val select 1) setVariable [_val select 2, diag_tickTime] }");
				"pvar_hcObjSaving_deleteVehicle" addPublicVariableEventHandler compileFinal ("_val = _this select 1; if (_val select 0 == '" + _key + "') then { deleteVehicle (_val select 1) }");

				while {true} do
				{
					waitUntil {sleep 1; _hcUnit = missionNamespace getVariable [A3W_hcObjSaving_unitName, objNull]; !isNull _hcUnit}; // wait until HC connects

					_pvarList = if (_firstRun) then { [] } else { ["A3W_hcObjSaving_mergeIDs"] };
					_pvarList append
					[
						"A3W_objectIDs",
						"A3W_vehicleIDs",
						/*"A3W_baseSaving",
						"A3W_boxSaving",
						"A3W_staticWeaponSaving",
						"A3W_warchestSaving",
						"A3W_warchestMoneySaving",
						"A3W_spawnBeaconSaving",
						"A3W_timeSaving",
						"A3W_weatherSaving",
						"A3W_serverSavingInterval",*/
						"A3W_hcObjSaving_serverKey",
						"A3W_hcObjSaving_serverReady"
					];

					{ (owner _hcUnit) publicVariableClient _x } forEach _pvarList;

					A3W_hcObjSaving_unit = _hcUnit;

					/*if (_firstRun) then
					{
						A3W_objectIDs = [];
						A3W_vehicleIDs = [];*/
						_firstRun = false;
					//};

					waitUntil {sleep 5; isNull _hcUnit}; // in case HC crashes, resend vars on reconnect
				};
			}
			else
			{
				_isHC = (_hcObjSavingOn && {vehicleVarName player == A3W_hcObjSaving_unitName});

				if ((!_hcObjSavingOn && isServer) || _isHC) then
				{
					if (_isHC) then
					{
						"A3W_hcObjSaving_setTickTime" addPublicVariableEventHandler { _val = _this select 1; (_val select 0) setVariable [_val select 1, diag_tickTime] };
						"A3W_hcObjSaving_trackObjID" addPublicVariableEventHandler { _val = _this select 1; if !(_val in A3W_objectIDs) then { A3W_objectIDs pushBack _val } };
						"A3W_hcObjSaving_trackVehID" addPublicVariableEventHandler { _val = _this select 1; if !(_val in A3W_vehicleIDs) then { A3W_vehicleIDs pushBack _val } };
					};

					execVM "persistence\server\world\oSave.sqf";
					//waitUntil {!isNil "A3W_oSaveReady"};
				};
			};
		};
	};

	if (isServer) then
	{
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
			["spawnBeaconSaving", _beaconSavingOn],
			["timeSaving", _timeSavingOn],
			["weatherSaving", _weatherSavingOn],
			["hcObjSaving", _hcObjSavingOn]
		];
	};
};

if (!isServer) exitWith {}; // Headless client stops here

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

if (_timeSavingOn || _weatherSavingOn) then
{
	execVM "persistence\server\world\tLoad.sqf";
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

	if (["A3W_vehicleSpawning"] call isConfigOn || ["A3W_boatSpawning"] call isConfigOn) then
	{
		execVM "server\spawning\vehicleRespawnManager.sqf";
	};
};

A3W_serverSpawningComplete = compileFinal "true";
publicVariable "A3W_serverSpawningComplete";

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
		if (!isPlayer _x && {(toLower ((vehicleVarName _x) select [0,8])) in ["genstore","gunstore","vehstore"]}) then
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
