// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: parseMove.sqf
//	@file Author: AgentRev
//	@file Created: 26/12/2013 16:37

// Parse move string to array; on failure, outputs input string

private ["_moveArr", "_result", "_x", "_type", "_value"];

_moveArr = toArray _this;
_result = [];

for [{_x = 0},{_x < count _moveArr},{_x = _x + 4}] do
{
	_type = toUpper toString [_moveArr select _x];
	_value = [];

	for [{_y = _x + 1},{_y < _x + 4 && _y < count _moveArr},{_y = _y + 1}] do
	{
		_value pushBack (_moveArr select _y);
	};

	_value = toLower toString _value;

	_result pushBack [_type, _value];
};

_result
