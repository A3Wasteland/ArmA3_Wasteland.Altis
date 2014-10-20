//	@file Name: s_deletePlayerSave.sqf
//	@file Author: micovery

if (!isServer) exitWith {};
#include "macro.h"

init(_scope,_this call PDB_playerFileName);
[_scope] call stats_wipe;