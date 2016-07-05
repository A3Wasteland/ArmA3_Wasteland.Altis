// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_forceSaveObject.sqf
//	@file Author: AgentRev

params [["_obj",objNull,[objNull]], ["_player",player,[objNull]]];

if (_obj isKindOf "StaticWeapon" && _obj getVariable ["ownerUID",""] == "") then
{
	_obj setVariable ["ownerUID", getPlayerUID _player, true];
};

if (_obj getVariable ["A3W_skipAutoSave", false]) then
{
	_obj setVariable ["A3W_skipAutoSave", nil, true];
};

pvar_manualObjectSave = netId _obj;
publicVariableServer "pvar_manualObjectSave";
