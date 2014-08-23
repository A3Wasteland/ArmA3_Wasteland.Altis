//	@file Name: setupClientPVars.sqf
//	@file Author: AgentRev

#define PVAR_TARGET(CODE) _params = _this select 1; \
if ((_params select 0) call isPVarTarget) then { _value = _params select 1; CODE };


"currentDate" addPublicVariableEventHandler {[] spawn timeSync};
"messageSystem" addPublicVariableEventHandler {[] spawn serverMessage};
"clientMissionMarkers" addPublicVariableEventHandler {[] spawn updateMissionsMarkers};
// "clientRadarMarkers" addPublicVariableEventHandler {[] spawn updateRadarMarkers};
"pvar_teamKillList" addPublicVariableEventHandler {[] spawn updateTeamKiller};
"publicVar_teamkillMessage" addPublicVariableEventHandler {if (local (_this select 1)) then { [] spawn teamkillMessage }};

"pvar_territoryActivityHandler" addPublicVariableEventHandler { PVAR_TARGET(_value call territoryActivityHandler) };
"pvar_updateTerritoryMarkers" addPublicVariableEventHandler { PVAR_TARGET(_value call updateTerritoryMarkers) };
