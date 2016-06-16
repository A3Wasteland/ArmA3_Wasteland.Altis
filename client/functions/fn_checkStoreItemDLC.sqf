// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_checkStoreItemDLC.sqf
//	@file Author: AgentRev

params ["_itemArr", "_parentCfg", "_listbox", "_lbIndex"];

if ("noDLC" in (_itemArr select [3,999])) exitWith {};

_itemArr params ["", "_class"];

private _addons = configSourceAddonList (_parentCfg >> _class);
if (_addons isEqualTo []) exitWith {};

private _mods = configSourceModList (configFile >> "CfgPatches" >> _addons select ([0, count _addons - 1] select (_class find "_FullGhillie_" != -1)));
if (_mods isEqualTo []) exitWith {};

private _itemMod = _mods select 0;
if (_itemMod isEqualTo "") exitWith {};

_listbox lbSetPictureRight [_lbIndex, (modParams [_itemMod, ["logo"]]) param [0,""]];
_listbox lbSetTooltip [_lbIndex, (modParams [_itemMod, ["name"]]) param [0,""]];
