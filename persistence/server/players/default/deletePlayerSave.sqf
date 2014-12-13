// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveAccount.sqf
//	@file Author: AgentRev

private ["_UID", "_info", "_data"];
_UID = _this select 0;
_info = _this select 1;
_data = _this select 2;

{
	[_UID call PDB_playerFileName, "PlayerInfo", _x select 0, _x select 1] call PDB_write; // iniDB_write
} forEach _info;

{
	[_UID call PDB_playerFileName, "PlayerSave", _x select 0, _x select 1] call PDB_write; // iniDB_write
} forEach _data;
