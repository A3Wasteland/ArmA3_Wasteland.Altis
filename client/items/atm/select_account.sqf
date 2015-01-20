// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: select_account.sqf
//	@file Author: AgentRev
//	@file Function: mf_items_atm_select_account

#include "gui_defines.hpp"
disableSerialization;

private ["_accDropdown", "_curSel", "_dialog", "_deposit", "_withdraw", "_selAcc", "_accDropdown", "_feeText", "_totalText", "_players", "_oldPlayers", "_strPlayers", "_selData", "_selAcc", "_idx", "_data", "_selIdx", "_amount", "_fee", "_deposit", "_withdraw"];

_accDropdown = _this select 0;
_curSel = _this select 1;
_dialog = ctrlParent _accDropdown;

_deposit = _dialog displayCtrl AtmDepositButton_IDC;
_withdraw = _dialog displayCtrl AtmWithdrawButton_IDC;

_selAcc = call compile (_accDropdown lbData _curSel);

if (!isNil "_selAcc" && {_selAcc != player}) then
{
	_deposit ctrlSetText "Transfer";
	_deposit buttonSetAction "call mf_items_atm_transfer";
	if (ctrlShown _withdraw) then { _withdraw ctrlShow false };
}
else
{
	_deposit ctrlSetText "Deposit";
	_deposit buttonSetAction "call mf_items_atm_deposit";
	if (!ctrlShown _withdraw) then { _withdraw ctrlShow true };
};

call mf_items_atm_refresh_amounts;
