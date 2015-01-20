// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_loopSpread.sqf
//	@file Author: AgentRev

private ["_code", "_array", "_interval", "_oldCount", "_totalTime", "_qtyPerFrame", "_forceNonScheduled", "_newCount", "_maxQtyPerFrame", "_i", "_jCount", "_callFSM", "_j"];
_code = _this select 0;
_array = _this select 1;
_interval = _this select 2;
_oldCount = if (count _this > 3) then { _this select 3 } else { 0 };
_totalTime = if (count _this > 4) then { _this select 4 } else { 0 };
_qtyPerFrame = if (count _this > 5) then { _this select 5 } else { 10 };
_forceNonScheduled = if (count _this > 6) then { _this select 6 } else { false };

_newCount = count _array;

_maxQtyPerFrame = if (count _this > 7) then { _this select 7 } else { _newCount };

// Ajusting the _qtyPerFrame so as to spread processing as evenly as possible over the loop interval
if (_oldCount > 0 && _totalTime > 0) then
{
	_qtyPerFrame = _maxQtyPerFrame min ceil ((_qtyPerFrame / (_interval / _totalTime)) * (_newCount / _oldCount));
};

for "_i" from 0 to (_newCount - 1) step _qtyPerFrame do
{
	if (_i >= _newCount) exitWith {};

	_jCount = (_qtyPerFrame min (_newCount - _i)) - 1;

	if (_forceNonScheduled) then
	{
		_callFSM = [[_array, _code, _i, _jCount],
		{
			_array = _this select 0;
			_code = _this select 1;
			_i = _this select 2;
			_jCount = _this select 3;

			for "_j" from 0 to _jCount do
			{
				(_array select (_i + _j)) call _code;
			};
		}] execFSM "call.fsm";
		waitUntil {completedFSM _callFSM};
	}
	else
	{
		for "_j" from 0 to _jCount do
		{
			(_array select (_i + _j)) call _code;
		};
	};

	//systemChat format ["%1 - %2 - %3", diag_tickTime, _i, _jCount + 1];
	uiSleep 0.01;
};

_qtyPerFrame
