// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setTickTime.sqf
//	@file Author: AgentRev

private ["_obj", "_var"];
_obj = _this select 0;
_var = _this select 1;

_obj setVariable [_var, diag_tickTime];

if (isServer) then
{
	if (!isNil "A3W_hcObjSaving_unit" && {!isNull A3W_hcObjSaving_unit}) then // server to HC
	{
		A3W_hcObjSaving_setTickTime = [_obj, _var];
		(owner A3W_hcObjSaving_unit) publicVariableClient "A3W_hcObjSaving_setTickTime";
	};
}
else
{
	if (!isNil "A3W_hcObjSaving_isClient") then // HC to server
	{
		pvar_hcObjSaving_setTickTime = [call A3W_hcObjSaving_serverKey, _obj, _var];
		publicVariableServer "pvar_hcObjSaving_setTickTime";
	};
};
