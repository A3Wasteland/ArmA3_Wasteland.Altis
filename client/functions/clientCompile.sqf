//	@file Name: clientCompile.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, MercyfulFate
//	@file Args:

mf_notify_client = "client\functions\notifyClient.sqf" call mf_compile;
mf_util_playUntil = "client\functions\playUntil.sqf" call mf_compile;

// Event handlers
onRespawn = compile preprocessfile "client\clientEvents\onRespawn.sqf";
onKilled = compile preprocessfile "client\clientEvents\onKilled.sqf";
onKeyPress = compile preprocessFile "client\clientEvents\onKeyPress.sqf";
fn_fitsInventory = compile preprocessFileLineNumbers "client\functions\fn_fitsInventory.sqf";
findHackedVehicles = compileFinal preprocessFileLineNumbers "client\systems\adminPanel\findHackedVehicles.sqf";
serverMessage = compileFinal preprocessFileLineNumbers "client\functions\serverMessage.sqf";
titleTextMessage = compileFinal preprocessFileLineNumbers "client\functions\titleTextMessage.sqf";

// Player details and actions
loadPlayerMenu = "client\systems\playerMenu\init.sqf" call mf_compile;
playerSpawn = "client\functions\playerSpawn.sqf" call mf_compile;
playerSetup = "client\functions\playerSetup.sqf" call mf_compile;
spawnAction = "client\functions\spawnAction.sqf" call mf_compile;
placeSpawnBeacon = "client\systems\playerMenu\placeSpawnBeacon.sqf" call mf_compile;
refuelVehicle = "client\systems\playerMenu\refuel.sqf" call mf_compile;
repairVehicle = "client\systems\playerMenu\repair.sqf" call mf_compile;

// Sync client with server time
timeSync = compile preprocessFileLineNumbers "client\functions\clientTimeSync.sqf";

// Update scripts
updateMissionsMarkers = "client\functions\updatePlayerMissionMarkers.sqf" call mf_compile;
updateRadarMarkers = "client\functions\updatePlayerRadarMarkers.sqf" call mf_compile;
updateTeamKiller = "client\functions\updateTeamKiller.sqf" call mf_compile;

// Team-kill system
teamkillAction = "client\functions\doTeamKillAction.sqf" call mf_compile;
teamkillMessage = "client\functions\showTeamKillMessage.sqf" call mf_compile;

// Dialog compiles
client_respawnDialog = "client\functions\loadRespawnDialog.sqf" call mf_compile;
loadGeneralStore = "client\systems\generalStore\loadGenStore.sqf" call mf_compile;
loadGunStore = "client\systems\gunStore\loadGunStore.sqf" call mf_compile;

player groupChat "Wasteland - Client Compile Complete";
sleep 1;
playerCompiledScripts = true;
