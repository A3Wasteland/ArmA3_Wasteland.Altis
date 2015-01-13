// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: logAntihack.sqf
//	@file Author: AgentRev

private ["_playerUID", "_playerName", "_hackType", "_hackValue"];
_playerUID = _this select 0;
_playerName = _this select 1;
_hackType = _this select 2;
_hackValue = _this select 3;

if (["A3W_savingMethod", "profile"] call getPublicVar == "iniDB") then
{
	["Hackers" call PDB_playerFileName, "Hackers", _playerUID, [_playerName, _hackType, _hackValue]] call iniDB_write;
};
