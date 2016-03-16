// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: logAdminMenu.sqf
//	@file Author: AgentRev

#define FILTERED_CHARS [58] // colon

private ["_playerUID", "_playerName", "_actionType", "_actionValue"];
_playerUID = _this select 0;
_playerName = _this select 1;
_actionType = _this select 2;
_actionValue = _this select 3;

if (_actionValue isEqualTo "") exitWith {};

if !(_actionValue isEqualType "") then { _actionValue = str _actionValue };

[format ["addAdminLog:%1:%2:%3:%4:%5", call A3W_extDB_ServerID, toString (toArray _playerName - FILTERED_CHARS), _playerUID, _actionType, toString (toArray _actionValue - FILTERED_CHARS)]] call extDB_Database_async;
