//	@file Name: vehicleManagerHC.sqf
//	@file Author: AgentRev

// This script will massively increase server FPS for missions with a lot of vehicles and players.
// It must be spawned or execVM'd once on the headless client

// If you decide to use this in another mission, a little mention in the credits would be appreciated :) - AgentRev

//if (hasInterface) exitWith {};

#define MAIN_LOOP_INTERVAL 3
#define LOOP_QUANTITY_PER_FRAME (50 / MAIN_LOOP_INTERVAL) // 16.67 = roughly 2500 vehicles updated every 3s
#define MIN_INIT_TIME 60
#define LOGGING_INTERVAL (5*60)
#define DISABLE_DISTANCE_VEHICLE 2000
#define DISABLE_DISTANCE_THING 1000

scriptName "vehicleManagerHC";

A3W_vehicleManagerEventCode =
{
	_vehicle = _this select 0;
	if (!simulationEnabled _vehicle) then { [_vehicle, true] call fn_enableSimulationGlobal };
	_vehicle setVariable ["fpsFix_simulationCooloff", diag_tickTime + 20];
} call mf_compile;

A3W_vehicleManagerHC =
{
	scopeName "vehicleManagerCall";
	private ["_vehicle", "_initTime", "_minDist", "_tryEnable", "_playerClose"];
	_vehicle = _this;

	_initTime = _vehicle getVariable ["fpsFix_initTime", 0];

	if (_initTime == 0) then
	{
		_initTime = diag_tickTime;
		_vehicle setVariable ["fpsFix_initTime", _initTime];
		_vehicle setVariable ["fpsFix_skip", !simulationEnabled _vehicle]; // don't touch vehicle if simulation is already disabled
	};

	if (diag_tickTime - _initTime < MIN_INIT_TIME || _vehicle getVariable ["fpsFix_skip", false]) exitWith {};

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
	} forEach A3W_allPlayers;

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
		[_vehicle, true] call fn_enableSimulationServer;
	};

	if !(_vehicle getVariable ["fpsFix_eventHandlers", false]) then
	{
		if (_vehicle isKindOf "AllVehicles") then
		{
			_vehicle addEventHandler ["GetIn", A3W_vehicleManagerEventCode];
		};

		if (_vehicle isKindOf "Thing") then
		{
			_vehicle addEventHandler ["EpeContactStart", A3W_vehicleManagerEventCode];
		};

		_vehicle addEventHandler ["Explosion", A3W_vehicleManagerEventCode];
		_vehicle addEventHandler ["Killed", A3W_vehicleManagerEventCode];

		_vehicle setVariable ["fpsFix_eventHandlers", true];
	};
};

_loopQty = LOOP_QUANTITY_PER_FRAME;
_oldCount = 0;
_totalTime = 0;
_lastLog = 0;

waitUntil {!isNil "A3W_serverSpawningComplete"};

while {true} do
{
	_startTime = diag_tickTime;
	_entities = entities "All";
	A3W_allPlayers = call fn_allPlayers;

	_loopQty = [A3W_vehicleManagerHC, _entities, MAIN_LOOP_INTERVAL, _oldCount, _totalTime, _loopQty, true] call fn_loopSpread;

	_oldCount = count _entities;

	if (_lastLog == 0 || diag_tickTime - _lastLog >= LOGGING_INTERVAL) then
	{
		diag_log format ["vehicleManagerHC - %1 cached entities out of %2", {!simulationEnabled _x} count _entities, _oldCount];
		_lastLog = diag_tickTime;
	};

	_totalTime = diag_tickTime - _startTime;
	uiSleep (MAIN_LOOP_INTERVAL - _totalTime);
};
