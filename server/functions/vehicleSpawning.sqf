// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 2
//	@file Name: vehicleSpawning.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//  new one, no longer requires Spawn_ markers but uses the town's radius in config.sqf to pick the ammount of vehicles

if (!isServer) exitWith {};

private ["_createRandomVehicle", "_totalRadius", "_carPerMeters", "_townThreads", "_startTime"];

_createRandomVehicle =
{
	private ["_pos", "_minrad", "_maxrad", "_counter", "_vehicleType", "_mindist"];
	_pos = _this select 0;
	_minrad = _this select 1;
	_maxrad = _this select 2;
	_counter = _this select 3;

	_vehicleType =
	[
		[A3W_smallVehicles, 0.30],
		[civilianVehicles, 0.40],
		[lightMilitaryVehicles, 0.15],
		[mediumMilitaryVehicles, 0.15]
	] call fn_selectRandomWeightedPairs call fn_selectRandomNested;

	if (_vehicleType isKindOf "Quadbike_01_base_F") then {
		_mindist = 1.5;
	} else {
		_mindist = 4;
	};

	_pos = [_pos, _minrad, _maxrad, _mindist, 0, 60*(pi/180), 0, _vehicleType] call findSafePos;

	[_pos, _vehicleType] call vehicleCreation;

	//diag_log format ["Vehicle spawn #%1 done", _counter];
};

_totalRadius = 0;

{ _totalRadius = _totalRadius + (_x select 1) } forEach (call citylist);

_carPerMeters = (["A3W_vehicleQuantity", 200] call getPublicVar) / _totalRadius;

_townThreads = [];

A3W_vehicleSpawning_townVehCount = 0;

_startTime = diag_tickTime;

{
	_townThreads pushBack ([_x, _carPerMeters, _createRandomVehicle] spawn
	{
		_town = _this select 0;
		_carPerMeters = _this select 1;
		_createRandomVehicle = _this select 2;

		_pos = getMarkerPos (_town select 0);
		_tradius = _town select 1;
		_townname = _town select 2;
		_vehammount = 1 max round (_tradius * _carPerMeters); // Calculates the quantity of vehicle based on the town's radius
		_angleIncr = 360 / _vehammount;
		_langle = random _angleIncr;
		//_minrad = 15;
		//_maxrad = 30;
		_minrad = 0;
		_maxrad = _tradius / 2;
		_lcounter = 0;

		while {_lcounter < _vehammount} do
		{
			_lpos = _pos vectorAdd ([[_maxrad, 0, 0], _langle] call BIS_fnc_rotateVector2D);
			[_lpos, _minrad, _maxrad, A3W_vehicleSpawning_townVehCount] call _createRandomVehicle;
			//_minrad = _minrad + 15;
			//_maxrad = _maxrad + 15;
			_langle = _langle + _angleIncr;
			A3W_vehicleSpawning_townVehCount = A3W_vehicleSpawning_townVehCount + 1;
			_lcounter = _lcounter + 1;
		};
		//diag_log format["WASTELAND DEBUG - spawned %1 Vehicles in: %2",_lcounter,_townname];
	});
} forEach (call citylist);

{
	//diag_log format ["Waiting town vehicle spawner #%1", _forEachIndex + 1];
	waitUntil {scriptDone _x};
} forEach _townThreads;

diag_log format["WASTELAND - Vehicle spawning completed - %1 town vehicles spawned in %2s", A3W_vehicleSpawning_townVehCount, diag_tickTime - _startTime];
