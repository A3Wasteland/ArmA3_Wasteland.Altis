#define DURATION MF_ITEMS_WARCHEST_DEPLOY_DURATION
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_IN_VEHICLE "Deploying Warchest Failed! You can't do that in a vehicle."
#define ERR_CANCELLED "Deploying Warchest Cancelled!"
#define ERR_TOO_FAR_AWAY "Deploying Warchest Failed! You are too far way."
#define ERR_NOT_EAST_WEST "Deploying Warchest Failed! Independants dont have access to warchests yet."

private "_checks";
_checks = {
    private ["_progress","_position","_failed", "_text"];
    _progress = _this select 0;
    _position = _this select 1;
    _text = "";
    _failed = true;
    switch (true) do {
        case not(playerSide == east || playerSide == west) : {_text = ERR_NOT_EAST_WEST };
        case not(alive player): {}; //player dead, not need to notify them
        case (vehicle player != player): {_text = ERR_IN_VEHICLE};
        case (player distance _position > 3): {_text = ERR_IN_TOO_FAR_AWAY};
        case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
        default {
            _text = format["Warchest %1%2 Deployed", round(100 * _progress), "%"];
            _failed = false;
        };
    };
    [_failed, _text];
};

private ["_success", "_warchest", "_hackAction", "_accessAction"];
_success = [DURATION, ANIMATION, _checks, [position player]] call mf_util_playUntil;
if (_success) then {
    _warchest = MF_ITEMS_WARCHEST_OBJECT_TYPE createVehicle position player;
    _warchest setPos position player;
    _warchest setVariable ['side', playerSide, true];
	_warchest setVariable ["R3F_LOG_disabled", true];
	["Warchest Deployed!", 5] call mf_notify_client;
};
_success;