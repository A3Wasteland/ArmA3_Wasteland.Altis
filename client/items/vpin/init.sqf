// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: LouD (based on init.sqf by MercyfulFate)
//@file Description: Initialize Vehicle pinlock

#define build(file) format["%1\%2", _path, file] call mf_compile;

private ["_path","_applypin"];
_path = _this;

_applypin = [_path, "applypin.sqf"] call mf_compile;
MF_ITEMS_PINLOCK = "pinlock";
MF_ITEMS_PINLOCK_TYPE = "Land_SatellitePhone_F";
MF_ITEMS_PINLOCK_ICON = "client\icons\keypad.paa";

mf_pinlock_nearest_vehicle = {
	["LandVehicle", "Air", "Ship"] call mf_nearest_vehicle
} call mf_compile;

[MF_ITEMS_PINLOCK, "Vehicle Pinlock", _applypin, MF_ITEMS_PINLOCK_TYPE, MF_ITEMS_PINLOCK_ICON, 1] call mf_inventory_create;

mf_can_applypin = [_path, "can_applypin.sqf"] call mf_compile;

private ["_label1", "_execute1", "_condition1", "_action1"];
_label1 = format["<img image='%1'/> Apply Vehicle Pinlock", MF_ITEMS_PINLOCK_ICON];
_execute1 = {MF_ITEMS_PINLOCK call mf_inventory_use};
_condition1 = "[] call mf_can_applypin == ''";
_action1 = [_label1, _execute1, [], 1, false, false, "", _condition1];
["pinlock-use", _action1] call mf_player_actions_set;