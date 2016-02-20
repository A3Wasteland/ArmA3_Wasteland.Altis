// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: fn_selectRandomWeighted.sqf
//	@file Author: AgentRev
//	@file Created: 16/08/2013 23:14

// Because BIS_fnc_selectRandomWeighted is really badly coded.

private ["_array", "_weights", "_arrayCount", "_weightsTotal", "_forEachIndex"];

_array = param [0,[],[[]]];
_weights = param [1,[],[[]]];
_arrayCount = count _array;
_weightsTotal = 0;

if (_arrayCount == 0) exitWith
{
	"The Array (0) must not be empty!" call BIS_fnc_error;
	nil
};

if (_arrayCount > count _weights) exitWith
{
	"There must be at least as many elements in Weights (1) as there are in Array (0)!" call BIS_fnc_error;
	nil
};

{
	if (_forEachIndex >= _arrayCount) exitWith {};
	_x = _x param [0,0,[0]];
	_weightsTotal = _weightsTotal + _x;
} forEach _weights;

if (_weightsTotal > 0) then
{
	private ["_random", "_index"];

	_random = random _weightsTotal;
	_weightsTotal = 0;

	{
		_weightsTotal = _weightsTotal + _x;
		if (_random < _weightsTotal) exitWith
		{
			_index = _forEachIndex;
		};
	} forEach _weights;

	if (!isNil "_index") then
	{
		_array select _index
	}
	else
	{
		["Your computer is broken."] call BIS_fnc_error;
		nil
	};
}
else
{
	["The sum of weights must be larger than 0"] call BIS_fnc_error;
	nil
};
