//	@file Version: 1.0
//	@file Name: s_loadAccount.sqf
//	@file Author: AgentRev, micovery
//	@file Created: 25/02/2014 22:21

if (!isServer) exitWith {};

#include "macro.h"
def(_copyPairs);
_copyPairs = {
  ARGVX3(0,_target,[]);
  ARGVX3(1,_source,[]);

  {
    _target pushBack _x;
  } forEach _source;
};


init(_UID,_this);
init(_data,[]);
init(_scope,_UID call PDB_playerFileName);

def(_allData);
_allData = [_scope, ["PlayerSave", nil], ["PlayerInfo", nil]] call stats_get;
init(_playerSave_pairs, [((_allData select 0) select 1)] call stats_hash_pairs);
init(_playerInfo_pairs, [((_allData select 1) select 1)] call stats_hash_pairs);
init(_saveValid,(count(_playerSave_pairs) > 0));

_data pushBack ["PlayerSaveValid", _saveValid];
[_data,_playerInfo_pairs] call _copyPairs;
[_data,_playerSave_pairs] call _copyPairs;

_data
