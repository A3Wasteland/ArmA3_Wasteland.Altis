// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: withdraw.sqf
//	@file Author: AgentRev, MercifulFate
//	@file Function: mf_items_cratemoney_withdraw

#include "defines.sqf"

#define ERR_NOT_ENOUGH_FUNDS "There are not enough funds in the stash."

disableSerialization;
private ["_crate", "_dialog", "_input", "_amount"];

_crate = call mf_items_cratemoney_nearest;
_dialog = findDisplay IDD_WARCHEST;

if (isNull _dialog) exitWith {};
if (isNull _crate) exitWith { closeDialog IDD_WARCHEST };

_input = _dialog displayCtrl IDC_AMOUNT;
_amount = _input call mf_verify_money_input;

if (_amount < 1) exitWith {};

if (_crate getVariable ["cmoney", 0] < _amount) exitWith
{
	[ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

// pvar_processTransaction = ["crateMoney", player, netId _crate, -_amount];
// publicVariableServer "pvar_processTransaction";
["crateMoney", player, _crate, -_amount] call A3W_fnc_processTransaction;
