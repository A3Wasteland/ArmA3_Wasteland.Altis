// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: deletePlayerSave.sqf
//	@file Author: AgentRev

if (["A3W_extDB_playerSaveCrossMap"] call isConfigOn) then
{
	[format ["deletePlayerSaveXMap:%1:%2", _this, ["A3W_extDB_Environment", "normal"] call getPublicVar]] call extDB_Database_async;
}
else
{
	[format ["deletePlayerSave:%1:%2", _this, call A3W_extDB_MapID]] call extDB_Database_async;
};
