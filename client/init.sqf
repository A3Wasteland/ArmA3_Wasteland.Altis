//@file Version: 1.1
//@file Name: init.sqf
//@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev, [KoS] Bewilderbeest
//@file Created: 20/11/2012 05:19
//@file Description: The client init.

if (isDedicated) exitWith {};

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

// Player saving - Load from iniDB
if ((call config_player_saving_enabled) == 1) then {
	positionLoaded = 0;
	donationMoneyLoaded = 0; // used only if config_player_donations_enabled is set

	[] execVM "persistence\players\c_serverSaveRelay.sqf";
	waitUntil {!isNil "fn_SaveToServer"};
	[] execVM "persistence\players\c_playerDBSetup.sqf";
	waitUntil {!isNil "statFunctionsLoaded"};
	[] execVM "persistence\players\c_loadAccount.sqf";

	if ((call config_player_donations_enabled) == 1) then {
		// If the server has configured donation money, load that from the DB
		waitUntil {donationMoneyLoaded == 1};
		_donationMoney = player getVariable ["donationMoney", 0];
		if(_donationMoney > 0) then {player globalChat format["Thank you for your donation. You will have $%1 extra cash on spawn", _donationMoney];};
	};

	// Deal with money here
	// If there are server donations, bump up the amount players spawn with
	_baseMoney = (call config_initial_spawn_money);
	if ((call config_player_donations_enabled) == 1) then {
		_donationMoney = player getVariable ["donationMoney", 0];
		diag_log format["Player starting with $%1 (%2 + %3)", _baseMoney + _donationMoney, _baseMoney, _donationMoney];
		player setVariable["cmoney",_baseMoney + _donationMoney,true];
	} else {
		diag_log format["Player starting with $%1", _baseMoney];
		player setVariable["cmoney",_baseMoney,true];
	};

	waitUntil {positionLoaded == 1};
} else {
	diag_log format["Client has no player save functionality"];
};

// Territory system enabled?
if (count (call config_territory_markers) > 0) then {
	territoryActivityHandler = "territory\client\territoryActivityHandler.sqf" call mf_compile;
	[] execVM "territory\client\createCaptureTriggers.sqf";
};

// Find out if the player has been moved by the persistence system
_playerWasMoved = player getVariable ["playerWasMoved", 0];

//Setup player events.
if(!isNil "client_initEH") then {player removeEventHandler ["Respawn", client_initEH];};
player addEventHandler ["Respawn", { _this spawn onRespawn }];
player addEventHandler ["Killed", { _this spawn onKilled }];

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
[] execVM "client\functions\createVehicleStoreMarkers.sqf";
[] execVM "client\functions\playerTags.sqf";
[] execVM "client\functions\groupTags.sqf";
if (A3W_showlocationmarker) then  {[] execVM "client\functions\createLocationMarkers.sqf";};
[] call updateMissionsMarkers;
[] call updateRadarMarkers;
if (isNil "FZF_IC_INIT") then
{
	call compile preprocessFileLineNumbers "client\functions\newPlayerIcons.sqf";
};

// If we've got a position from the player save system, don't go through playerSpawn
if (_playerWasMoved == 0) then {
	true spawn playerSpawn;
} else {
	player switchMove "AmovPpneMstpSnonWnonDnon";
};

[] spawn FZF_IC_INIT;

{
	if (isPlayer _x && {!isNil ("addScore_" + (getPlayerUID _x))}) then
	{
		_x spawn removeNegativeScore;
	};
} forEach playableUnits;

[] execVM "addons\fpsFix\vehicleManager.sqf";

while {isnil "A3W_baseSaving"} do
{
    sleep 10;
};
if (A3W_baseSaving != 0) then
{
    if (A3W_boxSaving == 0) then
    {
        player createDiaryRecord["infos", ["Base Saving", format ["Base parts will be relocked and saved for %1 day(s). Ammo boxes are not saved. Contents other than Food and Water (in the original containers) are not saved.", A3W_baseSaveTime]]];
    }
    else
    {
        player createDiaryRecord["infos", ["Base Saving", format ["Base parts will be relocked and saved for %1 day(s), Purchased Ammo Boxes for %2 day(s) and Captured boxes for 1 restart after being locked. Weapons and items are only saved in Ammo Boxes - Food and Water is saved in the original containers.", A3W_baseSaveTime, A3W_ammoboxSaveTime]]];
    };
};

    