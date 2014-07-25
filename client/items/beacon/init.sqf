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
[MF_ITEMS_SPAWN_BEACON, "Spawn Beacon", _deploy, "Land_SuitCase_F", "client\icons\briefcase.paa", 1] call mf_inventory_create;

mf_items_spawn_beacon_nearest = {
    _beacon = objNull;
    _beacons = nearestObjects [player, [MF_ITEMS_SPAWN_BEACON_DEPLOYED_TYPE], 3];
    {
        if (_x getVariable ["a3w_spawnBeacon", false]) exitWith {
            _beacon = _x;
        };
    } forEach _beacons;
    _beacon;
};

mf_items_spawn_beacon_can_pack = build("can_pack.sqf");
mf_items_spawn_beacon_can_steal = build("can_steal.sqf");
mf_items_spawn_beacon_can_use = build("can_use.sqf");

private "_condition";
_condition = "'' == [] call mf_items_spawn_beacon_can_pack;";
_pack =["Pack Spawn Beacon", path("pack.sqf"), [], 1, true, false, "", _condition];
["beacon-pack", _pack] call mf_player_actions_set;

_condition = "'' == [] call mf_items_spawn_beacon_can_steal;";
_steal = ["Steal Spawn Beacon", path("steal.sqf"), [], 1, true, false, "", _condition];
["beacon-steal", _steal] call mf_player_actions_set;

_condition = "'' == [] call mf_items_spawn_beacon_can_pack && {playerSide != independent}";
_pack =["Change Spawn Permissions", path("toggle_spawn_permissions.sqf"), [], 1, true, false, "", _condition];
["beacon-spawn-toggle", _pack] call mf_player_actions_set;
