// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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
currentDate = [];
publicVariable "currentDate";
currentInvites = [];
publicVariable "currentInvites";

#define PVAL (_this select 1)

{ (_x select 0) addPublicVariableEventHandler (_x select 1) } forEach
[
	["pvar_removeNegativeScore", { PVAL call removeNegativeScore }],
	["pvar_convertTerritoryOwner", { PVAL call convertTerritoryOwner }],
	["pvar_enableSimulationGlobal", { PVAL call fn_enableSimulationGlobal }],
	["pvar_enableSimulationServer", { PVAL call fn_enableSimulationServer }],
	["pvar_parachuteLiftedVehicle", { PVAL spawn parachuteLiftedVehicle }],
	["pvar_spawnStoreObject", { PVAL call spawnStoreObject }],
	["pvar_processGroupInvite", { PVAL call processGroupInvite }],
	["pvar_punishTeamKiller", { PVAL call punishTeamKiller }],
	["pvar_teamSwitchLock", { PVAL call teamSwitchLock }],
	["pvar_teamSwitchUnlock", { PVAL call teamSwitchUnlock }],
	["pvar_teamKillUnlock", { PVAL call teamKillUnlock }],
	["pvar_updatePlayerScore", { PVAL call fn_updatePlayerScore }],
	["pvar_manualObjectSave", { if (!isNil "fn_manualObjectSave") then { PVAL call fn_manualObjectSave } }],
	["pvar_manualObjectDelete", { if (!isNil "fn_manualObjectDelete") then { PVAL call fn_manualObjectDelete } }],
	["pvar_manualVehicleSave", { if (!isNil "fn_manualVehicleSave") then { PVAL call fn_manualVehicleSave } }],
	["pvar_waitUntilBagTaken", { PVAL spawn waitUntilBagTaken }],
	["pvar_dropPlayerItems", { PVAL spawn dropPlayerItems }]
];
