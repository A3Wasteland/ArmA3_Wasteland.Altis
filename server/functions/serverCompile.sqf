//	@file Version: 1.1
//	@file Name: serverCompile.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer) exitWith {};

diag_log "WASTELAND SERVER - Initializing Server Compile";

// Do not add missions here, put their name directly in the mission controllers

/*
//Main Mission Compiles

mission_ArmedHeli = "server\missions\mainMissions\mission_ArmedHeli.sqf" call mf_compile;
mission_LightArmVeh = "server\missions\mainMissions\mission_LightArmVeh.sqf" call mf_compile;
mission_CivHeli = "server\missions\mainMissions\mission_CivHeli.sqf" call mf_compile;
mission_HostileHeliFormation = "server\missions\mainMissions\mission_HostileHeliFormation.sqf" call mf_compile;
mission_Convoy = "server\missions\mainMissions\mission_Convoy.sqf" call mf_compile;
mission_ArmedDiversquad = "server\missions\mainMissions\mission_ArmedDiversquad.sqf" call mf_compile;
mission_APC = "server\missions\mainMissions\mission_APC.sqf" call mf_compile;
mission_Outpost = "server\missions\mainMissions\mission_Outpost.sqf" call mf_compile;
mission_Coastal_Convoy = "server\missions\mainMissions\mission_Coastal_Convoy.sqf" call mf_compile;
*/

/*
mission_LightTank = "server\missions\mainMissions\mission_LightTank.sqf" call mf_compile;
mission_MBT = "server\missions\mainMissions\mission_MBT.sqf" call mf_compile;
mission_RadarTruck = "server\missions\mainMissions\mission_RadarTruck.sqf" call mf_compile;
mission_SupplyDrop = "server\missions\mainMissions\mission_SupplyDrop.sqf" call mf_compile;
*/

/*
//Side Mission Compiles

mission_AirWreck = "server\missions\sideMissions\mission_AirWreck.sqf" call mf_compile;
mission_WepCache = "server\missions\sideMissions\mission_WepCache.sqf" call mf_compile;
mission_MiniConvoy = "server\missions\sideMissions\mission_MiniConvoy.sqf" call mf_compile;
mission_SunkenSupplies = "server\missions\sideMissions\mission_SunkenSupplys.sqf" call mf_compile;
mission_HostileHelicopter = "server\missions\sideMissions\mission_HostileHelicopter.sqf" call mf_compile;
mission_Truck = "server\missions\sideMissions\mission_Truck.sqf" call mf_compile;
*/

/*
mission_ReconVeh = "server\missions\sideMissions\mission_ReconVeh.sqf" call mf_compile;
*/

//Factory Compiles
_path = "server\missions\factoryMethods";
createCargoItem = [_path, "createCargoItem.sqf"] call mf_compile;
createClientMarker = [_path, "createClientMarker.sqf"] call mf_compile;
createLargeDivers = [_path, "createUnits\largeDivers.sqf"] call mf_compile;
createLargeGroup = [_path, "createUnits\largeGroup.sqf"] call mf_compile;
createMidGroup = [_path, "createUnits\midGroup.sqf"] call mf_compile;
createMissionLocation = [_path, "createMissionLocation.sqf"] call mf_compile;
createMissionVehicle = [_path, "createMissionVehicle.sqf"] call mf_compile;
createMissionVehicle2 = [_path, "createMissionVehicle2.sqf"] call mf_compile;
createRandomSoldier = [_path, "createUnits\createRandomSoldier.sqf"] call mf_compile;
createRandomSoldierC = [_path, "createUnits\createRandomSoldierC.sqf"] call mf_compile;
createRandomAquaticSoldier = [_path, "createUnits\createRandomAquaticSoldier.sqf"] call mf_compile;
createSmallDivers = [_path, "createUnits\smallDivers.sqf"] call mf_compile;
createSmallGroup = [_path, "createUnits\smallGroup.sqf"] call mf_compile;
createSupplyDrop = [_path, "createSupplyDrop.sqf"] call mf_compile;
createWaitCondition = [_path, "createWaitCondition.sqf"] call mf_compile;
deleteClientMarker = [_path, "deleteClientMarker.sqf"] call mf_compile;

//Function Compiles
_path = "server\functions";
addMilCap = [_path, "addMilCap.sqf"] call mf_compile;
checkHackedVehicles = [_path, "checkHackedVehicles.sqf"] call mf_compile;
cleanVehicleWreck = [_path, "cleanVehicleWreck.sqf"] call mf_compile;
convertTerritoryOwner = "territory\server\convertTerritoryOwner.sqf" call mf_compile;
defendArea = [_path, "defendArea.sqf"] call mf_compile;
findClientPlayer = [_path, "findClientPlayer.sqf"] call mf_compile;
fn_onPlayerDisconnected = [_path, "fn_onPlayerDisconnected.sqf"] call mf_compile;
fn_refillBox = [_path, "fn_refillbox.sqf"] call mf_compile;
fn_refillTruck = [_path, "fn_refilltruck.sqf"] call mf_compile;
fn_replaceMagazines = [_path, "fn_replaceMagazines.sqf"] call mf_compile;
fn_replaceWeapons = [_path, "fn_replaceWeapons.sqf"] call mf_compile;
fn_selectRandomWeighted = [_path, "fn_selectRandomWeighted.sqf"] call mf_compile;
hintBroadcast = [_path, "hintBroadcast.sqf"] call mf_compile;
parachuteLiftedVehicle = [_path, "parachuteLiftedVehicle.sqf"] call mf_compile;
processItems = [_path, "processItems.sqf"] call mf_compile;
refillPrimaryAmmo = [_path, "refillPrimaryAmmo.sqf"] call mf_compile;
setMissionSkill = [_path, "setMissionSkill.sqf"] call mf_compile;
spawnStoreObject = [_path, "spawnStoreObject.sqf"] call mf_compile;
vehicleRepair = [_path, "vehicleRepair.sqf"] call mf_compile;
vehicleSetup = [_path, "vehicleSetup.sqf"] call mf_compile;

//Player Management
server_playerDied = [_path, "serverPlayerDied.sqf"] call mf_compile;

//Spawning Compiles
_path = "server\spawning";
boatCreation = [_path, "boatCreation.sqf"] call mf_compile;
objectCreation = [_path, "objectCreation.sqf"] call mf_compile;
planeCreation = [_path, "planeCreation.sqf"] call mf_compile;
randomWeapons = [_path, "randomWeapon.sqf"] call mf_compile;
// staticGunCreation = [_path, "staticGunCreation.sqf"] call mf_compile;
staticHeliCreation = [_path, "staticHeliCreation.sqf"] call mf_compile;
vehicleCreation = [_path, "vehicleCreation.sqf"] call mf_compile;

if (isNil "TPG_fnc_MP") then { TPG_fnc_MP = "\A3\functions_f\MP\fn_MP.sqf" call mf_compile };
if (isNil "TPG_fnc_MPexec") then { TPG_fnc_MPexec = "\A3\functions_f\MP\fn_MPexec.sqf" call mf_compile };
