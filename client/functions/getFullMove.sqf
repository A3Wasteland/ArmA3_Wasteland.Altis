// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getFullMove.sqf
//	@file Author: AgentRev
//	@file Created: 26/12/2013 16:37

private ["_player", "_targetMove", "_gesture", "_targetParts", "_currentMove", "_result", "_targetPart", "_currentCopy", "_targetParam", "_currentParam", "_copyString"];

_player = _this select 0;
_targetMove = _this select 1;

if (count _this > 2) then
{
	_gesture = _this select 2;
};

// Convert move array to string
_moveString =
{
	private ["_moveArr", "_result", "_x"];

	_moveArr = _this;
	_result = "";

	{
		if (typeName _x == "ARRAY") then
		{
			_result = _result + (_x select 0) + (_x select 1);
		};
	} forEach _moveArr;

	_result
};

_targetSplit = [_targetMove, "_"] call fn_splitString;

{
	_targetSplit set [_forEachIndex, _x call parseMove];
} forEach _targetSplit;

_currentMove = ([animationState _player, "_"] call fn_splitString) select 0; // get just the first part
_currentMove = _currentMove call parseMove;

_result = "";

if (typeName _currentMove == "ARRAY") then
{
	_resultArr = [];

	{
		_targetPart = _x;
		_currentCopy = +_currentMove; // Create a copy of the current move array for each target move part

		if (typeName _targetPart == "ARRAY") then
		{
			// The good stuff
			{
				_targetParam = _x;

				{
					_currentParam = _x;

					// Override current move parameter by target parameter if match
					if (_currentParam select 0 == _targetParam select 0) then
					{
						_currentCopy set [_forEachIndex, [_currentParam select 0, _targetParam select 1]]; // equivalent to _currentParam set [1, _targetParam select 1];
					};
				} forEach _currentCopy;
			} forEach _targetPart;
		};

		_copyString = _currentCopy call _moveString;

		// Add the processed copy to the result string
		if (_result == "") then
		{
			_result = _copyString;
		}
		else
		{
			_result = _result + "_" + _copyString;
		};
	} forEach _targetSplit;
};

if (!isNil "_gesture" && {_gesture != ""} && {_result != ""}) then
{
	_result = _result + "_" + _gesture;
};

_result
