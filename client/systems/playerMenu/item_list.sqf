#include "dialog\player_sys.sqf";
#define INDEX_ID 0
#define INDEX_QUANTITY 1
#define INDEX_NAME 2
#define INDEX_MAX 6

disableSerialization;

//_switch = _this select 0;

_dialog = findDisplay playersys_DIALOG;
_itemlist = _dialog displayCtrl item_list;
lbClear _itemlist;
{
	if (_x select INDEX_QUANTITY > 0) then {
		_idx = _itemlist lbAdd format["%1x %2", _x select INDEX_QUANTITY, _x select INDEX_NAME];
		_itemlist lbSetData [_idx, _x select INDEX_ID];
	}
} forEach call mf_inventory_all;