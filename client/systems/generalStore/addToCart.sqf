
//	@file Version: 1.0
//	@file Name: addToCart.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

if (local player) then {

	//Initialize Values
	_price = 0;
	_checkWeapon = "";
	_checkAmmo = "";
	_checkAccessor = "";

	// Grab access to the controls
	_dialog = findDisplay genstore_DIALOG;
	_itemlist = _dialog displayCtrl genstore_item_list;
	_cartlist = _dialog displayCtrl genstore_cart;
	_totalText = _dialog displayCtrl genstore_total;
	_buysell = _dialog displayCtrl genstore_buysell;

	_switchText = Ctrltext _buysell;

	//Get Selected Item
	_selectedItem = lbCurSel _itemlist;
	_itemText = _itemlist lbText _selectedItem;

	if(_switchText == "Buy") then
	{
		{
        	if(_x select 0 == _itemText) then
            {
                if(_x select 0 == _itemText) then
                {
                    _price = _x select 4;
                } 
            };   
        }forEach (call generalStore);
	} else {
		{
        	if(_x select 0 == _itemText) then
            {
                _price = _x select 5;
            };    
        }forEach (call generalStore);
		_itemlist lbDelete _selectedItem;
	};

	//Check Items Price
	genStoreCart = genStoreCart + _price;
	_totalText CtrlsetText format["Total: $%1", genStoreCart];

	_cartlist lbAdd format["%1",_itemText];
};