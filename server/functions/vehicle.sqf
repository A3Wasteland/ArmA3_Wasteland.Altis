/* ===============================================================================================================
  Simple Vehicle Respawn Script v1.90 for Arma 3
  by Tophe of Östgöta Ops [OOPS]
  Updated by SPJESTER & modded by AgentRev
  
  vehicle.sqf is an example of the name of the file, name it whatever you would like
  
  Put this in the vehicles init line:
  veh = [this] execVM "vehicle.sqf"
  _______
  Options
  ¯¯¯¯¯¯¯
  There are some optional settings. The format for these are:
  veh = [object, Delay, Deserted timer, Respawns, Effect, Dynamic, Init commands] execVM "vehicle.sqf"
  
  Delay: Default respawn delay is 30 seconds, to set a custom respawn delay time, put that in the init as well. 

  Deserted timer: Default respawn time when vehicle is deserted, but not broken is 120 seconds. To set a custom timer for this 
                  first set respawn delay, then the deserted vehicle timer. (0 = disabled) 
  
  Proximity deserted timer: Respawn time when the last driver is within the defined proximity distance. Default is 240 seconds. (0 = disabled) 
  
  Proximity distance: Distance from the vehicle within which the last vehicle driver triggers the proximity deserted timer. Default is 200m. (0 = disabled) 
  
  Respawns: By default the number of respawns is infinite. To set a limit first set preceding values then the number of respawns you want (0 = infinite).

  Effect: Set this value to TRUE to add a special explosion effect to the wreck when respawning.
          Default value is FALSE, which will simply have the wreck disappear.
  
  Static: By default the vehicle will respawn at the position where it was destroyed (dynamic).
          This can be changed to static. Then the vehicle will respawn at the specified position (static).
          First set all preceding values then set a respawn position for static, or FALSE for dynamic.
  
  Example with all parameters:
  veh = [this, 15, 30, 60, 100, 5, TRUE, getPosASL this] execVM "vehicle.sqf"
  
  Default values of all settings are:
  veh = [this, 30, 120, 240, 100, 0, FALSE, FALSE] execVM "vehicle.sqf"
  
	
Contact & Bugreport: cwadensten@gmail.com
Ported for new update "call compile" by SPJESTER: mhowell34@gmail.com
Converted to server-side, junk removed, and modded for 404 Wasteland by AgentRev: agentrevo@gmail.com

NOTE: Some parameters have changed since the previous release, especially static/dynamic respawning, and removal of init commands.
	  Please ajust your vehicle spawn scripts accordingly if you plan to use this respawn scripts as-is.
================================================================================================================== */

if (!isServer) exitWith {};

// Define variables
_veh = _this select 0;
_delay = if (count _this > 1) then {_this select 1} else {30};
_deserted = if (count _this > 2) then {_this select 2} else {120};
_proxyExtra = if (count _this > 3) then {_this select 3} else {240};
_proxyDistance = if (count _this > 4) then {_this select 4} else {200};
_respawns = if (count _this > 5) then {_this select 5} else {0};
_explode = if (count _this > 6) then {_this select 6} else {false};
_static = if (count _this > 7) then {_this select 7} else {false};

_run = true;

if (_delay < 0) then {_delay = 0};
if (_deserted < 0) then {_deserted = 0};

sleep 1;

_dir = getDir _veh;
_position = getPosASL _veh;
_type = typeOf _veh;
_dead = false;
_brokenTimeout = 0;
_desertedTimeout = 0;
_desertedExtra = 0;
_blownTire = false;

_proxyExtra = _proxyExtra - _deserted;

_sleepTime = 5;

{
	if (_x < _sleepTime) then {
		_sleepTime = ( if (_x > 4) then { _x / 4 } else { 1 } );
	};
} forEach [_delay, _deserted];

_wheels = [];
_hitPoints = configFile >> "CfgVehicles" >> (typeOf _veh) >> "HitPoints";

for "_i" from 0 to (count _hitPoints - 1) do
{
	_hitPoint = configName (_hitPoints select _i);
	if ([["Wheel","Track"], _hitPoint] call fn_findString != -1) then
	{
		_wheels set [count _wheels, _hitPoint];
	};
};

// Start monitoring the vehicle
while {_run} do 
{	
	sleep _sleepTime;
	
	// Check if vehicle is not being towed or moved
	if (isNull (_veh getVariable ["R3F_LOG_est_transporte_par", objNull]) &&
	    isNull (_veh getVariable ["R3F_LOG_est_deplace_par", objNull])) then
	{
		if (alive _veh) then
		{
			_blownTire = false;
			{ _blownTire = (_blownTire || {_veh getHitPointDamage _x == 1}) } forEach _wheels;
		};
		
		if ((_blownTire || {!canMove _veh}) && {{alive _veh} count crew _veh == 0}) then
		{
			if (_delay > 0) then
			{
				if (_brokenTimeout == 0) then {
					_brokenTimeout = diag_tickTime + _delay;
				}
				else
				{
					if (_brokenTimeout <= diag_tickTime) then {
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
		
		
		// Check if the vehicle is deserted, or if something was taken from it
		
		if (_deserted > 0 && 
		   {(getPosASL _veh) vectorDistance _position > 10 || _veh getVariable ["itemTakenFromVehicle", false]} &&
		   {{alive _veh} count crew _veh == 0}) then 
		{
			if (_desertedTimeout == 0) then {
				_desertedTimeout = diag_tickTime + _deserted;
			};
			
			if (_proxyExtra > 0 && {owner _veh > 1}) then
			{
				_lastDriver = [owner _veh] call findClientPlayer;
				
				if (isPlayer _lastDriver && {_lastDriver distance _veh <= _proxyDistance}) then
				{
					if (_desertedExtra == 0) then {
						_desertedExtra = _proxyExtra;
					};
				}
				else
				{
					if (_desertedExtra != 0) then {
						_desertedExtra = 0;
					};
				};
			};
		
			if (_desertedTimeout + _desertedExtra <= diag_tickTime) then {
				_dead = true;
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
			
			_towedVeh = _veh getVariable ["R3F_LOG_remorque", objNull];
			
			if (!isNil "_towedVeh" && {!isNull _towedVeh}) then
			{
				_towedVeh setVariable ["R3F_LOG_est_transporte_par", objNull, true];
				_veh setVariable ["R3F_LOG_remorque", objNull, true];
				
				if (local _towedVeh) then
				{
					[_towedVeh] call detachTowedObject;
				}
				else
				{
					[[netId _towedVeh], "detachTowedObject", _towedVeh] call TPG_fnc_MP;
				};
			};
			
			_position =	if (typeName _static == "ARRAY") then { _static } else { getPosATL _veh };
			
			if (_explode) then
			{
				_vehPos = getPosATL _veh;
				_exp = createVehicle ["M_AT", _vehPos, [], 0, "CAN_COLLIDE"];
				_exp setPosATL _vehPos;
			};
			
			sleep 0.1;
			_carType = typeOf _veh;
			deleteVehicle _veh;
			sleep 0.1;
			
			// A3Wasteland vehicle spawn script
			[_position, _carType] call vehicleCreation;
			
			sleep 0.1;		
			_run = false;
		};
	};
};
