// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_applypin.sqf
//@file Author: LouD (based on can_refuel.sqf by MercyfulFate)
//@file Description: Check if you can apply the pinlock to the nearest vehicle
//@file Argument: [_vehicle] the vehicle to test
//@file Argument: [] automatically find the nearest vehicle

#define ERR_NO_VEHICLE "No vehicle within range."
#define ERR_IN_VEHICLE "You can't do this while in a vehicle."
#define ERR_NOT_OWNER "You can't do if you are not the owner of the vehicle."
#define ERR_LOCKED "This vehicle needs to be unlocked first!"
#define ERR_PIN "This vehicle already has a pin."
#define ERR_NO_PINLOCK "You don't own a pinlock device."

private ["_vehicle", "_error"];
_vehicle = objNull;

if (count _this == 0) then 
{
	_vehicle = call mf_pinlock_nearest_vehicle;
} 
else 
{
	_vehicle = _this select 0;
};

_error = "";
switch (true) do 
{
	case (isNull _vehicle): {_error = ERR_NO_VEHICLE};
	case (vehicle player != player):{_error = ERR_IN_VEHICLE};
	case (_vehicle getVariable ["ownerUID",""] != getPlayerUID player): {_error = ERR_NOT_OWNER};
	case (locked _vehicle == 2): {_error = ERR_LOCKED};
	case (_vehicle getVariable ["vPin", false]): {_error = ERR_PIN};
	case ((MF_ITEMS_PINLOCK call mf_inventory_count) <= 0): {_error = ERR_NO_PINLOCK};
};
_error;