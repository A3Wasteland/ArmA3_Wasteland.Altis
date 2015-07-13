// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_secureSetVar.sqf
//	@file Author: AgentRev

private ["_obj", "_arr"];
_obj = _this select 0;
_arr = _this select 1;

if (!isNil "A3W_hcObjSaving_isClient") exitWith // HC to server
{
	_obj setVariable [_arr select 0, _arr select 1, false]; // temp local change

	pvar_hcObjSaving_setVariable = [call A3W_hcObjSaving_serverKey, _obj, _arr];
	publicVariableServer "pvar_hcObjSaving_setVariable";
};

_obj setVariable _arr;
