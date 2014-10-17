//	@file Name: setupServerPVars.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse, AgentRev, MercyfulFate

pvar_teamSwitchList = [];
publicVariable "pvar_teamSwitchList";
pvar_teamKillList = [];
publicVariable "pvar_teamKillList";
pvar_voiceBanPlayerArray = [];
publicVariable "pvar_voiceBanPlayerArray";
pvar_spawn_beacons = [];
publicVariable "pvar_spawn_beacons";
pvar_warchest_funds_east = 0;
publicVariable "pvar_warchest_funds_east";
pvar_warchest_funds_west = 0;
publicVariable "pvar_warchest_funds_west";
clientMissionMarkers = [];
publicVariable "clientMissionMarkers";
clientRadarMarkers = [];
publicVariable "clientRadarMarkers";
currentDate = [];
publicVariable "currentDate";
currentInvites = [];
publicVariable "currentInvites";

"itemsDroppedOnDeath" addPublicVariableEventHandler
{
	{
		if (!isNil "_x") then
		{
			(objectFromNetId _x) setVariable ["processedDeath", diag_tickTime];
		};
	} forEach (_this select 1);
};

"PlayerCDeath" addPublicVariableEventHandler { (_this select 1) call server_playerDied };
"pvar_removeNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore };
"pvar_convertTerritoryOwner" addPublicVariableEventHandler { (_this select 1) call convertTerritoryOwner };
"pvar_enableSimulationGlobal" addPublicVariableEventHandler { (_this select 1) call fn_enableSimulationGlobal };
"pvar_parachuteLiftedVehicle" addPublicVariableEventHandler { (_this select 1) spawn parachuteLiftedVehicle };
"pvar_spawnStoreObject" addPublicVariableEventHandler { (_this select 1) call spawnStoreObject };
"pvar_processGroupInvite" addPublicVariableEventHandler { (_this select 1) call processGroupInvite };
"pvar_processMoneyPickup" addPublicVariableEventHandler { (_this select 1) call processMoneyPickup };
"pvar_punishTeamKiller" addPublicVariableEventHandler { (_this select 1) call punishTeamKiller };
"pvar_teamSwitchLock" addPublicVariableEventHandler { (_this select 1) call teamSwitchLock };
"pvar_teamSwitchUnlock" addPublicVariableEventHandler { (_this select 1) call teamSwitchUnlock };
"pvar_teamKillUnlock" addPublicVariableEventHandler { (_this select 1) call teamKillUnlock };
