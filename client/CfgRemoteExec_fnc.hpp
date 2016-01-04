// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: CfgRemoteExec_fnc.hpp
//	@file Author: AgentRev

// remoteExec & BIS_fnc_MP functions whitelist (client only, server calls are not filtered)

// BIS
class BIS_fnc_effectKilledAirDestruction {};
class BIS_fnc_effectKilledSecondaries {};
class BIS_fnc_objectVar {};

// do NOT whitelist BIS_fnc_execVM or BIS_fnc_spawn, it will allow exploits!

// A3W official
class A3W_fnc_adminMenuLog { allowedTargets = 2; };
class A3W_fnc_chatBroadcast {};
class A3W_fnc_checkHackedVehicles { allowedTargets = 2; };
class A3W_fnc_copilotTakeControl {};
class A3W_fnc_flagHandler { allowedTargets = 2; };
class A3W_fnc_logMemAnomaly { allowedTargets = 2; };
class A3W_fnc_pushVehicle {};
class A3W_fnc_titleTextMessage {};
class A3W_fnc_towingHelper {};

// A3W third-party
class A3W_fnc_addMagazineTurret {};
class A3W_fnc_addMagazineTurretBaheli {};
class A3W_fnc_addMagazineTurretBcas {};
class A3W_fnc_addMagazineTurretHorca {};
class A3W_fnc_addMagazineTurretIcas {};
class A3W_fnc_addMagazineTurretLheli {};
class A3W_fnc_addMagazineTurretMortar {};
class A3W_fnc_addMagazineTurretOaheli {};
class A3W_fnc_addMagazineTurretOcas {};
class A3W_fnc_addMagazineTurretUav2 {};
class A3W_fnc_hideObjectGlobal {};
class A3W_fnc_lock {};
class A3W_fnc_removeMagazinesTurret {};
class A3W_fnc_setLockState {};
class A3W_fnc_setVectorUpAndDir { jip = 1; };
class A3W_fnc_setVehicleAmmoDef {};
class A3W_fnc_unflip {};

// Other third-party
class APOC_srv_startAirdrop { allowedTargets = 2; };
class JTS_FNC_SENT {};
