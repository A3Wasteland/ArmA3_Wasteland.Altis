// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: eat.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Eat and replenish your hunger
//@file Argument: the amount of hunger to replenish

#define ERR_CANCELLED "Eating Cancelled";
#define ANIMATION "AinvPknlMstpSnonWnonDnon_healed_1"
private ["_checks", "_success","_text"];
_checks = {
	private ["_progress","_failed", "_text", "_food"];
	_progress = _this select 0;
	_text = "";
	_failed = true;
	switch (true) do {
		case (!alive player) : {}; // player is dead, not need for a error message
		case (doCancelAction): {doCancelAction = false; _text = ERR_CANCELLED;};
		default {
			_failed = false;
			_text = format["Eating %1%2 Complete", round(100*_progress), "%"];
		};
	};
	[_failed, _text];
};

_success = [5, ANIMATION, _checks, []] call a3w_actions_start;
if (_success) then {
	hungerLevel = (hungerLevel + _this) min 100;
	["Your hunger has eased", 5] call mf_notify_client;
	hint "";
};
_success;
