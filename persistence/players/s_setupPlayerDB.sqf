//  @file Name: s_setupPlayerDB.sqf
//  @file Author: AgentRev

if (!isServer) exitWith {};

diag_log "Loading s_setupPlayerDB ...";

#include "macro.h"
fn_deletePlayerSave = "persistence\players\s_deletePlayerSave.sqf" call mf_compile;
fn_loadAccount = "persistence\players\s_loadAccount.sqf" call mf_compile;

"savePlayerData" addPublicVariableEventHandler
{
  ARGVX3(1,_this,[]);
  ARGVX3(0,_UID,"");
  ARGVX3(1,_info,[]);
  ARGVX3(2,_data,[]);
  ARGVX3(3,_player,objNull);
  
  if (!alive _player) exitWith {
    _UID call fn_deletePlayerSave;
  };

  if (alive _player && {_player getVariable ["FAR_isUnconscious", 0] == 0})  exitWith {
    init(_scope,_UID call PDB_playerFileName);
	[_scope, "PlayerInfo", _info] call stats_hash_set;
	[_scope, "PlayerSave", _data] call stats_hash_set;
  };
};

"requestPlayerData" addPublicVariableEventHandler
{
  _player = _this select 1;
  _UID = getPlayerUID _player;

  if ((_UID call PDB_playerFileName) call PDB_exists) then // iniDB_exists
  {
    applyPlayerData = _UID call fn_loadAccount;
  }
  else
  {
    applyPlayerData = [];
  };

  (owner _player) publicVariableClient "applyPlayerData";
};

"deletePlayerData" addPublicVariableEventHandler
{
  _player = _this select 1;
  (getPlayerUID _player) call fn_deletePlayerSave;
};

diag_log "Loading s_setupPlayerDB complete";
