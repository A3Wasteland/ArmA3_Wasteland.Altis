// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: clientCompile.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Args:

mf_notify_client = "client\functions\notifyClient.sqf" call mf_compile;
mf_util_playUntil = "client\functions\playUntil.sqf" call mf_compile;

// Event handlers
getInVehicle = "client\clientEvents\getInVehicle.sqf" call mf_compile;
getOutVehicle = "client\clientEvents\getOutVehicle.sqf" call mf_compile;
onRespawn = "client\clientEvents\onRespawn.sqf" call mf_compile;
onKilled = "client\clientEvents\onKilled.sqf" call mf_compile;
onKeyPress = "client\clientEvents\onKeyPress.sqf" call mf_compile;
onKeyRelease = "client\clientEvents\onKeyRelease.sqf" call mf_compile;

// Functions
A3W_fnc_copilotTakeControl = "client\functions\copilotTakeControl.sqf" call mf_compile;
A3W_fnc_inGameUIActionEvent = "client\functions\fn_inGameUIActionEvent.sqf" call mf_compile;
A3W_fnc_forceOpenParachute = "client\functions\fn_forceOpenParachute.sqf" call mf_compile;
A3W_fnc_killFeedMenu = "client\systems\killFeed\killFeedMenu.sqf" call mf_compile;
A3W_fnc_openParachute = "client\functions\fn_openParachute.sqf" call mf_compile;
A3W_fnc_playerEventServer = "client\functions\playerEventServer.sqf" call mf_compile;
A3W_fnc_titleTextMessage = "client\functions\titleTextMessage.sqf" call mf_compile;
addWeaponInventory = "client\functions\addWeaponInventory.sqf" call mf_compile;
canForceSaveStaticWeapon = "client\functions\canForceSaveStaticWeapon.sqf" call mf_compile;
canForceSaveVehicle = "client\functions\canForceSaveVehicle.sqf" call mf_compile;
canPushPlaneBack = "client\functions\canPushPlaneBack.sqf" call mf_compile;
canPushVehicleOnFoot = "client\functions\canPushVehicleOnFoot.sqf" call mf_compile;
canPushWatercraft = "client\functions\canPushWatercraft.sqf" call mf_compile;
findHackedVehicles = "client\systems\adminPanel\findHackedVehicles.sqf" call mf_compile;
fn_addManagedAction = "client\functions\fn_addManagedAction.sqf" call mf_compile;
fn_canTakeOwnership = "client\actions\canTakeOwnership.sqf" call mf_compile;
fn_ctrlOverlapCheck = "client\functions\fn_ctrlOverlapCheck.sqf" call mf_compile;
fn_disableCollision = "client\functions\fn_disableCollision.sqf" call mf_compile;
fn_disableDriverAssist = "client\functions\fn_disableDriverAssist.sqf" call mf_compile;
fn_emergencyEject = "client\functions\fn_emergencyEject.sqf" call mf_compile;
fn_enableDriverAssist = "client\functions\fn_enableDriverAssist.sqf" call mf_compile;
fn_encodeText = "client\functions\fn_encodeText.sqf" call mf_compile;
fn_fitsInventory = "client\functions\fn_fitsInventory.sqf" call mf_compile;
fn_forceSaveObject = "client\functions\fn_forceSaveObject.sqf" call mf_compile;
fn_forceSaveVehicle = "client\functions\fn_forceSaveVehicle.sqf" call mf_compile;
fn_formatTimer = "client\functions\fn_formatTimer.sqf" call mf_compile;
fn_getItemArmor = "client\functions\fn_getItemArmor.sqf" call mf_compile;
fn_killFeedRefresh = "client\systems\killFeed\fn_killFeedRefresh.sqf" call mf_compile;
fn_removeAllManagedActions = "client\functions\fn_removeAllManagedActions.sqf" call mf_compile;
fn_removeManagedAction = "client\functions\fn_removeManagedAction.sqf" call mf_compile;
fn_voiceChatControl = "client\functions\fn_voiceChatControl.sqf" call mf_compile;
getDefaultClothing = "client\functions\getDefaultClothing.sqf" call mf_compile;
getFullMove = "client\functions\getFullMove.sqf" call mf_compile;
getMoveParams = "client\functions\getMoveParams.sqf" call mf_compile;
getPushPlaneAction = "client\functions\getPushPlaneAction.sqf" call mf_compile;
groupNotify = "client\functions\groupNotify.sqf" call mf_compile;
isAdmin = "client\systems\adminPanel\isAdmin.sqf" call mf_compile;
isAssignableBinocular = "client\functions\isAssignableBinocular.sqf" call mf_compile;
isPVarTarget = "client\functions\isPVarTarget.sqf" call mf_compile;
isWeaponType = "client\functions\isWeaponType.sqf" call mf_compile;
parseMove = "client\functions\parseMove.sqf" call mf_compile;
serverMessage = "client\functions\serverMessage.sqf" call mf_compile;
uniformConverter = "client\functions\uniformConverter.sqf" call mf_compile;
unitHandleDamage = "client\functions\unitHandleDamage.sqf" call mf_compile;
updateTerritoryMarkers = "territory\client\updateTerritoryMarkers.sqf" call mf_compile;
vehicleSideCfg = "client\functions\vehicleSideCfg.sqf" call mf_compile;
weaponDisassembledEvent = "client\functions\weaponDisassembledEvent.sqf" call mf_compile;

