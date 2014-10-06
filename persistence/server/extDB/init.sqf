private ["_result"];

_return = false;

_result = call compile ("extDB" callExtension "9:DATABASE:A3Wasteland");
if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Database: %1", _result]; false};
diag_log "extDB: Connected to Database";

server_extDB_DB_CUSTOM_V3_ID = compileFinal str(round(random(999999)));

_result = call compile ("extDB" callExtension ("9:ADD:DB_CUSTOM_V3:" + str(call server_extDB_DB_CUSTOM_V3_ID) + ":a3wasteland"));
if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Database Setup: %1", _result]; false};
diag_log "extDB: Initalized DB_Custom_V3 Protocol";

"extDB" callExtension "9:LOCK";
diag_log "extDB: Locked";


extDB_async = "persistence\server\extDB\async.sqf" call mf_compile;

/*
_result = ["checkDBVersion",2] call extDB_async;
_return = false;
if (parseNumber _result == 1) then
{
	_return = true;
};
*/
_return = true;
_return