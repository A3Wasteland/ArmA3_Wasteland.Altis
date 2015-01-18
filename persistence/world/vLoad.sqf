// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 0.1
//	@file Name: vLoad.sqf
//	@file Author: micovery
//	@file Description: vehicle loading

diag_log "vLoad.sqf loading ...";
if (!isServer) exitWith {};

call compile preprocessFileLineNumbers "persistence\lib\shFunctions.sqf";
call compile preprocessFileLineNumbers "persistence\world\vFunctions.sqf";

#include "macro.h"
  
init(_vScope, "Vehicles" call PDB_vehicleFileName);

def(_vIds);
_vIds = [_vScope] call v_loadVehicles;
[_vScope] spawn v_saveLoop;

diag_log "vLoad.sqf loading complete";

(_vIds)

