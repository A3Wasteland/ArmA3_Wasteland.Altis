// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setupClientPVars.sqf
//	@file Author: AgentRev

#define PVAL (_this select 1)
#define PVAR_TARGET(CODE) _params = PVAL; if ((_params select 0) call isPVarTarget) then { _value = _params select 1; CODE };

{ (_x select 0) addPublicVariableEventHandler (_x select 1) } forEach
[
	["currentDate", { [] spawn timeSync }],
	["messageSystem", { [] spawn serverMessage }],

	["pvar_warnTeamKiller", { PVAL spawn updateTeamKiller }],
	["pvar_groupNotify", { PVAL spawn groupNotify }],
	["pvar_disableCollision", { PVAL call fn_disableCollision }],
	["pvar_notifyClient", { PVAL spawn mf_notify_client }],
	["pvar_playerEventServer", { PVAL call playerEventServer }],
	["pvar_weaponDisassembledEvent", { PVAL spawn weaponDisassembledEvent }],
	["pvar_ejectCorpse", { PVAL spawn fn_ejectCorpse }],

	["pvar_territoryActivityHandler", { PVAR_TARGET(_value call A3W_fnc_territoryActivityHandler) }],
	["pvar_updateTerritoryMarkers", { PVAR_TARGET(_value call updateTerritoryMarkers) }]
];
