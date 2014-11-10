//@file Version: 1.0
//@file Name: lockPick.sqf
//@file Author: MercyfulFate edited by Gigatek
//@file Created: 06/09/2014
//@file Description: Lock Pick the nearest Vehicle

#define DURATION 180
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"

private ["_vehicle", "_checks", "_success", "_nearvehicle"];
_nearvehicle = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 7];
_vehicle = _nearvehicle select 0;

_checks = {
    private ["_progress","_failed", "_text"];
    _progress = _this select 0;
    _vehicle = _this select 1;
    _text = "";
    _failed = true;
    switch (true) do {
        case (!alive player): {}; // player is dead, no need for a notification
        case (vehicle player != player): {_text = "Lock Pick Failed! You can't do that in a vehicle."};
		case (((player distance _vehicle) - ((sizeOf typeOf _vehicle / 3) max 4)) > 2): {_text = "Lock Pick Failed! You are too far away from the vehicle."};
		case (!isNull (_vehicle getVariable ["R3F_LOG_est_deplace_par", objNull])): { _text = "Lock Pick Failed! Somebody moved the vehicle."};
		case (!isNull (_vehicle getVariable ["R3F_LOG_est_transporte_par", objNull])): { _text = "Lock Pick Failed! Somebody loaded or towed the vehicle."};
        case (!alive _vehicle): {_error = "The vehicle is too damaged to pick."};
        case (doCancelAction): {_text = "Lock Pick Cancelled!"; doCancelAction = false;};
        default {
            _text = format["Lock Pick %1%2 Complete", round(100 * _progress), "%"];
            _failed = false;
        };
    };
    [_failed, _text];
};

_success = [DURATION, ANIMATION, _checks, [_vehicle]] call a3w_actions_start;

if (isNil "_vehicle" || {typeName _vehicle != typeName objNull || {isNull _vehicle}}) exitWith {
  diag_log "No vehicle near to pick.";
  false
};

if (_success) then {
	[[netId _vehicle, 1], "A3W_fnc_setLockState", _vehicle] call A3W_fnc_MP; // Unlock
	_vehicle setVariable ["objectLocked", false, true]; 
	_vehicle setVariable ["R3F_LOG_disabled",false,true];
	_vehicle say3D "carlock";
	sleep 0.5;
	titleText ["Lock Pick Complete!","PLAIN DOWN"]; titleFadeOut 5;
};
_success;