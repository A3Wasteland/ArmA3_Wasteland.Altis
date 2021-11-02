// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleRespawnManager.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

#define RESPAWN_LOOPING_TIME 10 //(5*60)

// Start monitoring the vehicle
while {true} do
{
	if (count A3W_respawningVehicles == 0) then
	{
		uiSleep 10;
	}
	else
	{
		_sleepIter = (RESPAWN_LOOPING_TIME / count A3W_respawningVehicles) max 0.01;

		{
			_startTime = diag_tickTime;
			_veh = _x get "_veh";

			// Check if vehicle is not being towed or moved
			if (isNull (_veh getVariable ["R3F_LOG_est_transporte_par", objNull]) &&
			    isNull (_veh getVariable ["R3F_LOG_est_deplace_par", objNull])) then
			{
				_settings = _x;
				(values _settings) params (keys _settings); // automagic assignation

				_proxyTimer = _proxyTimer - _desertedTimer;

				_broken = false;
				_deserted = false;

				_alive = alive _veh;
				_canMove = canMove _veh;

				// Is the vehicle still alive?
				if (_alive) then
				{
					// Can the vehicle move?
					if (_canMove) then
					{
						// Check for broken wheels
						{
							if (_veh getHitPointDamage _x >= 1) exitWith
							{
								_canMove = false;
							};
						} forEach (_veh getVariable ["vehicleRespawn_wheelHitPoints", []]);
					};

					// Is the vehicle broken?
					if (!_canMove && {{alive _x} count crew _veh == 0}) then
					{
						// Is there a respawn timer?
						if (_respawnTimer > 0) then
						{
							// Is the vehicle not yet marked as broken?
							if (_brokenTimeout == 0) then
							{
								// Set broken timeout
								_brokenTimeout = diag_tickTime + _respawnTimer;
							}
							else // The vehicle was previously broken
							{
								_lastOccupantTimestamp = _veh getVariable ["vehSaving_lastUse", 0];

								// Did somebody get in/out since it was marked as broken?
								if (_lastOccupantTimestamp > _brokenTimeout) then
								{
									// Readjust broken timeout
									_brokenTimeout = _lastOccupantTimestamp + _respawnTimer;
								};

								// If the broken timeout has been reached, mark the vehicle as dead
								if (diag_tickTime >= _brokenTimeout) then { _broken = true };
							};
						}
						else // The vehicle respawns immediatly since there is no respawn timer
						{
							// Mark the vehicle as dead
							_broken = true;
						};
					}
					else // The vehicle is not currently broken, or someone's inside
					{
						// Reset broken timeout
						_brokenTimeout = 0;
					};

					_settings set ["_brokenTimeout", _brokenTimeout];
					_settings set ["_lastSeenAlive", diag_tickTime];
				}
				else // The vehicle is destroyed
				{
					// Adjust broken timeout relative to destruction time
					_brokenTimeout = (_lastSeenAlive max (_veh getVariable ["processedDeath", 0])) + _respawnTimer;

					// If the broken timeout has been reached, mark the vehicle as dead
					if (diag_tickTime >= _brokenTimeout) then { _broken = true };
				};

				if (_alive) then
				{
					// Check if the vehicle is displaced, deserted, or looted
					if (_desertedTimer > 0 &&
					   {(getPosWorld _veh) vectorDistance _startPos >= _minDistance || _veh getVariable ["itemTakenFromVehicle", false]} &&
					   {{alive _x} count crew _veh == 0}) then
					{
						// Is the vehicle not yet marked as deserted?
						if (_desertedTimeout == 0) then
						{
							// Mark the vehicle as deserted
							_desertedTimeout = diag_tickTime + _desertedTimer;
						};

						_proxyExtra = 0;

						// Is there a proximity timer
						if (_proxyTimer > 0) then
						{
							_lastOwnerUID = _veh getVariable ["lastVehicleOwnerUID", "0"];
							_lastOwner = objNull;

							// Find the owner unit
							{
								if (getPlayerUID _x == _lastOwnerUID) exitWith
								{
									_lastOwner = _x;
								};
							} forEach playableUnits;

							// Is the last owner within proximity distance
							if (isPlayer _lastOwner && {_lastOwner distance _veh <= _proxyDistance}) then
							{
								// Take proximity timer extra into account
								_proxyExtra = _proxyTimer;
							};
						};

						// Is the desertion timeout reached?
						if (diag_tickTime >= _desertedTimeout + _proxyExtra) then
						{
							// Mark as deserted
							_deserted = true;
						};
					}
					else // The vehicle is still good
					{
						// Reset desertion timeout
						_desertedTimeout = 0;
					};

					_settings set ["_desertedTimeout", _desertedTimeout];
				};

				// Respawn vehicle
				if ((_alive && (_deserted || (_broken && _desertedTimeout == 0))) ||
				   (!_alive && _broken)) then
				{
					_veh enableSimulationGlobal true;
					_towedVeh = _veh getVariable ["R3F_LOG_remorque", objNull];

					// Clean-up if vehicle is towing via R3F
					if (!isNull _towedVeh) then
					{
						_towedVeh enableSimulationGlobal true;
						_towedVeh setVariable ["R3F_LOG_est_transporte_par", objNull, true];
						_veh setVariable ["R3F_LOG_remorque", objNull, true];

						if (local _towedVeh) then
						{
							[_towedVeh] call detachTowedObject;
						}
						else
						{
							pvar_detachTowedObject = [netId _towedVeh];
							publicVariable "pvar_detachTowedObject";
						};
					};

					if (count _respawnPos < 3) then
					{
						_respawnPos = getPosATL _veh;
					};

					sleep 0.1;

					if (_veh getVariable ["ownerUID",""] isEqualTo "") then
					{
						deleteVehicle _veh;
					};

					if (_vehClass isKindOf "Ship_F") then
					{
						[_respawnPos, _vehClass, _settings] spawn boatCreation;
					}
					else
					{
						[_respawnPos, _vehClass, _settings] spawn vehicleCreation;
					};
				};
			};

			uiSleep (_sleepIter - (diag_tickTime - _startTime));
		} forEach A3W_respawningVehicles;
	};
};
