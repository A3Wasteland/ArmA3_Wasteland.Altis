// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: postMineSave.sqf
//	@file Author: AgentRev

params ["", "_mineCount"];
private ["_oldMineCount", "_i"];

_fileName = "Mines" call PDB_objectFileName;
_oldMineCount = [_fileName, "Info", "MineCount", "NUMBER"] call PDB_read;

[_fileName, "Info", "MineCount", _mineCount] call PDB_write;

// Reverse-delete old mines
if (_oldMineCount > _mineCount) then
{
	for "_i" from _oldMineCount to (_mineCount + 1) step -1 do
	{
		[_fileName, format ["Mine%1", _i], false] call PDB_deleteSection;
	};
};

if (call A3W_savingMethod == "profile") then
{
	saveProfileNamespace; // this line is crucial to ensure all profileNamespace data submitted to the server is saved
	diag_log "A3W - profileNamespace saved";
};
