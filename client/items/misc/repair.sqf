//@file Version: 1.0
//@file Name: repair.sqf
//@file Author: MercyfulFate
//@file Created: 23/7/2013 16:00
//@file Description: Repair the nearest Vehicle

#define DURATION 20
#define REPAIR_RANGE 6;
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_NO_VEHICLE "You are not close enough to a vehicle that needs repairing"
#define ERR_IN_VEHICLE "Repairing Failed! You can't do that in a vehicle"
#define ERR_FULL_HEALTH "Repairing Failed! The vehicle is already repaired"
#define ERR_DESTROYED "The vehicle is too damaged to repair"
#define ERR_TOO_FAR_AWAY "Repairing Failed! You moved too far away from the vehicle"
#define ERR_CANCELLED "Repairing Cancelled!"

private ["_vehicles", "_vehicle", "_hitPoints", "_checks", "_success"];
_vehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 5];
_vehicle = objNull;
{
    if (damage _x >= 0.005) exitWith {_vehicle = _x};
} forEach _vehicles;

if (isNull _vehicle) exitWith {
    [ERR_NO_VEHICLE, 5] call mf_notify_client;
    false;
};

_hitPoints = (typeOf _vehicle) call getHitPoints;

_checks = {
    private ["_progress","_failed", "_text"];
    _progress = _this select 0;
    _vehicle = _this select 1;
    _text = "";
    _failed = true;
    switch (true) do {
        case not(alive player): {}; // player is dead, no need for a notification
        case (vehicle player != player): {_text = ERR_IN_VEHICLE};
        case (player distance _vehicle > (sizeOf typeOf _vehicle) / 1.8): {_text = ERR_TOO_FAR_AWAY};
        case (!alive _vehicle): {_error = ERR_DESTROYED};
		case (damage _vehicle < 0.05 && {{_vehicle getHitPointDamage (configName _x) < 0.2} count _hitPoints == 0}): {_error = ERR_FULL_HEALTH}; // 0.2 is the threshold at which wheel damage causes slower movement
        case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
        default {
            _text = format["Repairing %1%2 Complete", round(100 * _progress), "%"];
            _failed = false;
        };
    };
    [_failed, _text];
};

_success = [DURATION, ANIMATION, _checks, [_vehicle]] call a3w_actions_start;

if (_success) then {
	_vehicle setDamage 0;
	if (_vehicle isKindOf "Boat_Armed_01_base_F") then { _vehicle setHitPointDamage ["HitTurret", 1] }; // disable front GMG on boats
	["Repairing complete!", 5] call mf_notify_client;
};
_success;