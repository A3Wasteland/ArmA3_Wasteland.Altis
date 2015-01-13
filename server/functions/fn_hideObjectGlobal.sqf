// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_hideObjectGlobal.sqf
//	@file Author: AgentRev

private ["_object", "_visible"];
_object = _this select 0;
_visible = _this select 1;

if (typeName _object == "STRING") then { _object = objectFromNetId _object };

if (isServer) then
{
	_object hideObjectGlobal _visible;
}
else
{
	_object hideObject _visible;
	pvar_hideObjectGlobal = [netId _object, _visible];
	publicVariableServer "pvar_hideObjectGlobal";
};
