// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: updateStats.sqf
//	@file Author: AgentRev

private ["_UID", "_column", "_score"];
_UID = _this select 0;
_column = _this select 1;
_score = _this select 2;

[format ["insertOrUpdatePlayerStats:%1:%2:%3:%4:%5", _UID, call A3W_extDB_ServerID, call A3W_extDB_MapID, _column, _score]] call extDB_Database_async;
