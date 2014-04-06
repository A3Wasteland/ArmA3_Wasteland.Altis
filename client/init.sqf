//@file Version: 1.1
//@file Name: init.sqf
//@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev, [KoS] Bewilderbeest
//@file Created: 20/11/2012 05:19
//@file Description: The client init.

if (isDedicated) exitWith {};

waitUntil {!isNil "A3W_network_compileFuncs"};
waitUntil {!isNil "A3W_serverSetupComplete"};

call A3W_network_compileFuncs;
A3W_network_compileFuncs = nil;

[] execVM "client\functions\bannedNames.sqf";

showPlayerIcons = true;
mutexScriptInProgress = false;
respawnDialogActive = false;
groupManagmentActive = false;
pvar_PlayerTeamKiller = objNull;
doCancelAction = false;
currentMissionsMarkers = [];
currentRadarMarkers = [];

//Initialization Variables
playerCompiledScripts = false;
playerSetupComplete = false;

waitUntil {!isNull player};
waitUntil {time > 0.1};

removeAllWeapons player;
player switchMove "";

// initialize actions and inventory
"client\actions" call mf_init;
"client\inventory" call mf_init;
"client\items" call mf_init;

//Call client compile list.
call compile preprocessFileLineNumbers "client\functions\clientCompile.sqf";

// Reset group
[player] joinSilent createGroup (player call vehicleSideCfg);

//Stop people being civ's.
if !(playerSide in [BLUFOR,OPFOR,INDEPENDENT]) exitWith
{
	endMission "LOSER";
};

//Setup player events.
if (!isNil "client_initEH") then { player removeEventHandler ["Respawn", client_initEH] };
player addEventHandler ["Respawn", { _this spawn onRespawn }];
player addEventHandler ["Killed", { _this spawn onKilled }];

//Player setup
player call playerSetupStart;

// Deal with money here
_baseMoney = ["A3W_startingMoney", 100] call getPublicVar;
player setVariable ["cmoney", _baseMoney, true];

// Player saving - Load from iniDB
if (["A3W_playerSaving"] call isConfigOn) then
{
	call compile preprocessFileLineNumbers "persistence\players\c_setupPlayerDB.sqf";
	call fn_requestPlayerData;
	
	waitUntil {!isNil "playerData_loaded"};
	
	[] spawn
	{
		// Save player every 60s
		while {true} do
		{
			sleep 60;
			call fn_savePlayerData;
		};
	};
};

if (isNil "playerData_alive") then
{
	player call playerSetupGear;
};

player call playerSetupEnd;

diag_log format ["Player starting with $%1", player getVariable ["cmoney", 0]];

// Territory system enabled?
if (count (["config_territory_markers", []] call getPublicVar) > 0) then
{
	territoryActivityHandler = "territory\client\territoryActivityHandler.sqf" call mf_compile;
	[] execVM "territory\client\createCaptureTriggers.sqf";
};

//Setup player menu scroll action.
[] execVM "client\clientEvents\onMouseWheel.sqf";

//Setup Key Handler
waituntil {!(IsNull (findDisplay 46))};
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call onKeyPress"];

"currentDate" addPublicVariableEventHandler {[] call timeSync};
"messageSystem" addPublicVariableEventHandler {[] call serverMessage};
"clientMissionMarkers" addPublicVariableEventHandler {[] call updateMissionsMarkers};
// "clientRadarMarkers" addPublicVariableEventHandler {[] call updateRadarMarkers};
"pvar_teamKillList" addPublicVariableEventHandler {[] call updateTeamKiller};
"publicVar_teamkillMessage" addPublicVariableEventHandler {if (local (_this select 1)) then { [] spawn teamkillMessage }};
"compensateNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore };

//client Executes
[] execVM "client\functions\initSurvival.sqf";
[] execVM "client\systems\hud\playerHud.sqf";
[] execVM "client\functions\createTownMarkers.sqf";
[] execVM "client\functions\createGunStoreMarkers.sqf";
[] execVM "client\functions\createGeneralStoreMarkers.sqf";
[] execVM "client\functions\createVehicleStoreMarkers.sqf";
[] execVM "client\functions\playerTags.sqf";
[] execVM "client\functions\groupTags.sqf";
[] call updateMissionsMarkers;
// [] call updateRadarMarkers;

[] spawn playerSpawn;

[] execVM "client\functions\drawPlayerIcons.sqf";

// Synchronize score compensation
{
	if (isPlayer _x) then
	{
		_scoreVar = "addScore_" + getPlayerUID _x;
		_scoreVal = missionNamespace getVariable _scoreVar;
		
		if (!isNil "_scoreVal" && {typeName _scoreVal == "SCALAR"}) then
		{
			_x addScore _scoreVal;
		};
	};
} forEach playableUnits;

_uid = getPlayerUID player;

// update player's spawn beaoon
{
	if (_x getVariable ["ownerUID",""] == _uid) exitWith
	{
		_x setVariable ["ownerName", name player, true];
		_x setVariable ["side", playerSide, true];
	};
} forEach pvar_spawn_beacons;

[] execVM "addons\fpsFix\vehicleManager.sqf";
[] execVM "addons\Lootspawner\LSclientScan.sqf";
