// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: init.sqf
//	@file Author: AgentRev, MercifulFate

private ["_path", "_condition", "_action"];
_path = "client\items\atm";

mf_items_atm_can_access = [_path, "can_access.sqf"] call mf_compile;

mf_items_atm_access = [_path, "access.sqf"] call mf_compile;
mf_items_atm_refresh = [_path, "refresh.sqf"] call mf_compile;
mf_items_atm_refresh_amounts = [_path, "refresh_amounts.sqf"] call mf_compile;
mf_items_atm_select_account = [_path, "select_account.sqf"] call mf_compile;

mf_items_atm_deposit = [_path, "deposit.sqf"] call mf_compile;
mf_items_atm_withdraw = [_path, "withdraw.sqf"] call mf_compile;
mf_items_atm_transfer = [_path, "transfer.sqf"] call mf_compile;

mf_items_atm_nearest =
{
	private _target = cursorObject;
	if ((str _target) find ": atm_" == -1 && {{_target isKindOf _x} count ["Land_Atm_01_F","Land_Atm_02_F"] == 0}) exitWith { objNull };
	if (!(_target getVariable ["A3W_atmEditorPlaced", false]) && ["A3W_atmEditorPlacedOnly"] call isConfigOn) exitWith { objNull };
	_target
} call mf_compile;


_condition = "call mf_items_atm_can_access == ''";
_action = ["<img image='client\icons\suatmm_icon.paa'/> Access ATM", mf_items_atm_access, [], 10, true, true, "", _condition];
["atm-access", _action] call mf_player_actions_set;
