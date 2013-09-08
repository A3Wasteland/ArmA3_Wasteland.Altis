#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "There is not enough funds in the warchest."
disableSerialization;
private ["_warchest", "_amount", "_money"];
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};
_amount = round(parseNumber(ctrlText IDC_AMOUNT));

switch (playerSide) do {
    case east : {
        if (pvar_warchest_funds_east < _amount) exitWith {
            [ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
        };
        pvar_warchest_funds_east = pvar_warchest_funds_east - _amount;
        publicVariable "pvar_warchest_funds_east";
		_money = player getVariable ["cmoney", 0];
		player setVariable["cmoney",(_money + _amount),true];
		call mf_items_warchest_refresh;
    };
    case west : {
        if (pvar_warchest_funds_west < _amount) exitWith {
            [ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
        };
        pvar_warchest_funds_west = pvar_warchest_funds_west - _amount;
        publicVariable "pvar_warchest_funds_west";
		_money = player getVariable ["cmoney", 0];
		player setVariable["cmoney",(_money + _amount),true];
		call mf_items_warchest_refresh;
    };
    default {hint "WarchestRefrest - This Shouldnt Happen"};
};
