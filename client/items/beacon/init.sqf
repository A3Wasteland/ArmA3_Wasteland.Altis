// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Initialize Spawn Beacon
//@file Argument: the path of the directory holding this file

#define build(file) format["%1\%2", _this, file] call mf_compile
#define path(file) format["%1\%2",_this, file]

MF_ITEMS_SPAWN_BEACON_PATH = _this;
MF_ITEMS_SPAWN_BEACON = "spawnbeacon";
MF_ITEMS_SPAWN_BEACON_DEPLOYED_TYPE = "Land_TentDome_F";
MF_ITEMS_SPAWN_BEACON_STEAL_DURATION = 60;
MF_ITEMS_SPAWN_BEACON_DURATION = 30;
_deploy = build("deploy.sqf");
_icon = "client\icons\spawnbeacon.paa";
[MF_ITEMS_SPAWN_BEACON, "Spawn Beacon", _deploy, "Land_Sleeping_bag_folded_F", _icon, 1] call mf_inventory_create;

mf_items_spawn_beacon_nearest = {
	_beacon = objNull;
	_beacons = nearestObjects [player, [MF_ITEMS_SPAWN_BEACON_DEPLOYED_TYPE], 3];
	{
		if (_x getVariable ["a3w_spawnBeacon", false]) exitWith {
			_beacon = _x;
		};
	} forEach _beacons;
	_beacon;
} call mf_compile;

mf_items_spawn_beacon_can_pack = build("can_pack.sqf");
mf_items_spawn_beacon_can_steal = build("can_steal.sqf");
mf_items_spawn_beacon_can_use = build("can_use.sqf");

private "_condition";
_condition = "'' == [] call mf_items_spawn_beacon_can_pack;";
_pack =[format ["<img image='%1'/> Pack Spawn Beacon", _icon], path("pack.sqf"), [], 1, true, false, "", _condition];
["beacon-pack", _pack] call mf_player_actions_set;

_condition = "'' == [] call mf_items_spawn_beacon_can_steal;";
_steal = [format ["<img image='%1'/> Steal Spawn Beacon", _icon], path("steal.sqf"), [], 1, true, false, "", _condition];
["beacon-steal", _steal] call mf_player_actions_set;

_condition = "'' == [] call mf_items_spawn_beacon_can_pack && {playerSide != independent}";
_pack =[format ["<img image='%1'/> Change Spawn Permissions", _icon], path("toggle_spawn_permissions.sqf"), [], 1, true, false, "", _condition];
["beacon-spawn-toggle", _pack] call mf_player_actions_set;
