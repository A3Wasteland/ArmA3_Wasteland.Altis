/*
 =======================================================================================================================
Script: BIN_taskDefend.sqf v1.3a
Author(s): Binesi
Partly based on original code by BIS

Description:
Group will man all nearby static defenses and vehicle turrets and guard/patrol the position and surrounding area.

Parameter(s):
_this select 0: group (Group)
_this select 1: defense position (Array)
    
Returns:
Boolean - success flag

Example(s):
null = [group this,(getPos this)] execVM "BIN_taskDefend.sqf"

-----------------------------------------------------------------------------------------------------------------------
Notes:

To prevent this script from manning vehicle turrets find and replace "LandVehicle" with "StaticWeapon".

The "DISMISS" waypoint is nice but bugged in a few ways. The odd hacks in this code are used to force the desired behavior.
The ideal method would be to write a new FSM and I may attempt that in a future project if no one else does. 

=======================================================================================================================
*/
if (!isServer) exitWith {};
private ["_grp", "_pos"];
_grp = _this select 0;
_pos = _this select 1;

_grp setBehaviour "AWARE";

private ["_list", "_units","_staticWeapons"];
_list = _pos nearObjects ["StaticWeapon", 120];
_units = (units _grp) - [leader _grp]; // The leader should not man defenses
_staticWeapons = [];

// Find all nearby static defenses or vehicles without a gunner
{
    if ((_x emptyPositions "gunner") > 0) then 
    {
        _staticWeapons = _staticWeapons + [_x];    
    };
} forEach _list;

// Have the group man empty static defenses and vehicle turrets
{
    // Are there still units available?
    if ((count _units) > 0) then 
    {
        private ["_unit"];
        _unit = (_units select ((count _units) - 1));
    
        _unit assignAsGunner _x;
        [_unit] orderGetIn true;
        sleep 16; // Give gunner time to get in, otherwise force.
        _unit moveInGunner _x;
            
        _units resize ((count _units) - 1);
    };
} forEach _staticWeapons;

// Setup Waypoints
private ["_wp1","_wp2","_wp3","_wp4"];

_wp1 = _grp addWaypoint [_pos, 0];
_wp1 setWaypointType "MOVE";
[_grp, 1] setWaypointSpeed "NORMAL";
[_grp, 1] setWaypointBehaviour "AWARE";
[_grp, 1] setWaypointCombatMode "RED";
[_grp, 1] setWaypointFormation "STAG COLUMN";
[_grp, 1] setWaypointCompletionRadius 25;
[_grp, 1] setWaypointStatements ["true", "null = [this] spawn {
        _grp = group (_this select 0);
        sleep (30+(random 60));
        {doStop _x} forEach units _grp;
        _grp setCurrentWaypoint [_grp,3];
        {_x doMove getPos _x} forEach units _grp;
        sleep 1;
        {_x forceSpeed 3} forEach units _grp;
        if ((random 3)> 2) then {sleep 3} else {sleep 30 + (random 30)};
        _grp setCurrentWaypoint [_grp, 1];
}; "];

_wp2 = _grp addWaypoint [_pos, 0];
_wp2 setWaypointType "DISMISS";
[_grp, 2] setWaypointStatements ["true", "null = [this] spawn {
        _grp = group (_this select 0);
        {_x forceSpeed -1 } forEach units _grp;
}; "];

_wp3 = _grp addWaypoint [_pos, 0];
_wp3 setWaypointType "SAD";
[_grp, 3] setWaypointSpeed "FULL";
[_grp, 3] setWaypointBehaviour "ALERT";
[_grp, 3] setWaypointCombatMode "RED";
[_grp, 3] setWaypointFormation "VEE";
[_grp, 3] setWaypointCompletionRadius 25;
[_grp, 3] setWaypointStatements ["true", "null = [this] spawn {
        _grp = group (_this select 0);
        _grp setCurrentWaypoint [_grp, 1];
}; "];

_wp4 = _grp addWaypoint [_pos, 0];
_wp4 setWaypointType "CYCLE"; // Redundant failsafe

true