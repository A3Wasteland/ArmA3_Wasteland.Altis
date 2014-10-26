// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#include "defines.sqf"
disableSerialization;
if (isNull findDisplay IDD_WARCHEST) then { createDialog "WarchestDialog"; };
call mf_items_warchest_refresh;

[] spawn
{
	disableSerialization;
	_dialog = findDisplay IDD_WARCHEST;
	while {!isNull _dialog} do
	{
		_escMenu = findDisplay 49;
		if (!isNull _escMenu) exitWith { _escMenu closeDisplay 0 }; // Force close Esc menu if open
		sleep 0.1;
	};
};
