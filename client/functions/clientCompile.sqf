//	@file Name: clientCompile.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Args:

mf_notify_client = "client\functions\notifyClient.sqf" call mf_compile;
mf_util_playUntil = "client\functions\playUntil.sqf" call mf_compile;

// Event handlers
onRespawn = "client\clientEvents\onRespawn.sqf" call mf_compile;
onKilled = "client\clientEvents\onKilled.sqf" call mf_compile;
onKeyPress = "client\clientEvents\onKeyPress.sqf" call mf_compile;

// Functions
addPushPlaneAction = "client\functions\addPushPlaneAction.sqf" call mf_compile;
addWeaponInventory = "client\functions\addWeaponInventory.sqf" call mf_compile;
canPushPlaneBack = "client\functions\canPushPlaneBack.sqf" call mf_compile;
canWear = "client\functions\canWear.sqf" call mf_compile;
findHackedVehicles = "client\systems\adminPanel\findHackedVehicles.sqf" call mf_compile;
fn_fitsInventory = "client\functions\fn_fitsInventory.sqf" call mf_compile;
getCurrentBinoculars = "client\functions\getCurrentBinoculars.sqf" call mf_compile;
getDefaultClothing = "client\functions\getDefaultClothing.sqf" call mf_compile;
getFullMove = "client\functions\getFullMove.sqf" call mf_compile;
getMoveParams = "client\functions\getMoveParams.sqf" call mf_compile;
isAdmin = "client\systems\adminPanel\isAdmin.sqf" call mf_compile;
isAssignableBinocular = "client\functions\isAssignableBinocular.sqf" call mf_compile;
isWeaponType = "client\functions\isWeaponType.sqf" call mf_compile;
parseMove = "client\functions\parseMove.sqf" call mf_compile;
serverMessage = "client\functions\serverMessage.sqf" call mf_compile;
titleTextMessage = "client\functions\titleTextMessage.sqf" call mf_compile;
uniformConverter = "client\functions\uniformConverter.sqf" call mf_compile;

// Player details and actions
loadPlayerMenu = "client\systems\playerMenu\init.sqf" call mf_compile;
playerSpawn = "client\functions\playerSpawn.sqf" call mf_compile;
playerSetup = "client\functions\playerSetup.sqf" call mf_compile;
playerSetupStart = "client\functions\playerSetupStart.sqf" call mf_compile;
playerSetupGear = "client\functions\playerSetupGear.sqf" call mf_compile;
playerSetupEnd = "client\functions\playerSetupEnd.sqf" call mf_compile;
spawnAction = "client\functions\spawnAction.sqf" call mf_compile;
// placeSpawnBeacon = "client\systems\playerMenu\placeSpawnBeacon.sqf" call mf_compile;
// refuelVehicle = "client\systems\playerMenu\refuel.sqf" call mf_compile;
// repairVehicle = "client\systems\playerMenu\repair.sqf" call mf_compile;

// Sync client with server time
timeSync = "client\functions\clientTimeSync.sqf" call mf_compile;

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
gearProperties = "client\functions\gearProperties.sqf" call mf_compile;
getCapacity = "client\functions\getCapacity.sqf" call mf_compile;
getItemInfo = "client\functions\getItemInfo.sqf" call mf_compile;
requestStoreObject = "client\functions\requestStoreObject.sqf" call mf_compile;

// Custom paint/textures on vehicles
applyVehicleTexture = "client\systems\vehicleStore\applyVehicleTexture.sqf" call mf_compile;

if (isNil "TPG_fnc_MP") then { TPG_fnc_MP = "\A3\functions_f\MP\fn_MP.sqf" call mf_compile };
if (isNil "TPG_fnc_MPexec") then { TPG_fnc_MPexec = "\A3\functions_f\MP\fn_MPexec.sqf" call mf_compile };

player groupChat "Wasteland - Client Compile Complete";
sleep 1;
playerCompiledScripts = true;
