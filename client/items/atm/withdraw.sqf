// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: withdraw.sqf
//	@file Author: AgentRev
//	@file Function: mf_items_atm_withdraw

#include "gui_defines.hpp"

#define ERR_NOT_ENOUGH_FUNDS "There are not enough funds in your account."

disableSerialization;
private ["_dialog", "_input", "_amount"];

_dialog = findDisplay AtmGUI_IDD;

if (isNull _dialog) exitWith {};

_input = _dialog displayCtrl AtmAmountInput_IDC;
_amount = _input call mf_verify_money_input;

if (_amount < 1) exitWith {};

if (player getVariable ["bmoney", 0] < _amount) exitWith
{
	[ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

// pvar_processTransaction = ["atm", player, -_amount];
// publicVariableServer "pvar_processTransaction";
["atm", player, -_amount] call A3W_fnc_processTransaction;
