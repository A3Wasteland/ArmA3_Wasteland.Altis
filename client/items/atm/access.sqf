// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: access.sqf
//	@file Author: AgentRev
//	@file Function: mf_items_atm_access

#include "gui_defines.hpp"

([[],
{
	disableSerialization;

	if (isNull findDisplay AtmGUI_IDD) then
	{
		uiNamespace setVariable ["A3W_AtmGUI_players", nil];
		createDialog "AtmGUI";
	};

	true call mf_items_atm_refresh;
	_dialog = findDisplay AtmGUI_IDD;

	_accDropdown = _dialog displayCtrl AtmAccountDropdown_IDC;
	[_accDropdown, lbCurSel _accDropdown] call mf_items_atm_select_account;
	_accDropdown ctrlAddEventHandler ["LBSelChanged", mf_items_atm_select_account];

	_input = _dialog displayCtrl AtmAmountInput_IDC;
	_input ctrlAddEventHandler ["KeyUp", mf_items_atm_refresh_amounts];
	ctrlSetFocus _input;
}] execFSM "call.fsm")
spawn
{
	disableSerialization;
	waitUntil {completedFSM _this};

	_dialog = findDisplay AtmGUI_IDD;
	_time = diag_tickTime;

	while {!isNull _dialog} do
	{
		_escMenu = findDisplay 49;
		if (!isNull _escMenu) then { _escMenu closeDisplay 0 }; // Force close Esc menu if open

		if (diag_tickTime - _time >= 1) then // refresh every second
		{
			false call mf_items_atm_refresh;
			_time = diag_tickTime;
		};

		uiSleep 0.1;
	};
};