// Player details and actions
loadPlayerMenu = "client\systems\playerMenu\init.sqf" call mf_compile;
playerSpawn = "client\functions\playerSpawn.sqf" call mf_compile;
playerSetup = "client\functions\playerSetup.sqf" call mf_compile;
playerSetupStart = "client\functions\playerSetupStart.sqf" call mf_compile;
playerSetupGear = "client\functions\playerSetupGear.sqf" call mf_compile;
playerSetupEnd = "client\functions\playerSetupEnd.sqf" call mf_compile;
spawnAction = "client\functions\spawnAction.sqf" call mf_compile;
spawnInTown = "client\functions\spawnInTown.sqf" call mf_compile;
spawnOnBeacon = "client\functions\spawnOnBeacon.sqf" call mf_compile;
spawnRandom = "client\functions\spawnRandom.sqf" call mf_compile;
// placeSpawnBeacon = "client\systems\playerMenu\placeSpawnBeacon.sqf" call mf_compile;
// refuelVehicle = "client\systems\playerMenu\refuel.sqf" call mf_compile;
// repairVehicle = "client\systems\playerMenu\repair.sqf" call mf_compile;

// Sync client with server time
timeSync = "client\functions\clientTimeSync.sqf" call mf_compile;

// Update scripts
updateTeamKiller = "client\functions\updateTeamKiller.sqf" call mf_compile;

// Team-kill system
teamkillAction = "client\functions\doTeamKillAction.sqf" call mf_compile;
teamkillMessage = "client\functions\showTeamKillMessage.sqf" call mf_compile;

// Dialog compiles
client_respawnDialog = "client\systems\playerMenu\dialog\loadRespawnDialog.sqf" call mf_compile;
fn_checkStoreItemDLC = "client\functions\fn_checkStoreItemDLC.sqf" call mf_compile;
fn_respawnTimer = "client\systems\scoreboard\fn_respawnTimer.sqf" call mf_compile;
loadGeneralStore = "client\systems\generalStore\loadGenStore.sqf" call mf_compile;
loadGunStore = "client\systems\gunStore\loadGunStore.sqf" call mf_compile;
loadScoreboard = "client\systems\scoreboard\loadScoreboard.sqf" call mf_compile;
loadVehicleStore = "client\systems\vehicleStore\loadVehicleStore.sqf" call mf_compile;
gearProperties = "client\functions\gearProperties.sqf" call mf_compile;
getCapacity = "client\functions\getCapacity.sqf" call mf_compile;
getItemInfo = "client\functions\getItemInfo.sqf" call mf_compile;
getInventory = "client\systems\generalStore\getInventory.sqf" call mf_compile;
getSellPriceList = "client\systems\selling\getSellPriceList.sqf" call mf_compile;
populateGeneralStore = "client\systems\generalStore\populateGenStore.sqf" call mf_compile;
populateGunStore = "client\systems\gunStore\populateGunStore.sqf" call mf_compile;
populateVehicleStore = "client\systems\vehicleStore\populateVehicleStore.sqf" call mf_compile;
repaintVehicle = "client\systems\vehicleStore\repaintVehicle.sqf" call mf_compile;
requestStoreObject = "client\functions\requestStoreObject.sqf" call mf_compile;
vehicleInfo = "client\systems\vehicleStore\vehicleInfo.sqf" call mf_compile;
weaponInfo = "client\systems\gunStore\weaponInfo.sqf" call mf_compile;

if (isNil "A3W_fnc_MP") then { A3W_fnc_MP = compile preprocessFileLineNumbers "\A3\functions_f\MP\fn_MP.sqf" };
if (isNil "A3W_fnc_MPexec") then { A3W_fnc_MPexec = compile preprocessFileLineNumbers "\A3\functions_f\MP\fn_MPexec.sqf" };

player groupChat "Wasteland - Client Compile Complete";
sleep 1;
playerCompiledScripts = true;
