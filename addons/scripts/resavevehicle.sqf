//@file Version: 1.2
//@file Name: revehiclesave.sqf
//@file Author: MercyfulFate edited by Gigatek
//@file Created: 06/09/2014
//@file Description: Save the nearest Vehicle

#define DURATION 10
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_IN_VEHICLE "Saving Failed! You can't do that in a vehicle."
#define ERR_DESTROYED "The vehicle is too damaged to save."
#define ERR_TOO_FAR_AWAY "Saving Failed! You are too far away from the vehicle."
#define ERR_CANCELLED "Saving Cancelled!"

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
        case (vehicle player != player): {_text = ERR_IN_VEHICLE};
        case (player distance _vehicle > (sizeOf typeOf _vehicle / 3) max 2): {_text = ERR_TOO_FAR_AWAY};
        case (!alive _vehicle): {_error = ERR_DESTROYED};
        case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
        default {
            _text = format["Vehicle Save %1%2 Complete", round(100 * _progress), "%"];
            _failed = false;
        };
    };
    [_failed, _text];
};

_success = [DURATION, ANIMATION, _checks, [_vehicle]] call a3w_actions_start;

if (_success) then {
	[[[netId _vehicle], {(objectFromNetId (_this select 0)) lock 0}], "BIS_fnc_spawn", _vehicle] call TPG_fnc_MP;
	_vehicle setVariable ["ownerUID", getPlayerUID player, true];
	_vehicle setVariable ["ownerN", name player, true];
	titleText ["Vehicle Saved!","PLAIN DOWN"]; titleFadeOut 5;
};
_success;