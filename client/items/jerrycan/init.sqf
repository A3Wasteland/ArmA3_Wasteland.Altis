//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Initialize Jerrycans
//@file Argument: The path of the directory holding this file.

MF_ITEMS_JERRYCAN_EMPTY = "jerrycan_empty";
MF_ITEMS_JERRYCAN_FULL = "jerrycan_full";
MF_ITEMS_JERRYCAN_MAX = 1;
#define build(file) format["%1\%2", _path, file] call mf_compile;

private ["_path","_refill", "_refuel", "_icon"];
_path = _this;

_refill = [_path, "refill.sqf"] call mf_compile;
_refuel = [_path, "refuel.sqf"] call mf_compile;
_icon = "client\icons\jerrycan.paa";
_max = {
    private ["_empty", "_full"];
    _empty = MF_ITEMS_JERRYCAN_EMPTY call mf_inventory_count;
    _full = MF_ITEMS_JERRYCAN_FULL call mf_inventory_count;
    (_empty + _full) >= MF_ITEMS_JERRYCAN_MAX;
};

mf_jerrycan_nearest_pump = {
    _objects = nearestobjects [player, ["Land_FuelStation_Feed_F", "Land_MetalBarrel_F", "Land_fs_feed_F", "Land_Tank_rust_F"],  3];
    _object = objNull;
    if (count _objects > 0) then {_object = _objects select 0;};
    _object;
};

mf_jerrycan_nearest_vehicle = {
    _objects = nearestObjects[player, ["LandVehicle", "Air", "Ship"], 5];
    _object = objNull;
    if (count _objects > 0) then {_object = _objects select 0;};
    _object;
};

mf_remote_refuel = {
    private ["_vehicle", "_qty", "_fuel"];
    _vehicle = objectFromNetId (_this select 0);
    _qty = 0.25;
    switch true do {
        case (_vehicle isKindOf "Air"): {_qty = 0.10};
        case (_vehicle isKindOf "Tank"): {_qty = 0.10};
        case (_vehicle isKindOf "Motorcycle"): {_qty = 0.75};
        case (_vehicle isKindOf "ATV_Base_EP1"): {_qty = 0.75};
    };
    _fuel = fuel _vehicle + _qty;
    if (_fuel > 1) then {_fuel = 1.0}; 
	_vehicle setFuel _fuel;
};

[MF_ITEMS_JERRYCAN_EMPTY, "Empty Jerrycan", _refill, "Land_CanisterFuel_F", _icon, _max] call mf_inventory_create;
[MF_ITEMS_JERRYCAN_FULL, "Full Jerrycan", _refuel, "Land_CanisterFuel_F", _icon, _max] call mf_inventory_create;

mf_jerrycan_can_refill = compile preProcessFileLineNumbers format["%1\can_refill.sqf", _path];
mf_jerrycan_can_refuel = compile preProcessFileLineNumbers format["%1\can_refuel.sqf", _path];

// Setting up refill action.
private ["_label1", "_execute1", "_condition1", "_action1"];
_label1 = format["<img image='%1' width='32' height='32'/> Fill Jerry Can", _icon];
_execute1 = {MF_ITEMS_JERRYCAN_EMPTY call mf_inventory_use};
_condition1 = format["[] call %1 == ''", mf_jerrycan_can_refill];
_action1 = [_label1, _execute1, [], 1, false, false, "", _condition1];
["jerrycan-refill", _action1] call mf_player_actions_set;

// setting up refuel action
private ["_label2", "_execute2", "_condition2", "_action2"];
_label2 = format["<img image='%1' width='32' height='32'/> Refuel Vehicle", _icon];
_execute2 = {MF_ITEMS_JERRYCAN_FULL call mf_inventory_use};
_condition2 = format["[] call %1 == ''", mf_jerrycan_can_refuel];
_action2 = [_label2, _execute2, [], 1, false, false, "", _condition2];
["jerrycan-refuel", _action2] call mf_player_actions_set;