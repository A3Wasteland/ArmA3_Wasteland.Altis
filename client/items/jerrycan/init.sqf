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

private ["_path","_refill", "_refuel", "_icon"];
_path = _this;

_refill = [_path, "refill.sqf"] call mf_compile;
_refuel = [_path, "refuel.sqf"] call mf_compile;
_syphon = [_path, "syphon.sqf"] call mf_compile;
_icon = "client\icons\jerrycan.paa";

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

mf_jerrycan_fuel_amount = {
	private ["_vehicle", "_fuel_amount", "_config", "_type"];
	_vehicle = _this select 0;
	_fuel_amount = ["config_refuel_amount_default", 0.25] call getPublicVar;
	{
		_type = _x select 0;
		if (_vehicle isKindOf _type ) exitWith
		{
			_fuel_amount = _x select 1;
		};
	} forEach (["config_refuel_amounts", []] call getPublicVar);
	_fuel_amount;
} call mf_compile;

mf_remote_refuel = {
    private ["_vehicle", "_qty", "_fuel"];
    _vehicle = objectFromNetId (_this select 0);
    _fuel = fuel _vehicle + ([_vehicle] call mf_jerrycan_fuel_amount);
	_vehicle setFuel (_fuel min 1);
} call mf_compile;

mf_remote_syphon = {
    private ["_vehicle", "_qty", "_fuel"];
    _vehicle = objectFromNetId (_this select 0);
    _fuel = fuel _vehicle - ([_vehicle] call mf_jerrycan_fuel_amount);
	_vehicle setFuel (_fuel max 0);
} call mf_compile;


[MF_ITEMS_JERRYCAN_EMPTY, "Empty Jerrycan", _refill, "Land_CanisterFuel_F", _icon, _max] call mf_inventory_create;
[MF_ITEMS_JERRYCAN_FULL, "Full Jerrycan", _refuel, "Land_CanisterFuel_F", _icon, _max] call mf_inventory_create;
[MF_ITEMS_SYPHON_HOSE, "Syphon Hose", _syphon, "Land_CanisterOil_F", _icon, MF_ITEMS_SYHON_HOSE_MAX] call mf_inventory_create;

mf_jerrycan_can_refill = compileFinal preProcessFileLineNumbers format["%1\can_refill.sqf", _path];
mf_jerrycan_can_refuel = compileFinal preProcessFileLineNumbers format["%1\can_refuel.sqf", _path];
mf_jerrycan_can_syphon = compileFinal preProcessFileLineNumbers format["%1\can_syphon.sqf", _path];

// Setting up refill action.
private ["_label1", "_execute1", "_condition1", "_action1"];
_label1 = format["<img image='%1'/> Fill Jerry Can", _icon];
_execute1 = {MF_ITEMS_JERRYCAN_EMPTY call mf_inventory_use};
_condition1 = format["[] call %1 == ''", mf_jerrycan_can_refill];
_action1 = [_label1, _execute1, [], 1, false, false, "", _condition1];
["jerrycan-refill", _action1] call mf_player_actions_set;

// setting up refuel action
private ["_label2", "_execute2", "_condition2", "_action2"];
_label2 = format["<img image='%1'/> Refuel Vehicle", _icon];
_execute2 = {MF_ITEMS_JERRYCAN_FULL call mf_inventory_use};
_condition2 = format["[] call %1 == ''", mf_jerrycan_can_refuel];
_action2 = [_label2, _execute2, [], 1, false, false, "", _condition2];
["jerrycan-refuel", _action2] call mf_player_actions_set;


// setting up syphon action
private ["_label3", "_execute3", "_condition3", "_action3"];
_label3 = format["<img image='%1'/> Syphon Fuel", _icon];
_execute3 = {MF_ITEMS_SYPHON_HOSE call mf_inventory_use};
_condition3 = format["[] call %1 == ''", mf_jerrycan_can_syphon];
_action3= [_label3, _execute3, [], 1, false, false, "", _condition3];
["syphon-hose", _action3] call mf_player_actions_set;
