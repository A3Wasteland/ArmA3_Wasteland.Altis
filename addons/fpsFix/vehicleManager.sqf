//	@file Version: 1.0
//	@file Name: vehicleManager.sqf
//	@file Author: AgentRev
//	@file Created: 14/09/2013 19:19

// This script must be spawned or execVM'd once on every client.
// For A3Wasteland, it is execVM'd at the end of "client\init.sqf"

// If you decide to use this script in another mission, a little mention in the credits would be appreciated :) - AgentRev

private ["_vehicleManager", "_lastPos"];

_vehicleManager = 
{
	private ["_eventCode", "_vehicle"];
	
	_eventCode = 
	{
		(_this select 0) enableSimulation true;
		(_this select 0) setVariable ["fpsFix_simulationCooloff", time + 10];
	};

	{
		_vehicle = _x;
		
		if (_vehicle distance player > 2000 && 
		   {count crew _vehicle == 0} && 
		   {_vehicle getVariable ["fpsFix_simulationCooloff", 0] < time} &&
		   {(velocity _vehicle) call BIS_fnc_magnitude < 0.1} &&
		   {isNull (_vehicle getVariable ["R3F_LOG_est_transporte_par", objNull])} && 
		   {isNull (_vehicle getVariable ["R3F_LOG_est_deplace_par", objNull])}) then
		{
			if (simulationEnabled _vehicle) then
			{
				_vehicle enableSimulation false;
			};
		}
		else
		{
			if (!simulationEnabled _vehicle) then
			{
				_vehicle enableSimulation true;
			};
		};
		
		if !(_vehicle getVariable ["fpsFix_eventHandlers", false]) then
		{
			_vehicle addEventHandler ["GetIn", _eventCode];
			_vehicle addEventHandler ["Dammaged", _eventCode];
			_vehicle addEventHandler ["EpeContactStart", _eventCode];
			_vehicle addEventHandler ["Killed", _eventCode];
			
			_vehicle setVariable ["fpsFix_eventHandlers", true];
		};
		
		sleep 0.01;
	} forEach vehicles;
};

_lastPos = [0,0,0];

while {true} do
{
	if (_lastPos distance player > 100) then
	{
		call _vehicleManager;
		_lastPos = getPos player;
	};
	
	sleep 5;
};
