// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "There are not enough funds in the warchest."
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

	switch (playerSide) do
	{
		case EAST:
		{
			if (pvar_warchest_funds_east < _amount) exitWith
			{
				[ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
				playSound "FD_CP_Not_Clear_F";
			};
			pvar_warchest_funds_east = pvar_warchest_funds_east - _amount;
			publicVariable "pvar_warchest_funds_east";
			player setVariable["cmoney", _money + _amount, true];
			playSound "defaultNotification";
		};
		case WEST:
		{
			if (pvar_warchest_funds_west < _amount) exitWith
			{
				[ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
				playSound "FD_CP_Not_Clear_F";
			};
			pvar_warchest_funds_west = pvar_warchest_funds_west - _amount;
			publicVariable "pvar_warchest_funds_west";
			_money = player getVariable ["cmoney", 0];
			player setVariable["cmoney", _money + _amount, true];
			playSound "defaultNotification";
		};
		default {hint "Warchest Withdraw - This Shouldnt Happen"};
	};

	if (["A3W_playerSaving"] call isConfigOn) then
	{
		[] spawn fn_savePlayerData;
	};
};

call mf_items_warchest_refresh;
