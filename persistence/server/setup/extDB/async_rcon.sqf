/*
	File: async_database.sqf
	Function: extDB_Database_async
	Author: Bryan "Tonic" Boardwine

	Description:
	Commits an asynchronous call to extDB
	Gets result via extDB  4:x + uses 5:x if message is Multi-Part

	Parameters:
		0: STRING (Query to be ran).
		1: INTEGER (1 = ASYNC + not return for update/insert, 2 = ASYNC + return for query's).
		3: BOOL (False to return a single array, True to return multiple entries mainly for garage).
*/

private["_queryStmt","_queryResult","_key","_mode","_return","_loop"];

_tickTime = diag_tickTime;

_queryStmt = [_this,0,"",[""]] call BIS_fnc_param;
_mode = [_this,1,1,[0]] call BIS_fnc_param;
_multiarr = [_this,2,false,[false]] call BIS_fnc_param;

_key = "extDB2" callExtension format["%1:%2:%3",_mode, (call A3W_extDB_rconID), _queryStmt];

if(_mode == 1) exitWith {true};

_key = call compile format["%1",_key];
_key = _key select 1;

sleep 0.01;

_queryResult = "";
_loop = true;
while{_loop} do
{
	_queryResult = "extDB2" callExtension format["4:%1", _key];
	if (_queryResult == "[5]") then {
		// extDB2 returned that result is Multi-Part Message
		_queryResult = "";
		while{true} do {
			_pipe = "extDB2" callExtension format["5:%1", _key];
			if(_pipe == "") exitWith {_loop = false};
			_queryResult = _queryResult + _pipe;
		};
	}
	else
	{
		if (_queryResult == "[3]") then
		{
			diag_log format ["[extDB2] Sleep [4]: %1", diag_tickTime]; // Helps highlight if someone Queries are running slow
			sleep 0.1;
		} else {
			_loop = false;
		};
	};
};


_queryResult = call compile _queryResult;

// Not needed, its SQF Code incase extDB ever returns error message i.e Database Died
if ((_queryResult select 0) isEqualTo 0) exitWith {diag_log format ["[extDB2] ███ Protocol Error: %1", _queryResult]; []};
_return = (_queryResult select 1);

if(!_multiarr) then {
	_return = if (count _return > 0) then { _return select 0 } else { [] };
};

_return;