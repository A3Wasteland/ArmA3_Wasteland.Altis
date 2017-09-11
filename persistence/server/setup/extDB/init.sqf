// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: init.sqf
//	@file Author: Torndeco, AgentRev

#define MIN_DB_VERSION 2.06

private ["_lock", "_return", "_result", "_setupDir", "_serverID", "_env", "_mapID"];
_lock = (["A3W_extDB_Lock", 1] call getPublicVar != 0);

// uiNamespace is persistent across mission restarts (but not game restarts)

 _return = if (isNil {uiNamespace getVariable "A3W_extDB_databaseID"} || !_lock) then
{
	diag_log "[extDB3] Startup...";

	if (isNil {uiNamespace getVariable "A3W_extDB_databaseID"}) then
	{
		_result = parseSimpleArray ("extDB3" callExtension format ["9:ADD_DATABASE:%1", call A3W_extDB_ConfigName]);
		if (_result select 0 == 0) exitWith { diag_log format ["[extDB3] ███ Database error! %1", _result]; false };
	};

	A3W_extDB_databaseID = compileFinal str floor random 999997;
	A3W_extDB_miscID = compileFinal str (call A3W_extDB_databaseID + 1);

	_result = parseSimpleArray ("extDB3" callExtension format ["9:ADD_DATABASE_PROTOCOL:%1:SQL_CUSTOM:%2:%3", call A3W_extDB_ConfigName, call A3W_extDB_databaseID, call A3W_extDB_IniName]);
	if (_result select 0 == 0) exitWith { diag_log format ["[extDB3] ███ SQL_CUSTOM Protocol error! %1", _result]; false };
	diag_log "[extDB3] Initialized SQL_CUSTOM protocol";

	if (["A3W_extDB_Misc"] call isConfigOn) then
	{
		_result = parseSimpleArray ("extDB3" callExtension format ["9:ADD_PROTOCOL:MISC:%1", call A3W_extDB_miscID]);
		if (_result select 0 == 0) exitWith { diag_log format ["[extDB3] ███ MISC Protocol error! %1", _result]; false };
		diag_log "[extDB3] Initialized MISC protocol";
	};

	uiNamespace setVariable ["A3W_extDB_databaseID", call A3W_extDB_databaseID];
	uiNamespace setVariable ["A3W_extDB_miscID", call A3W_extDB_miscID];
	true
}
else
{
	A3W_extDB_databaseID = compileFinal str (uiNamespace getVariable "A3W_extDB_databaseID");
	A3W_extDB_miscID = compileFinal str (uiNamespace getVariable "A3W_extDB_miscID");
	diag_log "[extDB3] Connection and protocols already initialized!";
	true
};

if (_return) then
{
	scopeName "extDB_envSetup";
	diag_log "[extDB3] Environment setup...";

	_setupDir = "persistence\server\setup\extDB";

	if (_lock) then
	{
		"extDB3" callExtension "9:LOCK";
		diag_log "[extDB3] Locked";
	};

	extDB_pairsToSQL = [_setupDir, "fn_pairsToSQL.sqf"] call mf_compile;
	extDB_Database_async = [_setupDir, "async_database.sqf"] call mf_compile;

	if (["A3W_extDB_Misc"] call isConfigOn) then
	{
		extDB_Misc_async = [_setupDir, "async_misc.sqf"] call mf_compile;
	};

	_result = (["getDBVersion", 2] call extDB_Database_async) select 0;
	if (_result < MIN_DB_VERSION) exitWith { diag_log format ["[extDB3] ███ Outdated A3Wasteland database version! %1 - min: %2", _result, MIN_DB_VERSION]; _return = false };

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
			diag_log format ["[extDB3] ███ Unable to create ServerInstance with ServerID %1", _serverID];
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
			diag_log format ["[extDB3] ███ Unable to create ServerMap with WorldName '%1'", worldName];
			_return = false;
			breakOut "extDB_envSetup";
		};
	};

	A3W_extDB_MapID = compileFinal str _mapID;
	_return = true;
};

if (!_return) exitWith
{
	diag_log "[extDB3] ███ ERROR - Startup aborted";
	false
};

diag_log "[extDB3] Startup complete!";
true
