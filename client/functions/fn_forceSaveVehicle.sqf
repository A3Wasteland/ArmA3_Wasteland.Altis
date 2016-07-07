// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_forceSaveVehicle.sqf
//	@file Author: AgentRev

params [["_veh",objNull,[objNull]]];

if (_veh getVariable ["A3W_skipAutoSave", false]) then
{
	_veh setVariable ["A3W_skipAutoSave", nil, true];
};

pvar_manualVehicleSave = netId _veh;
publicVariableServer "pvar_manualVehicleSave";
