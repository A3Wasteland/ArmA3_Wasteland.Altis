//@file Version: 1.0
//@file Name: healSelf.sqf
//@file Author: MercyfulFate edited by Gigatek
//@file Created: 22/9/2014
//@file Description: Heal yourself with a First Aid Kit

#define DURATION 25
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_CANCELLED "First Aid Cancelled!"
private ["_checks", "_success"];

_checks = {
    private ["_progress","_failed", "_text"];
    _progress = _this select 0;
    _text = "";
    _failed = true;
    switch (true) do {
        case (!alive player): {}; // player is dead, no need for a notification
        case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
        default {
            _text = format["First Aid %1%2 Applied", round(100 * _progress), "%"];
            _failed = false;
        };
    };
    [_failed, _text];
};

_success = [DURATION, ANIMATION, _checks, []] call a3w_actions_start;

if (_success) then {
	player removeItem "FirstAidKit";	
	player setDamage 0;
	["First Aid Completed!", 5] call mf_notify_client;
};
_success;