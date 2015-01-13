// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: access.sqf
//	@file Author: AgentRev, MercifulFate
//	@file Function: mf_items_cratemoney_access

#include "defines.sqf"
disableSerialization;

private ["_dialog", "_menuTitle", "_fundsTitle", "_withdraw", "_deposit"];

if (isNull findDisplay IDD_WARCHEST) then
{
	createDialog "WarchestDialog";
	_dialog = findDisplay IDD_WARCHEST;

	_menuTitle = _dialog displayCtrl IDC_MENUTITLE;
	_menuTitle ctrlSetText "Money Stash";

	//_fundsTitle = _dialog displayCtrl IDC_FUNDSTITLE;
	//_fundsTitle ctrlSetText "Funds:";

	_withdraw = _dialog displayCtrl IDC_WITHDRAWBUTTON;
	_withdraw buttonSetAction "call mf_items_cratemoney_withdraw";

	_deposit = _dialog displayCtrl IDC_DEPOSITBUTTON;
	_deposit buttonSetAction "call mf_items_cratemoney_deposit";
};

[] spawn
{
	disableSerialization;
	_dialog = findDisplay IDD_WARCHEST;
	while {!isNull _dialog} do
	{
		_escMenu = findDisplay 49;
		if (!isNull _escMenu) then { _escMenu closeDisplay 0 }; // Force close Esc menu if open
		call mf_items_cratemoney_refresh;
		uiSleep 0.1;
	};
};
