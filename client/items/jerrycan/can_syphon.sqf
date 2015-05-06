// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_syphon.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Check if you can syphon from the nearest vehicle
//@file Argument: [_vehicle] the vehicle to test
//@file Argument: [] automatically find the nearest vehicle

#define ERR_NO_VEHICLE "You are not close enough to a vehicle that can be syphoned"
#define ERR_IN_VEHICLE "You can't do this while in a vehicle."
#define ERR_EMPTY "The vehicle does not have enough fuel"
#define ERR_NO_JERRYCAN "You have no empty fuel can"
#define ERR_NO_SYPHON "You don't have a syphon hose"
#define ERR_VEHICLE_LOCKED "Vehicle is locked/disabled"
#define ITEM_COUNT(ITEMID) ITEMID call mf_inventory_count
private ["_vehicle", "_error"];
_vehicle = objNull;
if (count _this == 0) then { // if array empty
	_vehicle = call mf_jerrycan_nearest_vehicle;
} else {
	_vehicle = _this select 0;
};

_error = "";
switch (true) do {
	case (isNull _vehicle): {_error = ERR_NO_VEHICLE};
	case (vehicle player != player):{_error = ERR_IN_VEHICLE};
	case (player distance _vehicle > (sizeOf typeOf _vehicle / 3) max 2): {_error = ERR_NO_VEHICLE};
	case (locked _vehicle > 1): {_error = ERR_VEHICLE_LOCKED};
	case (ITEM_COUNT(MF_ITEMS_JERRYCAN_EMPTY) <= 0): {_error = ERR_NO_JERRYCAN};
	case (ITEM_COUNT(MF_ITEMS_SYPHON_HOSE) <= 0): {_error = ERR_NO_SYPHON};
	case (fuel _vehicle < ([_vehicle] call mf_jerrycan_fuel_amount)): {_error = ERR_EMPTY};
};
_error;
