//	@file Version: 2
//	@file Name: vehicleSpawning.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//  new one, no longer requires Spawn_ markers but uses the town's radius in config.sqf to pick the ammount of vehicles

#define A3W_TOWN_SPAWNING_METERS_PER_VEHICLE 20 // This defines a fraction of the town's radius for which to spawn a vehicle (ex.: 20 meters per vehicle in town with 100m radius = 5 vehicles in town)

if (!isServer) exitWith {};

private ["_counter","_townname","_tradius","_pos","_vehammount","_minrad","_maxrad","_lcounter","_spawnedVehicles","_createRandomVehicle","_angleIncr","_langle","_lpos"];
_tradius = 0;
_townname = "debug";
_counter = 1;
_vehammount = 0;
_minrad = 0;
_maxrad = 0;
_lcounter = 0;

_spawnedVehicles = [];

_createRandomVehicle =
{
	private ["_pos", "_minrad", "_maxrad", "_counter", "_num", "_vehicleType", "_mindist"];
	_pos = _this select 0;
	_minrad = _this select 1;
	_maxrad = _this select 2;
	_counter = _this select 3;
	
	_num = random 100;

	switch (true) do
	{
		case (_num < 15): { _vehicleType = mediumMilitaryVehicles call BIS_fnc_selectRandom };
		case (_num < 50): { _vehicleType = lightMilitaryVehicles call BIS_fnc_selectRandom };
		default           { _vehicleType = civilianVehicles call BIS_fnc_selectRandom };
	};
	
	if (_vehicleType isKindOf "Quadbike_01_base_F") then {
		_mindist = 1.5;
	} else {
		_mindist = 4;
	};
	
	_pos = [_pos, _minrad, _maxrad, _mindist, 0, 60*(pi/180), 0, _vehicleType] call findSafePos;
	
	[_pos, _vehicleType] call vehicleCreation;
	
	//diag_log format ["Vehicle spawn #%1 done", _counter];
};

{
	_pos = getMarkerPos (_x select 0);
	_tradius = _x select 1;
	_townname = _x select 2;
	_vehammount = ceil (_tradius / A3W_TOWN_SPAWNING_METERS_PER_VEHICLE); // Spawns a vehicle for each fraction of the town's radius
	_angleIncr = 360 / _vehammount;
	_langle = random _angleIncr;
	//_minrad = 15;
	//_maxrad = 30;
	_minrad = 0;
	_maxrad = _tradius / 2;
	
	while {_lcounter < _vehammount} do
	{
		_lpos = [_pos, [[_maxrad, 0, 0], _langle] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd;
		_spawnedVehicles set [count _spawnedVehicles, [_lpos, _minrad, _maxrad, _counter] spawn _createRandomVehicle];
		//_minrad = _minrad + 15;
		//_maxrad = _maxrad + 15;
		_langle = _langle + _angleIncr;
		_counter = _counter + 1;
		_lcounter = _lcounter + 1;
	};	
	//diag_log format["WASTELAND DEBUG - spawned %1 Vehicles in: %2",_lcounter,_townname];
	_lcounter = 0;
} forEach (call citylist);

{
	//diag_log format ["Waiting vehicle spawn #%1", _forEachIndex + 1];
	waitUntil {scriptDone _x};
} forEach _spawnedVehicles;

diag_log format["WASTELAND - Vehicle spawning completed - %1 Vehicles Spawned on Altis",_counter];
