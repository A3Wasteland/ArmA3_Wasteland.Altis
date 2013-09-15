
//	@file Version: 1.0
//	@file Name: weaponInfo.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

//Initialize Values
_weap_type = "";
_picture = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlist = _dialog displayCtrl genstore_item_list;
_itemlisttext = _dialog displayCtrl genstore_item_TEXT;
_picture = _dialog displayCtrl genstore_item_pic;
_buysell = _dialog displayCtrl genstore_buysell;
_itemInfo = _dialog displayCtrl genstore_item_Info;

//Get Selected Item
_selectedItem = lbCurSel _itemlist;
_itemText = _itemlist lbText _selectedItem;

//Check which state we want to be in.
_switchText = Ctrltext _buysell;
if(_switchText == "Buy") then
{
	{
	    if(_itemText == _x select 0) then{
			_price = _x select 4;
            _picLink = _x select 3;
            _picture ctrlSetText _picLink;
            _itemInfo ctrlSetStructuredText parseText ((_x select 2));
			_itemlisttext ctrlSetText format ["Price: $%1", _price];	
		}
	}forEach (call generalStore);
} else {	
	{
	    if(_itemText == _x select 0) then{
			_price = _x select 5;
            _picLink = _x select 3;
            _picture ctrlSetText _picLink;
            _itemInfo ctrlSetStructuredText parseText ((_x select 2));
			_itemlisttext ctrlSetText format ["Price: $%1", _price];	
		}
	}forEach (call generalStore);
};
