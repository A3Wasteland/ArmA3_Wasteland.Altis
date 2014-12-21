// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "You don't have enough money."
#define ERR_LESS_THAN_ONE "The amount must be at least $1"
disableSerialization;
private ["_dialog", "_input", "_amount", "_money"];
_dialog = findDisplay IDD_WARCHEST;
if (isNull _dialog) exitWith {};

_input = _dialog displayCtrl IDC_AMOUNT;
_amount = floor parseNumber ctrlText _input;
_input ctrlSetText (_amount call fn_numToStr);

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

	pvar_processTransaction = ["warchest", player, _amount];
	publicVariableServer "pvar_processTransaction";
};
