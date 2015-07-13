// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_secureDelObj.sqf
//	@file Author: AgentRev

if (!isNil "A3W_hcObjSaving_isClient") exitWith // HC to server
{
	pvar_hcObjSaving_deleteVehicle = [call A3W_hcObjSaving_serverKey, _this];
	publicVariableServer "pvar_hcObjSaving_deleteVehicle";
};

deleteVehicle _this;
