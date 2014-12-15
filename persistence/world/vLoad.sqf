// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 0.1
//	@file Name: vLoad.sqf
//	@file Author: micovery
//	@file Description: vehicle loading

diag_log "vLoad.sqf loading ...";
if (!isServer) exitWith {};

#include "vFunctions.sqf"
  
init(_vScope, "Vehicles" call PDB_objectFileName);

def(_vIds);
_vIds = [_vScope] call v_loadVehicles;
[_vScope] spawn v_saveLoop;

diag_log "vLoad.sqf loading complete";

(_vIds)

