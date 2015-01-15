// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: s_setupPlayerDB.sqf
//	@file Author: AgentRev, micovery

if (!isServer) exitWith {};


diag_log "Loading s_setupPlayerDB ...";

call compile preprocessFileLineNumbers "persistence\lib\shFunctions.sqf";
call compile preprocessFileLineNumbers "persistence\players\sFunctions.sqf";

#include "macro.h"


fn_deletePlayerSave = {
  init(_scope,_this call PDB_playerFileName);
  [_scope, ["PlayerSave", nil], ["PlayerSave_Altis", nil], ["PlayerSave_Stratis", nil]] spawn stats_set;
};


"deletePlayerData" addPublicVariableEventHandler {
  _player = _this select 1;
  (getPlayerUID _player) call fn_deletePlayerSave;
};


def(_mScope);
_mScope = "Messages" call PDB_messagesFileName;
[_mScope] spawn s_messageLoop;


def(_plScope);
_plScope = "PlayersList" call PDB_playersListFileName;
[_plScope] spawn pl_saveLoop;


[] spawn p_saveLoop;

diag_log "Loading s_setupPlayerDB complete";
