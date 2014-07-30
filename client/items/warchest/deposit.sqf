#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "You don't have enough money."
#define ERR_LESS_THAN_ONE "The amount must be at least $1"
private ["_warchest", "_amount", "_money"];
disableSerialization;
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};
_amount = floor parseNumber ctrlText IDC_AMOUNT;

ctrlSetText [IDC_AMOUNT, str _amount];

if (_amount < 1) exitWith
{
	[ERR_LESS_THAN_ONE, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

_money = player getVariable ["cmoney", 0];

if (_money < _amount) exitWith {
    [ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};
player setVariable["cmoney",(_money - _amount),true];

switch (playerSide) do {
    case east : {
    	pvar_warchest_funds_east = pvar_warchest_funds_east + _amount;
    	publicVariable "pvar_warchest_funds_east";
		playSound "defaultNotification";
    };
    case west : {
    	pvar_warchest_funds_west = pvar_warchest_funds_west + _amount;
    	publicVariable "pvar_warchest_funds_west";
		playSound "defaultNotification";
    };
    default {hint "WarchestRefrest - This Shouldnt Happen"};
};

call mf_items_warchest_refresh;

if (["A3W_playerSaving"] call isConfigOn) then
{
	[] spawn fn_savePlayerData;
};
