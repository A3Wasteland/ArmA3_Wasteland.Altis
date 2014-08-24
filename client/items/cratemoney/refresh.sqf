//	@file Name: refresh.sqf
//	@file Author: AgentRev, MercifulFate
//	@file Function: mf_items_cratemoney_refresh

#include "defines.sqf"
disableSerialization;

private ["_crate", "_dialog", "_funds"];

_crate = call mf_items_cratemoney_nearest;
_dialog = findDisplay IDD_WARCHEST;

if (isNull _dialog) exitWith {};
if (isNull _crate) exitWith { closeDialog IDD_WARCHEST };

_funds = _dialog displayCtrl IDC_FUNDS;
_funds ctrlSetText format ["$%1", _crate getVariable ["cmoney", 0]];
