// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: applypin.sqf
//@file Author: LouD (based on refuel.sqf by MercyfulFate)
//@file Description: Apply pinlock to nearest vehicle
//@file Argument: [player, player, _actionid, []] the standard "called by an action" values

#define DURATION 5 // seconds
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_IN_VEHICLE "Applying failed! You can't do that while in a vehicle."
#define ERR_TOO_FAR_AWAY "Applying Failed! You moved too far away from the vehicle."
#define ERR_NOT_OWNER "You can't do if you are not the owner of the vehicle."
#define ERR_LOCKED "This vehicle needs to be unlocked first!"
#define ERR_PIN "This vehicle already has a pin."
#define ERR_NO_PINLOCK "You don't own a pinlock device."
#define ERR_CANCELLED "Applying Cancelled!"

private ["_vehicle", "_error"];
_vehicle = call mf_pinlock_nearest_vehicle;
_error = [_vehicle] call mf_can_applypin;
if (_error != "") exitWith {[_error, 5] call mf_notify_client; false;};

_checks = 
{
	private ["_progress","_vehicle","_failed", "_text"];
	_progress = _this select 0;
	_vehicle = _this select 1;
	_text = "";
	_failed = true;
	switch (true) do 
	{
		case (!alive player): {}; //player is dead, no need for a notification
		case (vehicle player != player): {_text = ERR_IN_VEHICLE};
		case (player distance _vehicle > (sizeOf typeOf _vehicle / 3) max 2): {_text = ERR_TOO_FAR_AWAY};
		case (_vehicle getVariable ["ownerUID",""] != getPlayerUID player): {_error = ERR_NOT_OWNER};
		case (locked _vehicle == 2): {_error = ERR_LOCKED};
		case (_vehicle getVariable ["vPin", false]): {_error = ERR_PIN};
		case ((MF_ITEMS_PINLOCK call mf_inventory_count) <= 0): {_error = ERR_NO_PINLOCK};
		case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
		default 
		{
			_text = format["Applying the pinlock %1%2 Complete", round(100 * _progress), "%"];
			_failed = false;
	    };
	};
	[_failed, _text];
};
_success = [DURATION, ANIMATION, _checks, [_vehicle]] call a3w_actions_start;
if (_success) then {
	_vehicle setVariable ["vPin", true, true];
	_rNumber = format ["%1", ceil (random 9999)];
	_vehicle setVariable ["password", _rNumber, true];
	[format ["Your pincode is %1",_rNumber], 5] call mf_notify_client;	
};
_success;