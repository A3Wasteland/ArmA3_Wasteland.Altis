/*
 =======================================================================================================================
Script: BIN_taskDefend.sqf v1.3a (defendArea.sqf)
Author(s): Binesi, AgentRev
Partly based on original code by BIS

Description:
Group will guard/patrol the position and surrounding area.

Parameter(s):
_this select 0: group (Group)
_this select 1: defense position (Array)
_this select 2: Vehicle class to move in as gunner (String, optional)
    
Returns:
Boolean - success flag

Example(s):
[group this, getPos this] call defendArea;
=======================================================================================================================
*/

if (!isServer) exitWith {};

private ["_grp", "_pos", "_vehicleType"];

_grp = _this select 0;
_pos = _this select 1;
_vehicleType = if (count _this > 2) then { _this select 2 } else { "StaticWeapon" };

_grp setBehaviour "AWARE";
_grp allowFleeing 0;

// Static weapons
private ["_list", "_units", "_staticWeapons"];
_list = _pos nearObjects [_vehicleType, 120];
_units = (units _grp) - [leader _grp]; // The leader should not man defenses
_staticWeapons = [];

// Find all nearby static defenses or vehicles without a gunner
{
    if (_x emptyPositions "gunner" > 0) then 
    {
        _staticWeapons set [count _staticWeapons, _x];    
    };
} forEach _list;

// Have the group man empty static defenses and vehicle turrets
{
    // Are there still units available?
    if (count _units > 0) then 
    {
        private "_unit";
        _unit = _units select (count _units - 1);
		
        _unit assignAsGunner _x;
        [_unit] orderGetIn true;
        sleep 15; // Give gunner time to get in, otherwise force.
        _unit moveInGunner _x;
        
        _units resize (count _units - 1);
    };
} forEach _staticWeapons;

// Waypoints
private ["_wp1", "_wp2"];

_wp1 = _grp addWaypoint [_pos, 0];
_wp1 setWaypointType "GUARD";
[_grp, 1] setWaypointStatements ["true",
'
	(group this) spawn
	{
		sleep 60;
		_this setCurrentWaypoint [_this, 2];
	};
'];

_wp2 = _grp addWaypoint [_pos, 0];
_wp2 setWaypointType "CYCLE";
[_grp, 2] setWaypointStatements ["true",
'
	(group this) spawn
	{
		_this setCurrentWaypoint [_this, 1];
	};
'];

_grp setCurrentWaypoint [_grp, 1];

{
	// Prevent units from wandering too far and from going prone
	[_x, _pos] spawn
	{
		private ["_unit", "_unitPos", "_targetPos", "_doMove"];
		_unit = _this select 0;
		_targetPos = ATLtoASL (_this select 1);
		
		while { alive _unit } do
		{
			if ((toUpper behaviour _unit) in ["COMBAT","STEALTH"]) then
			{
				if (stance _unit == "PRONE") then
				{
					_unit setUnitPos "MIDDLE";
				};
			}
			else
			{
				if (unitPos _unit == "MIDDLE") then
				{
					_unit setUnitPos "AUTO";
				};
			};
			
			sleep 1;
			
			if (!isNull _unit) then
			{
				_unitPos = getPosASL _unit;
				
				if (_unitPos vectorDistance _targetPos > 75) then
				{
					_doMove = [[5 + random 65, 0, 0], ([_targetPos, _unitPos] call BIS_fnc_dirTo) + (random 90) - 45] call BIS_fnc_rotateVector2D;
					_unit moveTo (_targetPos vectorAdd _doMove);
					sleep 3;
				};
			};
		};
	};
} forEach units _grp;

true
