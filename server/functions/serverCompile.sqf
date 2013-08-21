#include "setup.sqf"
//	@file Version: 1.1
//	@file Name: serverCompile.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap
//	@file Created: 20/11/2012 05:19
//	@file Args:

if(!X_Server) exitWith {};

diag_log format["WASTELAND SERVER - Initilizing Server Compile"];

//Main Mission Compiles

mission_ArmedHeli = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_ArmedHeli.sqf";
mission_LightArmVeh = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_LightArmVeh.sqf";
mission_CivHeli = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_CivHeli.sqf";
mission_HostileHeliFormation = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_HostileHeliFormation.sqf";
mission_Convoy = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_Convoy.sqf";
mission_ArmedDiversquad = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_ArmedDiversquad.sqf";
mission_APC = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_APC.sqf";
mission_Outpost = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_Outpost.sqf";
mission_Coastal_Convoy = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_Coastal_Convoy.sqf";

/*
mission_LightTank = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_LightTank.sqf";
mission_MBT = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_MBT.sqf";
mission_RadarTruck = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_RadarTruck.sqf";
mission_SupplyDrop = compile preprocessFileLineNumbers "server\missions\mainMissions\mission_SupplyDrop.sqf";
*/

//Side Mission Compiles
mission_AirWreck = compile preprocessFileLineNumbers "server\missions\sideMissions\mission_AirWreck.sqf";
mission_WepCache = compile preprocessFileLineNumbers "server\missions\sideMissions\mission_WepCache.sqf";
mission_MiniConvoy = compile preprocessFileLineNumbers "server\missions\sideMissions\mission_MiniConvoy.sqf";
mission_SunkenSupplies = compile preprocessFileLineNumbers "server\missions\sideMissions\mission_SunkenSupplys.sqf";
mission_HostileHelicopter = compile preprocessFileLineNumbers "server\missions\sideMissions\mission_HostileHelicopter.sqf";
mission_Truck = compile preprocessFileLineNumbers "server\missions\sideMissions\mission_Truck.sqf";
/*

mission_ReconVeh = compile preprocessFileLineNumbers "server\missions\sideMissions\mission_ReconVeh.sqf";
*/

//Factory Compiles
createMissionLocation = compile preprocessFileLineNumbers "server\missions\factoryMethods\createMissionLocation.sqf";
createClientMarker = compile preprocessFileLineNumbers "server\missions\factoryMethods\createClientMarker.sqf";
createWaitCondition = compile preprocessFileLineNumbers "server\missions\factoryMethods\createWaitCondition.sqf";
deleteClientMarker = compile preprocessFileLineNumbers "server\missions\factoryMethods\deleteClientMarker.sqf";
createRandomSoldier = compile preprocessFileLineNumbers "server\missions\factoryMethods\createUnits\createRandomSoldier.sqf";
createRandomSoldierC = compile preprocessFileLineNumbers "server\missions\factoryMethods\createUnits\createRandomSoldierC.sqf";
createSmallGroup = compile preprocessFileLineNumbers "server\missions\factoryMethods\createUnits\smallGroup.sqf";
createSmallDivers = compile preprocessFileLineNumbers "server\missions\factoryMethods\createUnits\smallDivers.sqf";
createLargeDivers = compile preprocessFileLineNumbers "server\missions\factoryMethods\createUnits\largeDivers.sqf";
createMidGroup = compile preprocessFileLineNumbers "server\missions\factoryMethods\createUnits\midGroup.sqf";
createLargeGroup = compile preprocessFileLineNumbers "server\missions\factoryMethods\createUnits\largeGroup.sqf";
createMissionVehicle = compile preprocessFileLineNumbers "server\missions\factoryMethods\createMissionVehicle.sqf";
createMissionVehicle2 = compile preprocessFileLineNumbers "server\missions\factoryMethods\createMissionVehicle2.sqf";
createMissionVehicleWL = compile preprocessFileLineNumbers "server\missions\factoryMethods\createMissionVehicleWithLog.sqf";
createSupplyDrop = compile preprocessFileLineNumbers "server\missions\factoryMethods\createSupplyDrop.sqf";
createCargoItem = compile preprocessFileLineNumbers "server\missions\factoryMethods\createCargoItem.sqf";
defendArea = compile preprocessFileLineNumbers "server\functions\defendArea.sqf";
defendArea2 = compile preprocessFileLineNumbers "server\functions\defendArea2.sqf";
defendArea3 = compile preprocessFileLineNumbers "server\functions\defendArea3.sqf";
checkHackedVehicles = compileFinal preprocessFileLineNumbers "server\functions\checkHackedVehicles.sqf";
findClientPlayer = compileFinal preprocessFileLineNumbers "server\functions\findClientPlayer.sqf";

//Spawning Compiles
randomWeapons = compile preprocessFileLineNumbers "server\spawning\randomWeapon.sqf";
vehicleCreation = compile preprocessFileLineNumbers "server\spawning\vehicleCreation.sqf";
objectCreation = compile preprocessFileLineNumbers "server\spawning\objectCreation.sqf";
// staticGunCreation = compile preprocessFileLineNumbers "server\spawning\staticGunCreation.sqf";
staticHeliCreation = compile preprocessFileLineNumbers "server\spawning\staticHeliCreation.sqf";
boatCreation = compile preprocessFileLineNumbers "server\spawning\boatCreation.sqf";
fn_refillbox = compile preprocessFileLineNumbers "server\functions\fn_refillbox.sqf";
cleanVehicleWreck = compile preprocessFileLineNumbers "server\functions\cleanVehicleWreck.sqf";

//Player Management
server_playerDied = compile preprocessFileLineNumbers "server\functions\serverPlayerDied.sqf";

if (isNil "TPG_fnc_MP") then { TPG_fnc_MP = compileFinal str BIS_fnc_MP };
if (isNil "TPG_fnc_MPexec") then { TPG_fnc_MPexec = compileFinal str BIS_fnc_MPexec }; 
