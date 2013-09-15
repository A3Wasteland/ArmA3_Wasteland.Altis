#define BUILD(x) format["%1\%2", _this, x] call mf_compile
private ["_path"];
_path = _this;

MF_ITEMS_WARCHEST = "warchest";
MF_ITEMS_WARCHEST_OBJECT_TYPE = "Land_CashDesk_F";
MF_ITEMS_WARCHEST_ACCESS_RANGE = 4;
MF_ITEMS_WARCHEST_DEPLOY_DURATION = 30;
MF_ITEMS_WARCHEST_PACK_DURATION = 30;
MF_ITEMS_WARCHEST_HACK_DURATION = 60;

mf_items_warchest_deploy = [_path, "deploy.sqf"] call mf_compile;
mf_items_warchest_nearest = [_path, "nearest.sqf"] call mf_compile;

mf_items_warchest_access = [_path, "access.sqf"] call mf_compile;
mf_items_warchest_hack = [_path, "hack.sqf"] call mf_compile;
mf_items_warchest_pack = [_path, "pack.sqf"] call mf_compile;

mf_items_warchest_can_access = [_path, "can_access.sqf"] call mf_compile;
mf_items_warchest_can_hack = [_path, "can_hack.sqf"] call mf_compile;
mf_items_warchest_can_pack = [_path, "can_pack.sqf"] call mf_compile;

mf_items_warchest_refresh = [_path, "refresh.sqf"] call mf_compile;
mf_items_warchest_withdraw = [_path, "withdraw.sqf"] call mf_compile;
mf_items_warchest_deposit = [_path, "deposit.sqf"] call mf_compile;

private ["_icon", "_condition", "_action"];
_icon = "/client/icons/breifcase.paa";
[MF_ITEMS_WARCHEST, "Warchest", mf_items_warchest_deploy, "Land_SuitCase_F", _icon, 1] call mf_inventory_create;

private ["_condition", "_action"];
_condition = "'' == [] call mf_items_warchest_can_access;";
_action = ["Access Warchest", mf_items_warchest_access, nil, 2, true, false, "", _condition];
["warchest-access", _action] call mf_player_actions_set;

_condition = "'' == [] call mf_items_warchest_can_pack;";
_action = ["Pack Warchest", mf_items_warchest_pack, nil, 1, true, false, "", _condition];
["warchest-pack", _action] call mf_player_actions_set;

_condition = "'' == [] call mf_items_warchest_can_hack;";
_action = ["Hack Warchest", mf_items_warchest_hack, nil, 2, true, false, "", _condition];
["warchest-hack", _action] call mf_player_actions_set;
