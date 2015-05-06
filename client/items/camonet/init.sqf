// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//@file Version: 1.0
//@file Name: init.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Initialize Camo Net
//@file Argument: the path to the directory holding this file.
private ["_path","_ground_type", "_icon", "_unpack", "_pack"];
_path = _this;

MF_ITEMS_CAMO_NET = "camonet";
MF_ITEMS_CAMO_NET_TYPE = "CamoNet_INDP_open_F";
_ground_type = "Land_Ground_sheet_folded_OPFOR_F";
_icon = "client\icons\camonet.paa";

_pack = [_path, "pack.sqf"] call mf_compile;
_unpack = [_path, "unpack.sqf"] call mf_compile;
mf_items_camo_net_can_pack = [_path, "can_pack.sqf"] call mf_compile;
mf_items_camo_net_nearest = {
	_camonet = objNull;
	_camonets = nearestObjects [player, [MF_ITEMS_CAMO_NET_TYPE], 3];
	if (count _camonets > 0) then {
		_camonet = _camonets select 0;
	};
	_camonet;
} call mf_compile;

[MF_ITEMS_CAMO_NET, "Camo Net", _unpack, _ground_type, _icon, 1] call mf_inventory_create;

private ["_label", "_condition", "_action"];
_label = format["<img image='%1' /> Pack up Camouflage Netting", _icon];
_condition = "'' == [] call mf_items_camo_net_can_pack;";
_action = [_label, _pack, [], 1, true, false, "", _condition];
["camonet-pack", _action] call mf_player_actions_set;

