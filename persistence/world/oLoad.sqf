// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.2
//	@file Name: oLoad.sqf
//	@file Author: micovery
//	@file Description: object loading

diag_log "oLoad.sqf loading ...";
if (!isServer) exitWith {};


#include "oFunctions.sqf"

init(_oScope, "Objects" call PDB_objectFileName);

def(_oIds);
_oIds = [_oScope] call o_loadObjects;
[_oScope] call o_loadInfo;
[_oScope] spawn o_saveLoop;


diag_log "oLoad.sqf loading complete";

(_oIds)