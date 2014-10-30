//	@file Version: 0.1
//	@file Name: oLoad.sqf
//	@file Author: micovery
//	@file Description: object loading

diag_log "oLoad.sqf loading ...";
if (!isServer) exitWith {};


#include "oFunctions.sqf"

init(_oScope, "Objects" call PDB_objectFileName);

[_oScope] call o_loadObjects;
[_oScope] call o_loadInfo;
[_oScope] spawn o_saveLoop;


diag_log "oLoad.sqf loading complete";