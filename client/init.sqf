//@file Version: 1.1
//@file Name: init.sqf
//@file Author: [404] Deadbeat, [GoT] JoSchaap
//@file Created: 20/11/2012 05:19
//@file Description: The client init.

if (isDedicated) exitWith {};

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
waitUntil{time > 2};
removeAllWeapons player;
player switchMove "";

//Stop people being civ's.
if(!(playerSide in [BLUFOR, OPFOR, INDEPENDENT, sideEnemy])) then { 
	endMission "LOSER";
};

// initialize actions and inventory
"client\actions" call mf_init;
"client\inventory" call mf_init;
"client\items" call mf_init;

//Call client compile list.
player call compile preprocessFileLineNumbers "client\functions\clientCompile.sqf";


//Player setup
player call playerSetup;
player setVariable["positionLoaded",0,true];

// Player saving
diag_log format["(call config_player_saving_enabled) is %1", (call config_player_saving_enabled)];

// Player saving - Load from iniDB
if ((call config_player_saving_enabled) == 1) then {
	diag_log "Client has player saving enabled";
	diag_log "Loading c_saveToServer";
	[] execVM "persistence\players\c_saveToServer.sqf";
	waitUntil {!isNil "fn_SaveToServer"};
	diag_log "Loading c_playerDBSetup";
	[] execVM "persistence\players\c_playerDBSetup.sqf";
	waitUntil {!isNil "statFunctionsLoaded"};
	[] execVM "persistence\players\c_loadAccount.sqf";

	// If the server has configured donation money, load that from the DB
	waitUntil {!isNil "moneyLoaded"};
	computedMoney = player getVariable "computedMoney";
	if(isNil 'computedMoney') then {
		computedMoney = 0;
		player setVariable["computedMoney", 0, true];
	};

	if(player getVariable "cmoney" == 100) then {
		if(computedMoney > 0) then {player globalChat format["Thank you for your donation. You have spawned with $%1 extra cash.", computedMoney];};
		player setVariable["cmoney",100 + computedMoney,true];
	};

	waitUntil {!isNil "positionLoaded"};
} else {
	diag_log format["Client has no player save functionality"];
};

// See if we have a position from the player save system
_positionLoaded = player getVariable ["positionLoaded", 0];

//Setup player events.
if(!isNil "client_initEH") then {player removeEventHandler ["Respawn", client_initEH];};
player addEventHandler ["Respawn", {[_this] call onRespawn;}];
player addEventHandler ["Killed", {[_this] call onKilled;}];

//Setup player menu scroll action.
[] execVM "client\clientEvents\onMouseWheel.sqf";

//Setup Key Handler
waituntil {!(IsNull (findDisplay 46))};
(findDisplay 46) displaySetEventHandler ["KeyDown", "_this call onKeyPress"];

"currentDate" addPublicVariableEventHandler {[] call timeSync};
"messageSystem" addPublicVariableEventHandler {[] call serverMessage};
"clientMissionMarkers" addPublicVariableEventHandler {[] call updateMissionsMarkers};
"clientRadarMarkers" addPublicVariableEventHandler {[] call updateRadarMarkers};
"pvar_teamKillList" addPublicVariableEventHandler {[] call updateTeamKiller};
"publicVar_teamkillMessage" addPublicVariableEventHandler {if (local (_this select 1)) then { [] spawn teamkillMessage }};
"compensateNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore };

//client Executes
[] execVM "client\functions\initSurvival.sqf";
[] execVM "client\systems\hud\playerHud.sqf";
[] execVM "client\functions\createTownMarkers.sqf";
[] execVM "client\functions\createGunStoreMarkers.sqf";
[] execVM "client\functions\createGeneralStoreMarkers.sqf";
[] execVM "client\functions\playerTags.sqf";
[] execVM "client\functions\groupTags.sqf";
[] call updateMissionsMarkers;
[] call updateRadarMarkers;
if (isNil "FZF_IC_INIT") then   {
	call compile preprocessFileLineNumbers "client\functions\newPlayerIcons.sqf";
};

// If we've got a position from the player save system, don't go through playerSpawn
if(_positionLoaded == 0) then {
	true spawn playerSpawn;
} else {
	player switchMove "AmovPpneMstpSnonWnonDnon";
};

[] spawn FZF_IC_INIT;

{
	if (isPlayer _x && {!isNil ("addScore_" + (getPlayerUID _x))}) then
	{
		_x call removeNegativeScore;
	};
} forEach playableUnits; 
