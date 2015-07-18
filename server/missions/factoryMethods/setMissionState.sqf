// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setMissionState.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_mArray", "_mType", "_mState"];

_mArray = param [0, [], [[]]];
_mType = param [1, "", [""]];
_mState = param [2, false, [false]];

{
	if (_x select 0 == _mType) exitWith
	{
		_x set [2, _mState];
	};
} forEach _mArray;
