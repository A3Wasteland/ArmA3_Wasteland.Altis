// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "mutex.sqf"
#define DURATION MF_ITEMS_WARCHEST_HACK_DURATION
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_IN_VEHICLE "Warchest Hacking Failed! You can't do that in a vehicle."
#define ERR_TOO_FAR_AWAY "Warchest Hacking Failed! You are too far away."
#define ERR_HACKED "Warchest Hacking Failed! Someone else just finished hacking this warchest."
#define ERR_CANCELLED "Warchest Hacking Cancelled"

private ["_warchest", "_error", "_success"];
_warchest = [] call mf_items_warchest_nearest;
_error = [] call mf_items_warchest_can_hack;
if (_error != "") exitWith {[_error, 5] call mf_notify_client};

private "_checks";
_checks = {
	private ["_progress","_warchest","_failed", "_text"];
	_progress = _this select 0;
	_warchest = _this select 1;
	_text = "";
	_failed = true;
	switch (true) do {
		case (!alive player): {}; //player is dead, not need to notify them
		case (vehicle player != player): {_text = ERR_IN_VEHICLE};
		case (player distance _warchest > 3): {_text = ERR_TOO_FAR_AWAY};
		case (_warchest getVariable ["side", sideUnknown] == playerSide): {_text = ERR_HACKED};
		case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
		default {
			_text = format["Warchest Hacking %1%2 Complete", round(100 * _progress), "%"];
			_failed = false;
		};
	};
	[_failed, _text];
};

private ["_success", "_amount", "_money"];
MUTEX_LOCK_OR_FAIL;
_success = [DURATION, ANIMATION, _checks, [_warchest]] call a3w_actions_start;
MUTEX_UNLOCK;
if (_success) then {
	_amount = 0;
	switch (_warchest getVariable ["side", sideUnknown]) do {
		case EAST: {
			_amount = round(pvar_warchest_funds_east/4);
			pvar_warchest_funds_east = pvar_warchest_funds_east - _amount;
			publicVariable "pvar_warchest_funds_east";
		};
		case WEST: {
			_amount = round(pvar_warchest_funds_west/4);
			pvar_warchest_funds_west = pvar_warchest_funds_west - _amount;
			publicVariable "pvar_warchest_funds_west";
		};
	};
	//_money = (player getVariable ["cmoney", 0]) + _amount;
	//player setVariable ["cmoney", _money, true];
	[player, _amount] call A3W_fnc_setCMoney;
	[format["Warchest Hacking Complete! You stole $%1", [_amount] call fn_numbersText], 5] call mf_notify_client;
};
_success;
