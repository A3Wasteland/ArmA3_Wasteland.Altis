// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setMissionState.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

private ["_mArray", "_mType", "_mState"];

_mArray = [_this, 0, [], [[]]] call BIS_fnc_param;
_mType = [_this, 1, "", [""]] call BIS_fnc_param;
_mState = [_this, 2, false, [false]] call BIS_fnc_param;

{
	if (_x select 0 == _mType) exitWith
	{
		_x set [2, _mState];
	};
} forEach _mArray;
