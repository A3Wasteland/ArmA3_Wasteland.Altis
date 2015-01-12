// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: init.sqf
//	@file Author: Torndeco, AgentRev

#define MIN_DB_VERSION 2.03

private ["_return", "_result", "_setupDir", "_serverID", "_env", "_mapID"];

// uiNamespace is persistent across mission restarts (but not game restarts)
_return = if (isNil {uiNamespace getVariable "A3W_extDB_ID"}) then
{
	diag_log "[extDB] Startup...";

	_result = call compile ("extDB" callExtension format ["9:DATABASE:%1", call A3W_extDB_ConfigName]);
	if (_result select 0 == 0 && {_result select 1 != "Already Connected to Database"}) exitWith { diag_log format ["[extDB] ### Database error! %1", _result]; false };

	diag_log "[extDB] Connected to database";

	A3W_extDB_ID = compileFinal str floor random 999999;
	A3W_extDB_miscID = compileFinal str (call A3W_extDB_ID + 1);

	_result = call compile ("extDB" callExtension format ["9:ADD:DB_CUSTOM_V3:%1:%2", call A3W_extDB_ID, call A3W_extDB_IniName]);
	if (_result select 0 == 0) exitWith { diag_log format ["[extDB] ### DB_CUSTOM_V3 protocol error! %1", _result]; false };

	diag_log "[extDB] Initialized DB_CUSTOM_V3 protocol";

	_result = call compile ("extDB" callExtension format ["9:ADD:MISC:%1", call A3W_extDB_miscID]);
	if (_result select 0 == 0) exitWith { diag_log format ["[extDB] ### MISC protocol error! %1", _result]; false };

	diag_log "[extDB] Initialized MISC protocol";

	uiNamespace setVariable ["A3W_extDB_ID", call A3W_extDB_ID];
	uiNamespace setVariable ["A3W_extDB_miscID", call A3W_extDB_miscID];
	true
}
else
{
	A3W_extDB_ID = compileFinal str (uiNamespace getVariable "A3W_extDB_ID");
	A3W_extDB_miscID = compileFinal str (uiNamespace getVariable "A3W_extDB_miscID");
	diag_log "[extDB] Connection and protocols already initialized!";
	true
};

if (_return) then
{
	scopeName "extDB_envSetup";
	diag_log "[extDB] Environment setup...";

	_setupDir = "persistence\server\setup\extDB";

	if  (["A3W_extDB_Debug"] call isConfigOn) then
	{
		_result = call compile ("extDB" callExtension format ["9:ADD:DB_CUSTOM_V3:%1:%2", call A3W_extDB_ID, call A3W_extDB_IniName]);
		if (_result select 0 == 0) then { diag_log format ["[extDB] ### DB_CUSTOM_V3 protocol error! %1", _result] };

		extDB_Database_async = [_setupDir, "async_database_debug.sqf"] call mf_compile;
		extDB_Misc_async = [_setupDir, "async_misc_debug.sqf"] call mf_compile;
		diag_log "[extDB] Debug output enabled";
	}
	else
	{
		"extDB" callExtension "9:LOCK";
		diag_log "[extDB] Locked";

		extDB_Database_async = [_setupDir, "async_database.sqf"] call mf_compile;
		extDB_Misc_async = [_setupDir, "async_misc.sqf"] call mf_compile;
	};

	extDB_pairsToSQL = [_setupDir, "fn_pairsToSQL.sqf"] call mf_compile;

	_result = (["getDBVersion", 2] call extDB_Database_async) select 0;
	if (_result < MIN_DB_VERSION) exitWith { diag_log format ["[extDB] ### Outdated A3Wasteland database version! %1 - min: %2", _result, MIN_DB_VERSION]; _return = false };

	_serverID = ["A3W_extDB_ServerID", 1] call getPublicVar;
	A3W_extDB_ServerID = compileFinal str _serverID;
	publicVariable "A3W_extDB_ServerID";

	_result = ([format ["checkServerInstance:%1", _serverID], 2] call extDB_Database_async) select 0;
	if (!_result) then
	{
		[format ["insertServerInstance:%1", _serverID], 2] call extDB_Database_async;

		_result = ([format ["checkServerInstance:%1", _serverID], 2] call extDB_Database_async) select 0;
		if (!_result) then
		{
			diag_log format ["[extDB] ### Unable to create ServerInstance with ServerID %1", _serverID];
			_return = false;
			breakOut "extDB_envSetup";
		};
	};

	_env = ["A3W_extDB_Environment", "normal"] call getPublicVar;

	_mapID = ([format ["getServerMapID:%1:%2", worldName, _env], 2] call extDB_Database_async) select 0;
	if (_mapID == 0) then
	{
		[format ["insertServerMap:%1:%2", worldName, _env], 2] call extDB_Database_async;

		_mapID = ([format ["getServerMapID:%1:%2", worldName, _env], 2] call extDB_Database_async) select 0;
		if (_mapID == 0) then
		{
			diag_log format ["[extDB] ### Unable to create ServerMap with WorldName '%1'", worldName];
			_return = false;
			breakOut "extDB_envSetup";
		};
	};

	A3W_extDB_MapID = compileFinal str _mapID;
	_return = true;
};

if (!_return) exitWith
{
	diag_log "[extDB] ### ERROR - Startup aborted";
	false
};

diag_log "[extDB] Startup complete!";
true
