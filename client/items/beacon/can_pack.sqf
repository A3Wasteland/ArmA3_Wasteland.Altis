//@file Version: 1.0
//@file Name: can_pack.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Check if you can pack the spawn beacon
//@file Argument: [_beacon] the (object that is a) beacon to check if its packable
//@file Argument: [] automatically find the closest beacon to check.

#define ERR_NO_TARGET "Need to point at a spawn beacon"
#define ERR_NOT_OUR_SIDE "Thats an opposition spawn beacon"
#define ERR_TOO_FAR_AWAY "You need to be less that 5 metres from it"
#define ERR_ALREADY_HAVE_SPAWNBEACON "You can not carry another spawn beacon"
#define ERR_SOMEONE_ELSE_IS_PACKING "Someone else is packing it already"
private ["_beacon", "_beacons", "_error"];
_beacon = objNull;

if (count _this == 0) then {
    _beacon = [] call mf_items_spawn_beacon_nearest;
} else {
    _beacon = _this select 0;
};

_error = "failed";
switch (true) do {
	case (isNull _beacon): {_error = ERR_NO_TARGET};
	case not(alive player): {};// Player is dead, no need for a error message
	case not(player distance _beacon < 5): {_error = ERR_TOO_FAR_AWAY};
	case (MF_ITEMS_SPAWN_BEACON call mf_inventory_is_full): {_error = ERR_ALREADY_HAVE_SPAWNBEACON};
	case (_beacon getVariable['packing', true]): {_error = ERR_SOMEONE_ELSE_IS_PACKING};
	case not([_beacon] call mf_items_spawn_beacon_can_use): {_error = ERR_NOT_OUR_SIDE};
    default {_error = ""};
};
_error;