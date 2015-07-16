// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "defines.sqf"
disableSerialization;
private ["_warchest", "_funds", "_text"];
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};

_funds = -1;
switch (playerSide) do
{
	case EAST: { _funds = pvar_warchest_funds_east };
	case WEST: { _funds = pvar_warchest_funds_west };
	default {hint "WarchestRefrest - This Shouldnt Happen"};
};

_text = _warchest displayCtrl IDC_FUNDS;
_text ctrlSetText format ["$%1", [_funds] call fn_numbersText];
