//@file Version: 1.0
//@file Name: can_repair.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Check if you can repair the nearest vehicle
//@file Argument: [_vehicle] the vehicle to test
//@file Argument: [] automatically find the nearest vehicle

#define ERR_NO_VEHICLE "No vehicle close enough."
#define ERR_IN_VEHICLE "You can't do this while in a vehicle."
#define ERR_FULL_HEALTH "The vehicle is already fully repaired"
#define ERR_NO_REPAIR_KITS "You have no repair kits"
#define ITEM_COUNT(ITEMID) ITEMID call mf_inventory_count
private ["_vehicle", "_error"];
_vehicle = objNull;
if (count _this == 0) then { // if array empty
    _vehicle = call mf_repair_nearest_vehicle;
} else {
    _vehicle = _this select 0;
};

_error = "";
switch (true) do {
    case (vehicle player != player):{_error = ERR_IN_VEHICLE};
	case (isNull _vehicle): {_error = ERR_NO_VEHICLE};
	case (damage _vehicle < 0.05): {_error = ERR_FULL_HEALTH};
	case (ITEM_COUNT(MF_ITEMS_REPAIR_KIT) <= 0): {_error = ERR_NO_REPAIR_KITS};
    default {};
};
_error;
