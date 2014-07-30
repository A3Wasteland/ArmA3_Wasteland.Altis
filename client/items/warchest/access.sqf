#include "defines.sqf"
disableSerialization;
if (isNull findDisplay IDD_WARCHEST) then { createDialog DIALOG_WARCHEST; };
call mf_items_warchest_refresh;

(findDisplay IDD_WARCHEST) spawn
{
	disableSerialization;
	while {!isNull _this} do
	{
		_escMenu = findDisplay 49;
		if (!isNull _escMenu) exitWith { _escMenu closeDisplay 0 }; // Force close Esc menu if open
		sleep 0.1;
	};
};
