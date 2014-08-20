//	@file Name: s_deletePlayerSave.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private "_fileName";
_fileName = _this call PDB_playerFileName;

if (parseNumber (call iniDB_version) >= 1.2) then
{
	[_fileName, "PlayerSave"] call iniDB_deleteSection;
}
else
{
	_fileName call iniDB_delete;
};
