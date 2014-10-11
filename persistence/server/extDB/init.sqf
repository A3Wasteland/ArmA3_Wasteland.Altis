private ["_result"];

_return = false;

if ( isNil {uiNamespace getVariable "A3W_extDB_ID"}) then
{
	_result = "extDB" callExtension "9:VERSION";
	diag_log format ["extDB: Version: %1", _result];
	if(_result == "") exitWith {diag_log "extDB: Failed to Load"; false};
	if ((parseNumber _result) < 20) exitWith {diag_log "Error: extDB version 20 or Higher Required";};

	_result = call compile ("extDB" callExtension "9:DATABASE:A3Wasteland");
	if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Database: %1", _result]; false};
	diag_log "extDB: Connected to Database";

	A3W_extDB_ID = compileFinal str(round(random(999999)));
	A3W_extDB_miscID = compileFinal str ((call(A3W_extDB_ID)) + 1);

	_result = call compile ("extDB" callExtension ("9:ADD:DB_CUSTOM_V3:" + str(call A3W_extDB_ID) + ":a3wasteland"));
	if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Database Setup: %1", _result]; false};
	diag_log "extDB: Initalized DB_Custom_V3 Protocol";

	_result = call compile ("extDB" callExtension ("9:ADD:MISC:" + str(call A3W_extDB_miscID)));
	if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Misc Setup: %1", _result]; false};
	diag_log "extDB: Initalized Misc Protocol";

	"extDB" callExtension "9:LOCK";
	diag_log "extDB: Locked";

	uiNamespace setVariable ["A3W_extDB_ID", str(call(A3W_extDB_ID))];
	uiNamespace setVariable ["A3W_extDB_miscID", str(call(A3W_extDB_miscID))];

	if  (["A3W_extDB_Debug"] call isConfigOn) then
	{
		extDB_Database_async = "persistence\server\extDB\async_database_debug.sqf" call mf_compile;
		extDB_Misc_async = "persistence\server\extDB\async_misc_debug.sqf" call mf_compile;
		diag_log "extDB: Debug Output Enabled";
	}
	else
	{
		extDB_Database_async = "persistence\server\extDB\async_database.sqf" call mf_compile;
		extDB_Misc_async = "persistence\server\extDB\async_misc.sqf" call mf_compile;
	};

	_return = false;
	_result = (["checkDBVersion",2] call extDB_Database_async) select 0;
	_dbVersion = (["getDBVersion",2] call extDB_Database_async) select 0;
	_serverID_exists = ([format["existServer:%1", call(A3W_extDB_ServerID)],2] call extDB_Database_async) select 0;

	if (!_result) exitWith {
		diag_log "extDB: Error Incompatiable DB_CUSTOM File";
		false
	};
	if (_dbVersion != 1) exitWith {
		diag_log "extDB: Error Wrong A3Wasteland Database Version";
		false
	};
	if (!_serverID_exists) exitWith {
		diag_log format ["extDB: ServerID %1 doesn't exist in Database", call(A3W_extDB_ServerID)];
		false
	};

	_return = true;
}
else
{
	A3W_extDB_ID = compileFinal str(uiNamespace getVariable "A3W_extDB_ID");
	A3W_extDB_miscID = compileFinal str(uiNamespace getVariable "A3W_extDB_miscID");
	diag_log "extDB: Already Setup";
	_return = true;
};

_return