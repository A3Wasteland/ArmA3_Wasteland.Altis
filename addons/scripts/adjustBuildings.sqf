//	@file Version: 1.0
//	@file Name: adjustBuildings.sqf
//	@file Author: AgentRev
//	@file Created: 05/07/2013 21:14

// Disable lighthouse rays due to light passing thru terrain
{
	_x setHit ["Light_1_hitpoint", 1];
	_x setHit ["Light_2_hitpoint", 1];
	_x setHit ["Light_3_hitpoint", 1];
} forEach nearestObjects [[0,0], ["Land_LightHouse_F"], 999999];

// Make fuel stations invulnerable because of retards blowing them up all the time
{
	_x allowDamage false;
} forEach nearestObjects [[0,0], ["Land_FuelStation_Feed_F", "Land_FuelStation_Shed_F", "Land_fs_feed_F", "Land_fs_roof_F"], 999999];
