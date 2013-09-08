/* ===============================================================================================================
  Simple Vehicle Respawn Script v1.83 for Arma 3
  by Tophe of �stg�ta Ops [OOPS]
  Updated by SPJESTER & modded by AgentRev
  
  vehicle.sqf is an example of the name of the file, name it whatever you would like
  
  Put this in the vehicles init line:
  veh = [this] execVM "vehicle.sqf"
  _______
  Options
  �������
  There are some optional settings. The format for these are:
  veh = [object, Delay, Deserted timer, Respawns, Effect, Dynamic, Init commands] execVM "vehicle.sqf"
  
  Delay: Default respawn delay is 30 seconds, to set a custom respawn delay time, put that in the init as well. 

  Deserted timer: Default respawn time when vehicle is deserted, but not destroyed is 120 seconds. To set a custom timer for this 
                  first set respawn delay, then the deserted vehicle timer. (0 = disabled) 
  
  Respawns: By default the number of respawns is infinite. To set a limit first set preceding values then the number of respawns you want (0 = infinite).

  Effect: Set this value to TRUE to add a special explosion effect to the wreck when respawning.
          Default value is FALSE, which will simply have the wreck disappear.
  
  Static: By default the vehicle will respawn at the position where it was destroyed (dynamic).
          This can be changed to static. Then the vehicle will respawn at the specified position (static).
          First set all preceding values then set a respawn position for static, or FALSE for dynamic.
  
  Example with all parameters:
  veh = [this, 15, 10, 5, TRUE, getPosASL this] execVM "vehicle.sqf"
  
  Default values of all settings are:
  veh = [this, 30, 120, 0, FALSE, FALSE] execVM "vehicle.sqf"
  
	
Contact & Bugreport: cwadensten@gmail.com
Ported for new update "call compile" by SPJESTER: mhowell34@gmail.com
Converted to server-side, junk removed, and modded for 404 Wasteland by AgentRev: agentrevo@gmail.com

NOTE: Some parameters have changed since the previous release, especially static/dynamic respawning, and removal of init commands.
	  Please ajust your vehicle spawn scripts accordingly if you plan to use this respawn scripts as-is.
================================================================================================================== */
  
if (!isServer) exitWith {};

// Define variables
_unit = _this select 0;
_delay = if (count _this > 1) then {_this select 1} else {30};
_deserted = if (count _this > 2) then {_this select 2} else {120};
_respawns = if (count _this > 3) then {_this select 3} else {0};
_explode = if (count _this > 4) then {_this select 4} else {false};
_static = if (count _this > 5) then {_this select 5} else {false};

_run = true;

if (_delay < 0) then {_delay = 0};
if (_deserted < 0) then {_deserted = 0};

sleep 1;

_dir = getDir _unit;
_position = getPosASL _unit;
_type = typeOf _unit;
_dead = false;
_brokenTimeout = 0;
_desertedTimeout = 0;

_sleepTime = 5;

{
	if (_x < _sleepTime) then {
		_sleepTime = ( if (_x > 1) then { _x } else { 1 } );
	};
} forEach [_delay, _deserted];

// Start monitoring the vehicle
while {_run} do 
{	
	sleep _sleepTime;
	
	if (!canMove _unit && {{alive _unit} count crew _unit == 0}) then
	{
		if (_delay > 0) then
		{
			if (_brokenTimeout == 0) then {
				_brokenTimeout = time + _delay;
			}
			else
			{
				if (_brokenTimeout <= time) then {
					_dead = true;
				};
			};
		}
		else
		{
			_dead = true;
		};
	}
	else
	{
		if (_brokenTimeout != 0) then {
			_brokenTimeout = 0;
		};
	};
	
	
// Check if the vehicle is deserted, and that it's not being towed or moved.
  
	if (_deserted > 0 && 
	{getPosASL _unit distance _position > 10} &&
    {{alive _unit} count crew _unit == 0} &&
    {isNull (_unit getVariable ["R3F_LOG_est_transporte_par", objNull])} && 
    {isNull (_unit getVariable ["R3F_LOG_est_deplace_par", objNull])}) then  
	{
		if (_desertedTimeout == 0) then {
			_desertedTimeout = time + _deserted;
		}
		else
		{
			if (_desertedTimeout <= time) then {
				_dead = true;
			};
		};
	}
	else
	{
		if (_desertedTimeout != 0) then {
			_desertedTimeout = 0;
		};
	};
	
	// Respawn vehicle
    if (_dead) then 
	{
		// Clean-up if vehicle is towing via R3F
		
		_towedUnit = _unit getVariable ["R3F_LOG_remorque", objNull];
		if (!isNil "_towedUnit") then  //might sound stupid but the game still might think its undefined..
		{
			if (!isNull _towedUnit) then
			{
				detach _towedUnit;
				_towedUnit setVariable ["R3F_LOG_est_transporte_par", objNull, true];
				_unit setVariable ["R3F_LOG_remorque", objNull, true];
				
				_pos = getPosATL _towedUnit;
				_towedUnit setPosATL [_pos select 0, _pos select 1, 0];
			};
		};
		
		if (typename _static == typeName []) then { _position = _static; }
		else { _position = getPosASL _unit; _dir = getDir _unit; };
		
		if (_explode) then { ("M_AT" createVehicle getPos _unit) setPosASL getPosASL _unit };
		
		sleep 0.1;
		_carType = typeOf _unit;
		deleteVehicle _unit;
		sleep 0.1;
		
		// 404 Wasteland vehicle spawn script
		if (_cartype in BoatList) then {
			[_position, _carType] call boatCreation;
		} else {
			[_position, _carType] call vehicleCreation;
			};
		
		sleep 0.1;		
		_run = false;
	};
};
