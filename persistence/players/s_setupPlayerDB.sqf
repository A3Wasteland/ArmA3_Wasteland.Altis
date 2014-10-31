// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: s_setupPlayerDB.sqf
//	@file Author: AgentRev, micovery

if (!isServer) exitWith {};

diag_log "Loading s_setupPlayerDB ...";

#include "sFunctions.sqf"

fn_deletePlayerSave = {
  init(_scope,_this call PDB_playerFileName);
  [_scope, "PlayerSave", nil] call stats_set;
};


"deletePlayerData" addPublicVariableEventHandler {
  _player = _this select 1;
  (getPlayerUID _player) call fn_deletePlayerSave;
};


[format["%1Messages", PDB_ServerID]] spawn s_messageLoop;
[] spawn p_saveLoop;

diag_log "Loading s_setupPlayerDB complete";
