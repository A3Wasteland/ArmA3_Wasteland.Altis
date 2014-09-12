//	@file Name: setupServerPVars.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse, AgentRev, MercyfulFate

pvar_teamSwitchList = [];
publicVariable "pvar_teamSwitchList";
pvar_teamKillList = [];
publicVariable "pvar_teamKillList";
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
"pvar_convertTerritoryOwner" addPublicVariableEventHandler { (_this select 1) call convertTerritoryOwner };
"pvar_enableSimulationGlobal" addPublicVariableEventHandler { (_this select 1) call fn_enableSimulationGlobal };
"pvar_handleCorpseOnLeave" addPublicVariableEventHandler { (_this select 1) call handleCorpseOnLeave };
"pvar_parachuteLiftedVehicle" addPublicVariableEventHandler { (_this select 1) spawn parachuteLiftedVehicle };
"pvar_spawnStoreObject" addPublicVariableEventHandler { (_this select 1) call spawnStoreObject };
