// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: s_deletePlayerSave.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private "_fileName";
_fileName = _this call PDB_playerFileName;

if (["A3W_savingMethod", 1] call getPublicVar == 2 && {parseNumber (call iniDB_version) < 1.2}) then
{
	// Required for iniDB v1.0
	_fileName call iniDB_delete;
}
else
{
	[_fileName, "PlayerSave"] call PDB_deleteSection;
};
