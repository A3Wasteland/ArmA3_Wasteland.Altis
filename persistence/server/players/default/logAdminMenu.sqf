// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: logAdminMenu.sqf
//	@file Author: AgentRev

private ["_playerUID", "_playerName", "_actionType", "_actionValue"];
_playerUID = _this select 0;
_playerName = _this select 1;
_actionType = _this select 2;
_actionValue = _this select 3;

if (["A3W_savingMethod", "profile"] call getPublicVar == "iniDB") then
{
	["AdminLog" call PDB_objectFileName, "AdminLog", _playerUID, [_playerName, _actionType, _actionValue]] call iniDB_write;
};
