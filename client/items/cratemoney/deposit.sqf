// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: deposit.sqf
//	@file Author: AgentRev, MercifulFate
//	@file Function: mf_items_cratemoney_deposit

#include "defines.sqf"

#define ERR_NOT_ENOUGH_FUNDS "You don't have enough money."
#define ERR_LESS_THAN_ONE "The amount must be at least $1"

disableSerialization;
private ["_crate", "_dialog", "_input", "_amount", "_money"];

_crate = call mf_items_cratemoney_nearest;
_dialog = findDisplay IDD_WARCHEST;

if (isNull _dialog) exitWith {};
if (isNull _crate) exitWith { closeDialog IDD_WARCHEST };

_input = _dialog displayCtrl IDC_AMOUNT;
_amount = floor parseNumber ctrlText _input;

if (_amount < 1) then
{
	[ERR_LESS_THAN_ONE, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
}
else
{
	_money = player getVariable ["cmoney", 0];

	if (_money < _amount) exitWith
	{
		[ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
		playSound "FD_CP_Not_Clear_F";
	};

	player setVariable ["cmoney", _money - _amount, true];
	_crate setVariable ["cmoney", (_crate getVariable ["cmoney", 0]) + _amount, true];

	playSound "defaultNotification";

	if (["A3W_playerSaving"] call isConfigOn) then
	{
		[] spawn fn_savePlayerData;
	};
};

call mf_items_cratemoney_refresh;
