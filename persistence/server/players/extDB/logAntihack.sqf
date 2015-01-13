// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: logAntihack.sqf
//	@file Author: AgentRev

#define FILTERED_CHARS [58] // colon

private ["_playerUID", "_playerName", "_hackType", "_hackValue"];
_playerUID = _this select 0;
_playerName = _this select 1;
_hackType = _this select 2;
_hackValue = _this select 3;

[format ["addAntihackLog:%1:%2:%3:%4:%5", call A3W_extDB_ServerID, toString (toArray _playerName - FILTERED_CHARS), _playerUID, _hackType, _hackValue]] call extDB_Database_async;
