//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Initialize Miscellaneous Items
//@file Argument: the path of the directory holding this file
_path = _this;

MF_ITEMS_REPAIR_KIT_RANGE = 5;

// MF_ITEMS_MEDKIT = "medkit";
// _heal = [_path, "heal.sqf"] call mf_compile;
// [MF_ITEMS_MEDKIT, "Medkit", _heal, "Land_SuitCase_F","client\icons\medkit.paa",2] call mf_inventory_create;

MF_ITEMS_REPAIR_KIT = "repairkit";
_repair = [_path, "repair.sqf"] call mf_compile;
_icon = "client\icons\repair.paa";
[MF_ITEMS_REPAIR_KIT, "Repair Kit", _repair, "Land_SuitCase_F",_icon,2] call mf_inventory_create;

mf_nearest_vehicle = {
	private ["_types", "_obj", "_dist"];
	_types = _this;
	_obj = cursorTarget;
	if (!isNull _obj && {player distance _obj > (sizeOf typeOf _obj / 2) max 2 || {_obj isKindOf _x} count _types == 0}) then { _obj = objNull };
	_obj
} call mf_compile;

mf_repair_nearest_vehicle = {
	["LandVehicle", "Air", "Ship"] call mf_nearest_vehicle
} call mf_compile;

mf_remote_repair = {
	private "_vehicle";
	_vehicle = objectFromNetId (_this select 0);
	_vehicle setDamage 0;
	if (_vehicle isKindOf "Boat_Armed_01_base_F" && count (_vehicle magazinesTurret [0]) == 0) then { _vehicle setHitPointDamage ["HitTurret", 1] }; // disable front GMG on speedboats
} call mf_compile;

// Setting up repairing action.
_can_repair = compile preProcessFileLineNumbers format["%1\can_repair.sqf", _path];
private ["_label1", "_execute1", "_condition1", "_action1"];
_label1 = format["<img image='%1'/> Repair Vehicle", _icon];
_execute1 = {MF_ITEMS_REPAIR_KIT call mf_inventory_use};
_condition1 = format["[] call %1 == ''", _can_repair];
_action1 = [_label1, _execute1, [], 1, false, false, "", _condition1];
["repairkit-use", _action1] call mf_player_actions_set;
