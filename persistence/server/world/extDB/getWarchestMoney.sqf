// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getWarchestMoney.sqf
//	@file Author: AgentRev

[format ["getWarchestMoney:%1", call A3W_extDB_ServerID], 2] call extDB_Database_async
