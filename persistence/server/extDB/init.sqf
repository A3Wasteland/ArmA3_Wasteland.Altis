private ["_result"];

_return = false;


if ( uiNamespace getVariable["A3W_extDB_DBid", -1]) then
{
	_result = call compile ("extDB" callExtension "9:DATABASE:A3Wasteland");
	if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Database: %1", _result]; false};
	diag_log "extDB: Connected to Database";

	A3W_extDB_DBid = compileFinal str(round(random(999999)));

	_result = call compile ("extDB" callExtension ("9:ADD:DB_CUSTOM_V3:" + str(call A3W_extDB_DBid) + ":a3wasteland"));
	if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Database Setup: %1", _result]; false};
	diag_log "extDB: Initalized DB_Custom_V3 Protocol";

	"extDB" callExtension "9:LOCK";
	diag_log "extDB: Locked";

	/*
	_result = ["checkDBVersion",2] call extDB_async;
	_return = false;
	if (parseNumber _result == 1) then
	{
		_return = true;
	};
	*/
	uiNamespace setVariable ["A3W_extDB_DBid", A3W_extDB_DBid];

	extDB_async = "persistence\server\extDB\async.sqf" call mf_compile;
	_return = true;
}
else
{
	A3W_extDB_DBid = compileFinal str(uiNamespace getVariable "A3W_extDB_DBid");
	diag_log "extDB: Already Setup";
	_return = true;
};

_return