//@file Version: 1.0
//@file Name: repair.sqf
//@file Author: MercyfulFate
//@file Created: 23/7/2013 16:00
//@file Description: Repair the nearest Vehicle

#define DURATION 5
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_NO_VEHICLE "You are not close enough to a vehicle that needs repairing"
#define ERR_IN_VEHICLE "Repairing Failed! You cant do that in a vehicle"
#define ERR_FULL_HEALTH "Repairing Failed! The vehicle is already repaired"
#define ERR_CANCELLED "Repairing Cancelled!"

private ["_vehicles", "_vehicle", "_checks", "_success"];
_vehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 5];
_vehicle = objNull;
{
    if (damage _x >= 0.005) exitWith {_vehicle = _x};
} forEach _vehicles;

if (isNull _vehicle) exitWith {
    [ERR_NO_VEHICLE, 5] call mf_notify_client;
    false;
};

_checks = {
    private ["_progress","_failed", "_text"];
    _progress = _this select 0;
    _vehicle = _this select 1;
    _text = "";
    _failed = true;
    switch (true) do {
        case not(alive player): {}; // player is dead, no need for a notification
        case (vehicle player != player): {_text = ERR_IN_VEHICLE};
        case (player distance _vehicle): {_text = ERR_TOO_FAR_AWAY};
        case (damage _vehicle < 0.005): {_text = ERR_FULL_HEALTH};
        case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
        default {
            _text = format["Repairing %1%2 Complete", round(100 * _progress), "%"];
            _failed = false;
        };
    };
    [_failed, _text];
};

_success = [DURATION, ANIMATION, _checks, [_vehicle]] call mf_util_playUntil;

if (_success) then {
	_vehicle setDamage 0;
	["Repairing complete!", 5] call mf_notify_client;
};
_success;