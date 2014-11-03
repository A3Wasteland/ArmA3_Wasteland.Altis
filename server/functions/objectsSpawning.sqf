// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: objectsSpawning.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer) exitWith {};

private ["_counter","_townname","_tradius","_pos","_objammount","_minrad","_maxrad","_lcounter","_spawnedObjects","_createRandomObject","_angleIncr","_langle","_lpos"];
_tradius = 0;
_townname = "debug";
_counter = 1;
_objammount = 0;
_minrad = 0;
_maxrad = 0;
_lcounter = 0;

_spawnedObjects = [];

_createRandomObject =
{
	private ["_pos", "_minrad", "_maxrad", "_counter"];
	_pos = _this select 0;
	_minrad = _this select 1;
	_maxrad = _this select 2;
	_counter = _this select 3;

	_pos = [_pos, _minrad, _maxrad, 2, 0, 60*(pi/180), 0] call findSafePos;
	[_pos] call objectCreation;

	//diag_log format ["Object spawn #%1 done", _counter];
};

{
	_pos = getMarkerPos (_x select 0);
	_tradius = _x select 1;
	_townname = _x select 2;
	if (["A3W_essentialsSpawning"] call isConfigOn && !(["A3W_baseBuilding"] call isConfigOn)) then
	{
		_objammount = ceil (_tradius / 75);  // spawns an object for every 75m radius the townmarker has, this might need tweaking!
	}
	else
	{
		_objammount = ceil (_tradius / 15);  // spawns an object for every 15m radius the townmarker has, this might need tweaking!
	};
	_angleIncr = 360 / _objammount;
	_langle = random _angleIncr;
	//_minrad = 15;
	//_maxrad = 30;
	_minrad = 0;
	_maxrad = _tradius / 2;

	while {_lcounter < _objammount} do
	{
		_lpos = _pos vectorAdd ([[_maxrad, 0, 0], _langle] call BIS_fnc_rotateVector2D);
		_spawnedObjects pushBack ([_lpos, _minrad, _maxrad, _counter] spawn _createRandomObject);
		//_minrad = _minrad + 15;
		//_maxrad = _maxrad + 15;
		_langle = _langle + _angleIncr;
		_counter = _counter + 1;
		_lcounter = _lcounter + 1;
	};
	//diag_log format["WASTELAND DEBUG - spawned %1 Objects in: %2",_lcounter,_townname];
	_lcounter = 0;
} forEach (call citylist);

{
	//diag_log format ["Waiting object spawn #%1", _forEachIndex + 1];
	waitUntil {scriptDone _x};
} forEach _spawnedObjects;

diag_log format["WASTELAND - Object spawning completed - %1 Objects Spawned on Altis",_counter];
