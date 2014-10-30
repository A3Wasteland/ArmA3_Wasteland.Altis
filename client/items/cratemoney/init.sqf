// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: init.sqf
//	@file Author: AgentRev, MercifulFate

private ["_path", "_condition", "_action"];
_path = "client\items\cratemoney";

mf_items_cratemoney_can_access = [_path, "can_access.sqf"] call mf_compile;

mf_items_cratemoney_access = [_path, "access.sqf"] call mf_compile;
mf_items_cratemoney_refresh = [_path, "refresh.sqf"] call mf_compile;

mf_items_cratemoney_deposit = [_path, "deposit.sqf"] call mf_compile;
mf_items_cratemoney_withdraw = [_path, "withdraw.sqf"] call mf_compile;

mf_items_cratemoney_nearest =
{
	private "_target";
	_target = cursorTarget;
	if (player distance _target <= 3 && {_target isKindOf "ReammoBox_F"}) then { _target } else { objNull }
} call mf_compile;


_condition = "call mf_items_cratemoney_can_access == '' && (call mf_items_cratemoney_nearest) getVariable ['cmoney', 0] == 0";
_action = ["<img image='client\icons\money.paa'/> Deposit Money", mf_items_cratemoney_access, [], 2, false, true, "", _condition];
["cratemoney-access-empty", _action] call mf_player_actions_set;

_condition = "call mf_items_cratemoney_can_access == '' && (call mf_items_cratemoney_nearest) getVariable ['cmoney', 0] != 0";
_action = ["<img image='client\icons\money.paa'/> Access Money Stash", mf_items_cratemoney_access, [], 2, false, true, "", _condition];
["cratemoney-access", _action] call mf_player_actions_set;
