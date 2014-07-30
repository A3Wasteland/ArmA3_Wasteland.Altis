#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "There are not enough funds in the warchest."
#define ERR_LESS_THAN_ONE "The amount must be at least $1"
disableSerialization;
private ["_warchest", "_amount", "_money"];
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};
_amount = floor parseNumber ctrlText IDC_AMOUNT;

ctrlSetText [IDC_AMOUNT, str _amount];

if (_amount < 1) exitWith
{
	[ERR_LESS_THAN_ONE, 5] call mf_notify_client;
	playSound "FD_CP_Not_Clear_F";
};

switch (playerSide) do {
    case east : {
        if (pvar_warchest_funds_east < _amount) exitWith {
            [ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
			playSound "FD_CP_Not_Clear_F";
        };
        pvar_warchest_funds_east = pvar_warchest_funds_east - _amount;
        publicVariable "pvar_warchest_funds_east";
		_money = player getVariable ["cmoney", 0];
		player setVariable["cmoney",(_money + _amount),true];
		playSound "defaultNotification";
		call mf_items_warchest_refresh;
    };
    case west : {
        if (pvar_warchest_funds_west < _amount) exitWith {
            [ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
			playSound "FD_CP_Not_Clear_F";
        };
        pvar_warchest_funds_west = pvar_warchest_funds_west - _amount;
        publicVariable "pvar_warchest_funds_west";
		_money = player getVariable ["cmoney", 0];
		player setVariable["cmoney",(_money + _amount),true];
		playSound "defaultNotification";
		call mf_items_warchest_refresh;
    };
    default {hint "WarchestRefrest - This Shouldnt Happen"};
};

if (["A3W_playerSaving"] call isConfigOn) then
{
	[] spawn fn_savePlayerData;
};
