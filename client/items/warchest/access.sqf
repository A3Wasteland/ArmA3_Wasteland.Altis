#include "defines.sqf"
disableSerialization;
if (isNull findDisplay IDD_WARCHEST) then { createDialog DIALOG_WARCHEST; };
call mf_items_warchest_refresh;