// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: oSave.sqf
//	@file Author: AgentRev, [GoT] JoSchaap

params ["_objectSavingOn", "_vehicleSavingOn", "_mineSavingOn"];

#include "oSaveSetup.sqf"

// the profileNamespace A3W_objectIDs and A3W_vehicleIDs thing is if the HC crashes and is restarted during the server session, then the ID arrays can be restored

if (_isHC) then
{
	if (isNil "A3W_objectIDs") then { A3W_objectIDs = [] };
	if (isNil "A3W_vehicleIDs") then { A3W_vehicleIDs = [] };
	if (isNil "A3W_mineIDs") then { A3W_mineIDs = [] };

	if (!isNil "A3W_hcObjSaving_mergeIDs") then
	{
		_objVar = "A3W_objectIDs" call _hcProfileVarName;
		_objIDs = if (!isNil "_objVar") then { profileNamespace getVariable [_objVar, []] } else { [] };
		{ A3W_objectIDs pushBackUnique _x } forEach _objIDs;
		"A3W_objectIDs" call _hcSaveProfileVar;

		_vehVar = "A3W_vehicleIDs" call _hcProfileVarName;
		_vehIDs = if (!isNil "_vehVar") then { profileNamespace getVariable [_vehVar, []] } else { [] };
		{ A3W_vehicleIDs pushBackUnique _x } forEach _vehIDs;
		"A3W_vehicleIDs" call _hcSaveProfileVar;

		_mineVar = "A3W_mineIDs" call _hcProfileVarName;
		_mineIDs = if (!isNil "_mineVar") then { profileNamespace getVariable [_mineVar, []] } else { [] };
		{ A3W_mineIDs pushBackUnique _x } forEach _mineIDs;
		"A3W_mineIDs" call _hcSaveProfileVar;
	};
};

while {true} do fn_oSaveOnce;
