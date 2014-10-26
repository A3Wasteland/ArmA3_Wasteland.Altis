// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: getMoveParams.sqf
//	@file Author: AgentRev
//	@file Created: 25/02/2013 18:41

private ["_player", "_params", "_currentMove", "_result"];

_player = _this select 0;
_params = _this select 1;

_currentMove = ([animationState _player, "_"] call fn_splitString) select 0; // get just the first part
_currentMove = _currentMove call parseMove;

_result = "";

{
	_result = _result + _x + ([_currentMove, _x, ""] call fn_getFromPairs);
} forEach _params;

_result
