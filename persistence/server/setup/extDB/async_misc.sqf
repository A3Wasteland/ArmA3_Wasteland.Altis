/*
	File: async_misc.sqf
	Function: extDB_Database_async
	Author: Bryan "Tonic" Boardwine

	Description:
	Commits an asynchronous call to extDB
	Gets result via extDB  4:x + uses 5:x if message is Multi-Part

	Parameters:
		0: STRING (Query to be ran).
		1: INTEGER (1 = ASYNC + not return for update/insert, 2 = ASYNC + return for query's).
		3: BOOL (false to return a single array, true to return multiple entries mainly for garage).
*/

private["_queryStmt","_queryResult","_key","_mode","_return"];

_queryStmt = [_this,0,"",[""]] call BIS_fnc_param;
_mode = [_this,1,1,[0]] call BIS_fnc_param;
_multiarr = [_this,2,false,[false]] call BIS_fnc_param;

_key = "extDB" callExtension format["%1:%2:%3",_mode, (call A3W_extDB_miscID),_queryStmt];

if(_mode == 1) exitWith {true};

_key = call compile format["%1",_key];
_key = _key select 1;

sleep 0.01;

// Get Result via 4:x (single message return)  v19 and later
_queryResult = "";
_loop = true;
while{_loop} do
{
	_queryResult = "extDB" callExtension format["4:%1", _key];
	if (_queryResult == "[5]") then {
		// extDB returned that result is Multi-Part Message
		_queryResult = "";
		while{true} do {
			_pipe = "extDB" callExtension format["5:%1", _key];
			if(_pipe == "") exitWith {_loop = false};
			if(_pipe != "[3]") then {
				_queryResult = _queryResult + _pipe;
			} else {
				//diag_log format ["[extDB] Sleep [5]: %1", diag_tickTime];
				sleep 0.1;
			};
		};
	}
	else
	{
		if (_queryResult == "[3]") then
		{
			//diag_log format ["[extDB] Sleep [4]: %1", diag_tickTime];
			sleep 0.1;
		} else {
			_loop = false;
		};
	};
};

_queryResult = call compile _queryResult;


// Not needed, its SQF Code incase extDB ever returns error message i.e Database Died
if ((_queryResult select 0) == 0) exitWith {diag_log format ["[extDB] Error: %1", _queryResult]; []};
_queryResult = (_queryResult select 1);
if ((_queryResult select 0) == 0) exitWith {diag_log format ["[extDB] Protocol Error: %1", _queryResult]; []};
if(count (_queryResult select 1) == 0) exitWith {[]};
_return = (_queryResult select 1) select 0;
if(_multiarr) then {
	_return = (_queryResult select 1);
};
_return;