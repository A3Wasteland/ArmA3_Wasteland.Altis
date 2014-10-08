private ["_result"];

_return = false;


if ( uiNamespace getVariable["A3W_extDB_ID", -1]) then
{
	_result = call compile ("extDB" callExtension "9:DATABASE:A3Wasteland");
	if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Database: %1", _result]; false};
	diag_log "extDB: Connected to Database";

	A3W_extDB_ID = compileFinal str(round(random(999999)));
	A3W_extDB_miscID = (call(A3W_extDB_ID)) + 1;

	_result = call compile ("extDB" callExtension ("9:ADD:DB_CUSTOM_V3:" + str(call A3W_extDB_ID) + ":a3wasteland"));
	if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Database Setup: %1", _result]; false};
	diag_log "extDB: Initalized DB_Custom_V3 Protocol";

	_result = call compile ("extDB" callExtension ("9:ADD:MISC:" + str(call A3W_extDB_miscID)));
	if (_result select 0 == 0) exitWith {diag_log format ["extDB: Error Misc Setup: %1", _result]; false};
	diag_log "extDB: Initalized Misc Protocol";

	"extDB" callExtension "9:LOCK";
	diag_log "extDB: Locked";

	/*
	_result = ["checkDBVersion",2] call extDB_Database_async;
	_return = false;
	if (parseNumber _result == 1) then
	{
		_return = true;
	};
	*/
	uiNamespace setVariable ["A3W_extDB_ID", A3W_extDB_ID];
	uiNamespace setVariable ["A3W_extDB_miscID", A3W_extDB_miscID];

	extDB_Database_async = "persistence\server\extDB\async_database.sqf" call mf_compile;
	extDB_Misc_async = "persistence\server\extDB\async_misc.sqf" call mf_compile;
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