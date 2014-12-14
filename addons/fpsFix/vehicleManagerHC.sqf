//	@file Name: vehicleManagerHC.sqf
//	@file Author: AgentRev

// This script will massively increase server FPS for missions with a lot of vehicles and players.
// It must be spawned or execVM'd once on the headless client

// If you decide to use this in another mission, a little mention in the credits would be appreciated :) - AgentRev

if (hasInterface) exitWith {};

#define MAIN_LOOP_INTERVAL 3
#define MIN_INIT_TIME 60
#define DISABLE_DISTANCE_VEHICLE 2000
#define DISABLE_DISTANCE_THING 1000

scriptName "vehicleManagerHC";
private ["_eventCode", "_vehicleManager"];

_eventCode =
{
	_vehicle = _this select 0;
	if (!simulationEnabled _vehicle) then { [_vehicle, true] call fn_enableSimulationGlobal };
	_vehicle setVariable ["fpsFix_simulationCooloff", diag_tickTime + 20];
};

_vehicleManager =
{
	scopeName "vehicleManagerCall";
	private ["_vehicle", "_initTime", "_minDist", "_tryEnable", "_playerClose"];
	_vehicle = _this select 0;

	_initTime = _vehicle getVariable ["fpsFix_initTime", 0];

	if (_initTime == 0) then
	{
		_initTime = diag_tickTime;
		_vehicle setVariable ["fpsFix_initTime", _initTime];
	};

	if (diag_tickTime - _initTime < MIN_INIT_TIME) exitWith {}; // not ready

	switch (true) do
	{
		case (_vehicle isKindOf "Man"):          { breakOut "vehicleManagerCall" };
		case (_vehicle isKindOf "AllVehicles"):  { _minDist = DISABLE_DISTANCE_VEHICLE };
		case (_vehicle isKindOf "Thing"):        { _minDist = DISABLE_DISTANCE_THING };
		default                                  { breakOut "vehicleManagerCall" };
	};

	_tryEnable = true;
	_playerClose = false;

	{
		if (_x distance _vehicle <= _minDist) exitWith
		{
			_playerClose = true;
		};
	} forEach _allPlayers;

	if (!_playerClose) then
	{
		if (count crew _vehicle == 0 &&
		   {_vehicle getVariable ["fpsFix_simulationCooloff", 0] < diag_tickTime &&
		    vectorMagnitude velocity _vehicle < 0.1 &&
		    (getPos _vehicle) select 2 < 1}) then
		{
			[_vehicle, false] call fn_enableSimulationGlobal;
			_tryEnable = false;
		};
	};

	if (_tryEnable && !simulationEnabled _vehicle) then
	{
		[_vehicle, true] call fn_enableSimulationGlobal;
	};

	if !(_vehicle getVariable ["fpsFix_eventHandlers", false]) then
	{
		if (_vehicle isKindOf "AllVehicles") then
		{
			_vehicle addEventHandler ["GetIn", _eventCode];
		};

		if (_vehicle isKindOf "Thing") then
		{
			_vehicle addEventHandler ["EpeContactStart", _eventCode];
		};

		_vehicle addEventHandler ["Explosion", _eventCode];
		_vehicle addEventHandler ["Killed", _eventCode];

		_vehicle setVariable ["fpsFix_eventHandlers", true];
	};
};

private ["_oldCount", "_totalTime"];

_loopQty = (50 / MAIN_LOOP_INTERVAL); // 16.67 vehicles per 0.02s = roughly 2500 vehicles updated every 3s

while {true} do
{
	_vehicles = entities "All";
	_newCount = count _vehicles;

	// Ajusting the loopQty so as to spread processing as evenly as possible over the loop interval
	if (!isNil "_oldCount" && !isNil "_totalTime") then
	{
		_loopQty = _newCount min ceil ((_loopQty / (MAIN_LOOP_INTERVAL / _totalTime)) * (_newCount / _oldCount));
	};

	_startTime = diag_tickTime;
	_allPlayers = call allPlayers;

	for "_i" from 0 to (_newCount - 1) step _loopQty do
	{
		if (_i >= _newCount) exitWith {};

		[[_i, (_loopQty min (_newCount - _i)) - 1, _vehicles, _allPlayers, _eventCode, _vehicleManager],
		{
			_i = _this select 0;
			_jCount = _this select 1;
			_vehicles = _this select 2;
			_allPlayers = _this select 3;
			_eventCode = _this select 4;
			_vehicleManager = _this select 5;

			for "_j" from 0 to _jCount do
			{
				[_vehicles select (_i + _j)] call _vehicleManager;
			};
		}] execFSM "call.fsm"; // outside the scheduler

		uiSleep 0.01; // tests show 0.01 actually takes 0.02, and 0.02 takes 0.033
	};

	_oldCount = _newCount;
	_totalTime = diag_tickTime - _startTime;

	uiSleep (MAIN_LOOP_INTERVAL - _totalTime);
};
