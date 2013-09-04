#define ERR_IN_VEHICLE "Can't do that while in a vehicle"
#define ERR_TOO_FAR "You are too far away"
#define ERR_WRONG_SIDE "The Warchest is on your team"

private ["_warchest", "_error"];
 _warchest = objNull;
if (count _this > 0) then {
	_warchest = _this select 0;
} else {
	_warchest = [] call mf_items_warchest_nearest;
};

_error = "failed";
switch (true) do {
	case not(alive player): {}; // player not alive, not need for error msg
	case (vehicle player != player): {_error = ERR_IN_VEHICLE};
    case (isNull _warchest): {_error = ERR_TOO_FAR};
    case (player distance _warchest >= 5): {_error = ERR_TOO_FAR};
	case ((_warchest getVariable "side") != side player): {_error = ERR_WRONG_SIDE};
	default {_error = ""};
};
_error;