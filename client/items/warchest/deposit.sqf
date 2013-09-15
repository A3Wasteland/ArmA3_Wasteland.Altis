#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "You dont have enough money."
private ["_warchest", "_amount", "_money"];
disableSerialization;
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};

_amount = round (parseNumber (ctrlText IDC_AMOUNT));
_money = player getVariable ["cmoney", 0];

if (_money < _amount) exitWith {
    [ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
};
player setVariable["cmoney",(_money - _amount),true];

switch (playerSide) do {
    case east : {
    	pvar_warchest_funds_east = pvar_warchest_funds_east + _amount;
    	publicVariable "pvar_warchest_funds_east";
    };
    case west : {
    	pvar_warchest_funds_west = pvar_warchest_funds_west + _amount;
    	publicVariable "pvar_warchest_funds_west";
    };
    default {hint "WarchestRefrest - This Shouldnt Happen"};
};

call mf_items_warchest_refresh;