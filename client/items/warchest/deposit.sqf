// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "You don't have enough money."
#define ERR_LESS_THAN_ONE "The amount must be at least $1"
disableSerialization;
private ["_warchest", "_input", "_amount", "_money"];
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};

_input = _warchest displayCtrl IDC_AMOUNT;
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

	player setVariable["cmoney", _money - _amount, true];

	switch (playerSide) do
	{
		case EAST:
		{
			pvar_warchest_funds_east = pvar_warchest_funds_east + _amount;
			publicVariable "pvar_warchest_funds_east";
			playSound "defaultNotification";
		};
		case WEST:
		{
			pvar_warchest_funds_west = pvar_warchest_funds_west + _amount;
			publicVariable "pvar_warchest_funds_west";
			playSound "defaultNotification";
		};
		default {hint "Warchest Deposit - This Shouldnt Happen"};
	};

	if (["A3W_playerSaving"] call isConfigOn) then
	{
		[] spawn fn_savePlayerData;
	};
};

call mf_items_warchest_refresh;
