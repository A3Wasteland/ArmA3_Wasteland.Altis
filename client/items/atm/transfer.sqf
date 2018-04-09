// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: transfer.sqf
//	@file Author: AgentRev
//	@file Function: mf_items_atm_transfer

#include "gui_defines.hpp"

#define ERR_NOT_ENOUGH_FUNDS "You don't have enough money in your account."
#define ERR_INVALID_ACCOUNT "The selected account is invalid."
#define ERR_MAX_BALANCE_REACHED "The selected account has reached its maximum balance.\nYou cannot send any more money to it."
#define ERR_MAX_BALANCE_LIMIT "Due to balance restrictions, you cannot transfer more than $%1 to this account."

#define MSG_CONFIRM_LINE1 "You are about to transfer $%1 to %2."
#define MSG_CONFIRM_LINE2 "Transfer fee: $%2"
#define MSG_CONFIRM_LINE3 "Total cost: $%1"

disableSerialization;
private ["_dialog", "_input", "_accDropdown", "_selAcc", "_selAccName", "_amount", "_fee", "_feeAmount", "_total", "_balance", "_maxBalance", "_destBalance", "_confirmMsg", "_transferKey", "_deposit", "_withdraw", "_controls"];

_dialog = findDisplay AtmGUI_IDD;

if (isNull _dialog) exitWith {};

_input = _dialog displayCtrl AtmAmountInput_IDC;
_accDropdown = _dialog displayCtrl AtmAccountDropdown_IDC;
_selAcc = call compile (_accDropdown lbData lbCurSel _accDropdown);

if (isNil "_selAcc" || {!isPlayer _selAcc || _selAcc == player}) exitWith
{
	[ERR_INVALID_ACCOUNT, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

_selAccName = name _selAcc;

_amount = _input call mf_verify_money_input;

if (_amount < 1) exitWith {};

_fee = (["A3W_atmTransferFee", 5] call getPublicVar) max 0 min 50;
_feeAmount = ceil (_amount * (_fee / 100));
_total = _amount + _feeAmount;
_balance = player getVariable ["bmoney", 0];

if (_balance < _total) exitWith
{
	[ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

_maxBalance = ["A3W_atmMaxBalance", 1000000] call getPublicVar;
_destBalance = _selAcc getVariable ["bmoney", 0];

if (_destBalance >= _maxBalance) exitWith
{
	[ERR_MAX_BALANCE_REACHED, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

if (_destBalance + _total > _maxBalance) exitWith
{
	[format [ERR_MAX_BALANCE_LIMIT, [_maxBalance - _destBalance] call fn_numbersText], 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

_confirmMsg = format [MSG_CONFIRM_LINE1 + "<br/>", [_amount] call fn_numbersText, _selAccName] +
(if (_feeAmount > 0) then { format [MSG_CONFIRM_LINE2 + "<br/>", (_fee call fn_numToStr) + "%", [_feeAmount] call fn_numbersText] } else { "" }) +
format [MSG_CONFIRM_LINE3, [_total] call fn_numbersText];

[_confirmMsg, _selAcc, _amount, _feeAmount] spawn
{
	disableSerialization;
	_confirmMsg = _this select 0;
	_selAcc = _this select 1;
	_amount = _this select 2;
	_feeAmount = _this select 3;

	if !([_confirmMsg, "Confirm", true, true] call BIS_fnc_guiMessage) exitWith {};

	player setVariable ["bmoney", (player getVariable ["bmoney", 0]) - (_amount + _feeAmount), false];
	false call mf_items_atm_refresh;

	_transferKey = call A3W_fnc_generateKey + "_atmTransfer";
	player setVariable [_transferKey, true, false];

	// pvar_processTransaction = ["atmTranfer", player, _selAcc, _amount, _feeAmount, _transferKey];
	// publicVariableServer "pvar_processTransaction";
	["atmTranfer", player, _selAcc, _amount, _feeAmount, _transferKey] call A3W_fnc_processTransaction;

	_dialog = findDisplay AtmGUI_IDD;
	_input = _dialog displayCtrl AtmAmountInput_IDC;
	_accDropdown = _dialog displayCtrl AtmAccountDropdown_IDC;
	_deposit = _dialog displayCtrl AtmDepositButton_IDC;
	_withdraw = _dialog displayCtrl AtmWithdrawButton_IDC;
	_controls = [_input, _accDropdown, _deposit, _withdraw];

	{ _x ctrlEnable false } forEach _controls;

	waitUntil {uiSleep 0.1; !(player getVariable [_transferKey, false]) || isNull _dialog};

	if (isNull _dialog) exitWith {};

	{ if (!ctrlEnabled _x) then { _x ctrlEnable true } } forEach _controls;
};
