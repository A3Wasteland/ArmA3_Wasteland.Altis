// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: can_repair.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Check if you can repair the nearest vehicle
//@file Argument: [_vehicle] the vehicle to test
//@file Argument: [] automatically find the nearest vehicle

#define ERR_NO_VEHICLE "You are not close enough to a vehicle that needs repairing"
#define ERR_IN_VEHICLE "You can't do this while in a vehicle."
#define ERR_FULL_HEALTH "The vehicle is already fully repaired"
#define ERR_DESTROYED "The vehicle is too damaged to repair"
#define ERR_NO_REPAIR_KITS "You have no repair kits"
#define ITEM_COUNT(ITEMID) ITEMID call mf_inventory_count

private ["_vehicle", "_hitPoints", "_error"];
_vehicle = objNull;
if (count _this == 0) then { // if array empty
	_vehicle = call mf_repair_nearest_vehicle;
} else {
	_vehicle = _this select 0;
};

_hitPoints = (typeOf _vehicle) call getHitPoints;

_error = "";
switch (true) do {
	case (isNull _vehicle): {_error = ERR_NO_VEHICLE};
	case (vehicle player != player):{_error = ERR_IN_VEHICLE};
	case (player distance _vehicle > (sizeOf typeOf _vehicle / 3) max 2): {_error = ERR_NO_VEHICLE};
	case (!alive _vehicle): {_error = ERR_DESTROYED};
	case (damage _vehicle < 0.05 && {{_vehicle getHitPointDamage (configName _x) > 0.05} count _hitPoints == 0}): {_error = ERR_FULL_HEALTH}; // 0.2 is the threshold at which wheel damage causes slower movement
	case (ITEM_COUNT(MF_ITEMS_REPAIR_KIT) <= 0 || {round getNumber (configFile >> "CfgVehicles" >> typeOf player >> "engineer") > 0 && !("ToolKit" in items player)}): {_error = ERR_NO_REPAIR_KITS};
};
_error;
