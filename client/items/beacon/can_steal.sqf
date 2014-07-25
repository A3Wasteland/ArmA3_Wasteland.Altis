//@file Version: 1.0
//@file Name: can_steal.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Check if is a spawn beacon that you can steal
//@file Argument: [_beacon] The (object that is a) beacon to check if its stealable
//@file Argument: [] automatically find the closest beacon to test.

#define ERR_NO_TARGET "Need to point at a spawn beacon"
#define ERR_NOT_SPAWN_BEACON_TYPE "Thats not a spawn beacon (wrong type)"
#define ERR_NOT_OPP_SIDE "Stealing Spawn Beacon Failed! Someone else finished stealing it first."
#define ERR_TOO_FAR_AWAY "Stealing Spawn Beacon Failed! You are too far away to do that."
private ["_beacon", "_beacons","_error"];

if (count _this == 0) then {
    _beacon = [] call mf_items_spawn_beacon_nearest;
} else {
    _beacon = _this select 0;
};


_error = "failed";
switch (true) do {
	case (isNull _beacon): {_error = ERR_NO_TARGET};
	case not(alive player): {}; // player is dead so no error msg is needed
    case not(typeof _beacon == MF_ITEMS_SPAWN_BEACON_DEPLOYED_TYPE): {_error = ERR_NOT_SPAWN_BEACON_TYPE};
	case not(player distance _beacon < 5): {_error = ERR_TOO_FAR_AWAY};
	case ([_beacon] call mf_items_spawn_beacon_can_use): {_error = ERR_NOT_OPP_SIDE};
    default {_error = ""};
};

_error;