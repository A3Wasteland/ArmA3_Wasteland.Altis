// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: tLoad.sqf
//	@file Author: micovery
//	@file Description: time loading

diag_log "tLoad.sqf loading ...";
if (!isServer) exitWith {};

call compile preprocessFileLineNumbers "persistence\lib\shFunctions.sqf";
call compile preprocessFileLineNumbers "persistence\world\tFunctions.sqf";

#include "macro.h"


init(_tScope, "Time" call PDB_ServerTimeFileName);
[_tScope] call t_loadTime;

[_tScope] spawn t_saveLoop;