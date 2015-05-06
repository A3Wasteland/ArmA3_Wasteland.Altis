// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define ERR_IN_VEHICLE "Can't do that while in a vehicle"
#define ERR_TOO_FAR "You are too far away"
#define ERR_WRONG_SIDE "The Warchest is not owned by your team"
#define ERR_NOT_WARCHEST "That object is not a warchest"

private ["_warchest", "_error"];
_warchest = objNull;
if (count _this > 0) then {
	_warchest = _this select 0;
} else {
	_warchest = [] call mf_items_warchest_nearest;
};

_error = "failed";
switch (true) do {
	case (player distance _warchest > 5): {_error = ERR_TOO_FAR};
	case (!alive player): {}; // caller is dead, no need for error message
	case (vehicle player != player): {_error = ERR_IN_VEHICLE};
	case !(_warchest getVariable ["a3w_warchest", false]): {_error = ERR_NOT_WARCHEST};
	case (_warchest getVariable ["side", sideUnknown] != playerSide): {_error = ERR_WRONG_SIDE};
	default {_error = ""};
};
_error
