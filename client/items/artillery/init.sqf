// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: init.sqf
//	@file Author: AgentRev

private _path = _this;
private _icon = "client\icons\tablet.paa";

[
	"artillery",
	"Artillery Strike",
	[_path, "artilleryMenu.sqf"] call mf_compile,
	"Land_Tablet_02_F",
	_icon,
	1
] call mf_inventory_create;

private _take = [_path, "takeFromCrate.sqf"] call mf_compile;
mf_items_artillery_canTakeFromCrate = [_path, "canTakeFromCrate.sqf"] call mf_compile;
mf_items_artillery_checkCooldown = [_path, "checkCooldown.sqf"] call mf_compile;

private _label = format ["<img image='%1'/> Take Artillery Strike from crate", _icon];
private _action = [_label, _take, [], 5.05, false, false, "", "call mf_items_artillery_canTakeFromCrate == ''"];
["artillery-takeFromCrate", _action] call mf_player_actions_set;
