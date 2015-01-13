// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: refresh.sqf
//	@file Author: AgentRev
//	@file Function: mf_items_atm_refresh

#include "gui_defines.hpp"
disableSerialization;

private ["_nonScheduled", "_dialog", "_accDropdown", "_players", "_oldPlayers", "_strPlayers", "_callFSM", "_amount", "_fee", "_feeAmount", "_selAcc"];
_nonScheduled = _this; // bool

_dialog = findDisplay AtmGUI_IDD;

if (isNull _dialog) exitWith {};

_accDropdown = _dialog displayCtrl AtmAccountDropdown_IDC;

_players = call allPlayers;

if !(["A3W_atmTransferAllTeams"] call isConfigOn) then
{
	_players = [_players, {(side group _x == playerSide && playerSide in [BLUFOR,OPFOR]) || group _x == group player}] call BIS_fnc_conditionalSelect;
};

_oldPlayers = uiNamespace getVariable ["A3W_AtmGUI_players", ""];
_strPlayers = str _players;

_accDropdown = _dialog displayCtrl AtmAccountDropdown_IDC;

if !(_oldPlayers isEqualTo _strPlayers) then
{
	uiNamespace setVariable ["A3W_AtmGUI_players", _strPlayers];

	_players = [player] + ([_players - [player], {name _x}] call fn_sortAlphabetically);

	_refreshList =
	{
		disableSerialization;
		private ["_players", "_accDropdown", "_selData", "_bluforColor", "_opforColor", "_indieColor", "_civColor", "_defColor", "_idx", "_color", "_data", "_selIdx"];
		_players = _this select 0;

		_accDropdown = (findDisplay AtmGUI_IDD) displayCtrl AtmAccountDropdown_IDC;
		_selData = _accDropdown lbData lbCurSel _accDropdown;

		_bluforColor = ["Map", "BLUFOR"] call BIS_fnc_displayColorGet;
		_opforColor = ["Map", "OPFOR"] call BIS_fnc_displayColorGet;
		_indieColor = ["Map", "Independent"] call BIS_fnc_displayColorGet;
		_civColor = ["Map", "Civilian"] call BIS_fnc_displayColorGet;
		_defColor = ["Map", "Unknown"] call BIS_fnc_displayColorGet;

		lbClear _accDropdown;

		{
			_idx = _accDropdown lbAdd name _x;

			_color = switch (side group _x) do
			{
				case BLUFOR:      { _bluforColor };
				case OPFOR:       { _opforColor };
				case INDEPENDENT: { _indieColor };
				case CIVILIAN:    { _civColor };
				default           { _defColor };
			};

			_accDropdown lbSetPicture [_idx, "client\icons\whitesquare.paa"];
			_accDropdown lbSetPictureColor [_idx, _color];
			_accDropdown lbSetPictureColorSelected [_idx, _color];
			_accDropdown lbSetPictureColorDisabled [_idx, _color];

			_data = format ["objectFromNetId '%1'", netId _x];
			_accDropdown lbSetData [_idx, _data];

			if (isNil "_selIdx" && _selData != "" && {_data isEqualTo _selData}) then
			{
				_selIdx = _idx;
			};
		} forEach _players;

		_accDropdown lbSetCurSel (if (!isNil "_selIdx") then { _selIdx } else { 0 });
	};

	if (_nonScheduled) then
	{
		[_players] call _refreshList;
	}
	else
	{
		_callFSM = [[_players], _refreshList] execFSM "call.fsm";
		waitUntil {completedFSM _callFSM};
	};
};

if (lbCurSel _accDropdown == -1) then
{
	_accDropdown lbSetCurSel 0;
};

call mf_items_atm_refresh_amounts;
