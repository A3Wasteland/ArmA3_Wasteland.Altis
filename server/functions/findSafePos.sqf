// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
/*
	File: findSafePos.sqf
	Author: Joris-Jan van 't Land
	Modified by AgentRev

	Description:
	Function to retrieve and dynamic position in the world according to several parameters.

	Parameter(s):
	_this select 0: center position (Array)
						Note: passing [] (empty Array), the world's safePositionAnchor entry will be used.
	_this select 1: minimum distance from the center position (Number)
	_this select 2: maximum distance from the center position (Number)
						Note: passing -1, the world's safePositionRadius entry will be used.
	_this select 3: minimum distance from the nearest object (Number)
	_this select 4: water mode (Number)
						0: cannot be in water
						1: can either be in water or not
						2: must be in water
	_this select 5: maximum terrain gradient (average altitude difference in meters - Number)
	_this select 6: shore mode (Number):
						0: does not have to be at a shore
						1: must be at a shore
	_this select 7: (optional) Vehicle type

	Returns:
	Coordinate array with a position solution.

	TODO:
	* Maybe allow passing several combinations of position, min and max dist ... so that you can
	avoid several things?
	* Interpretation of minDist / maxDist is wrong. It's not true distance that is used. Too bad? - Fixed by AgentRev
*/

scopeName "main";

private ["_pos", "_minDist", "_maxDist", "_objDist", "_waterMode", "_maxGradient", "_shoreMode", "_vehicleType"];
_pos = _this select 0;
_minDist = _this select 1;
_maxDist = _this select 2;
_objDist = _this select 3;
_waterMode = _this select 4;
_maxGradient = _this select 5;
_shoreMode = _this select 6;

if (_shoreMode == 0) then {_shoreMode = false} else {_shoreMode = true};

_vehicleType = "";
if (count _this > 7) then
{
	_vehicleType = _this select 7;
};

//See if default world values should be used.
if (count _pos == 0) then
{
	_pos = getArray (configFile >> "CfgWorlds" >> worldName >> "safePositionAnchor");
};

if (count _pos == 0) exitWith {debugLog "Log: [findSafePos] No center position was passed!"; []}; //TODO: instead return defaults below.

if (_maxDist == -1) then
{
	_maxDist = getNumber(configFile >> "CfgWorlds" >> worldName >> "safePositionRadius");
};

//TODO: Validate parameters.

private ["_newPos", "_posX", "_posY"];
_newPos = [];
_posX = _pos select 0;
_posY = _pos select 1;

if (count _pos == 2) then { _pos set [2, 0] };

//Limit the amount of attempts at finding a good location.
private ["_attempts", "_maxAttempts"];
_maxAttempts = 999; //if (isDedicated) then { 9999 } else { 999 };

for "_attempts" from 0 to _maxAttempts do
{
	private "_testPos";
	_testPos = _pos vectorAdd ([[_minDist + random (_maxDist - _minDist), 0, 0], random 360] call BIS_fnc_rotateVector2D);

	if (count (_testPos isFlatEmpty [_objDist, 0, _maxGradient, _objDist max 3, _waterMode, _shoreMode, objNull]) > 0) exitWith
	{
		_newPos = _testPos;
	};
};

if (count _newPos == 0) then
{
	private "_params";
	_params = [_minDist, _maxDist];

	if (_vehicleType != "") then
	{
		_params set [2, _vehicleType];
	};

	_newPos = _pos findEmptyPosition _params;
};

//No position was found, use defaults.
if (count _newPos == 0) then
{
	_newPos = _pos;
};

//Still nothing was found, use world center positions.
if (count _newPos == 0) then
{
	_newPos = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
};

_newPos
