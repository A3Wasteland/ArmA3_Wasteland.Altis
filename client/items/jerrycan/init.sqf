// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Initialize Jerrycans
//@file Argument: The path of the directory holding this file.

MF_ITEMS_JERRYCAN_EMPTY = "jerrycanempty";
MF_ITEMS_JERRYCAN_FULL = "jerrycanfull";
MF_ITEMS_SYPHON_HOSE = "syphonhose";
MF_ITEMS_JERRYCAN_MAX = ["config_items_jerrycans_max", 1] call getPublicVar;
MF_ITEMS_SYHON_HOSE_MAX = ["config_items_syphon_hose_max", 1] call getPublicVar;
#define build(file) format["%1\%2", _path, file] call mf_compile;

private ["_path","_refill", "_refuel", "_iconJerry", "_iconSyphon"];
_path = _this;

_refill = [_path, "refill.sqf"] call mf_compile;
_refuel = [_path, "refuel.sqf"] call mf_compile;
_syphon = [_path, "syphon.sqf"] call mf_compile;
_iconJerry = "client\icons\jerrycan.paa";
_iconSyphon = "client\icons\syphonhose.paa";

_max = {
	private ["_empty", "_full"];
	_empty = MF_ITEMS_JERRYCAN_EMPTY call mf_inventory_count;
	_full = MF_ITEMS_JERRYCAN_FULL call mf_inventory_count;
	(_empty + _full) >= MF_ITEMS_JERRYCAN_MAX;
};

mf_jerrycan_nearest_pump = {
	_pump_objects = ["Land_FuelStation_Feed_F", "Land_MetalBarrel_F", "Land_fs_feed_F", "Land_Tank_rust_F"];
	_objects = nearestobjects [player, _pump_objects,  3];
	_object = objNull;
	if (count _objects > 0) then {_object = _objects select 0;};
	_object;
} call mf_compile;

mf_jerrycan_nearest_vehicle = {
	["LandVehicle", "Air", "Ship"] call mf_nearest_vehicle
} call mf_compile;


[MF_ITEMS_JERRYCAN_EMPTY, "Empty Jerrycan", _refill, "Land_CanisterFuel_F", _iconJerry, _max] call mf_inventory_create;
[MF_ITEMS_JERRYCAN_FULL, "Full Jerrycan", _refuel, "Land_CanisterFuel_F", _iconJerry, _max] call mf_inventory_create;
[MF_ITEMS_SYPHON_HOSE, "Syphon Hose", _syphon, "Land_CanisterOil_F", _iconSyphon, MF_ITEMS_SYHON_HOSE_MAX] call mf_inventory_create;

mf_jerrycan_can_refill = [_path, "can_refill.sqf"] call mf_compile;
mf_jerrycan_can_refuel = [_path, "can_refuel.sqf"] call mf_compile;
mf_jerrycan_can_syphon = [_path, "can_syphon.sqf"] call mf_compile;

// Setting up refill action.
private ["_label1", "_execute1", "_condition1", "_action1"];
_label1 = format["<img image='%1'/> Fill Jerry Can", _iconJerry];
_execute1 = {MF_ITEMS_JERRYCAN_EMPTY call mf_inventory_use};
_condition1 = format["[] call %1 == ''", mf_jerrycan_can_refill];
_action1 = [_label1, _execute1, [], 1, false, false, "", _condition1];
["jerrycan-refill", _action1] call mf_player_actions_set;

// setting up refuel action
private ["_label2", "_execute2", "_condition2", "_action2"];
_label2 = format["<img image='%1'/> Refuel Vehicle", _iconJerry];
_execute2 = {MF_ITEMS_JERRYCAN_FULL call mf_inventory_use};
_condition2 = format["[] call %1 == ''", mf_jerrycan_can_refuel];
_action2 = [_label2, _execute2, [], 1, false, false, "", _condition2];
["jerrycan-refuel", _action2] call mf_player_actions_set;


// setting up syphon action
private ["_label3", "_execute3", "_condition3", "_action3"];
_label3 = format["<img image='%1'/> Syphon Fuel", _iconSyphon];
_execute3 = {MF_ITEMS_SYPHON_HOSE call mf_inventory_use};
_condition3 = format["[] call %1 == ''", mf_jerrycan_can_syphon];
_action3= [_label3, _execute3, [], 1, false, false, "", _condition3];
["syphon-hose", _action3] call mf_player_actions_set;
