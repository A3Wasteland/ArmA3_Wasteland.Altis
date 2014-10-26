// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setupMissionObject.sqf
//	@file Author: AgentRev

// For use in mission.sqm

if (!isServer) exitWith {};

private ["_object", "_r3fDisabled", "_straightenUp", "_customCode", "_pos"];

_object = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_r3fDisabled = [_this, 1, true, [true]] call BIS_fnc_param;
_straightenUp = [_this, 2, false, [true]] call BIS_fnc_param;
_customCode = [_this, 3, nil, [{}]] call BIS_fnc_param;

if (isNull _object) exitWith {};

if (_r3fDisabled) then
{
	_object setVariable ["R3F_LOG_disabled", true, true];
};

if (_straightenUp) then
{
	_object setVectorUp [0,0,1];
};

if (!isNil "_customCode") then
{
	_object call _customCode;
};
