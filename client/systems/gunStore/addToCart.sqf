
//	@file Version: 1.0
//	@file Name: addToCart.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\gunstoreDefines.sqf";
disableSerialization;

if (local player) then {

	//Initialize Values
	_price = 0;
	_checkWeapon = "";
	_checkAmmo = "";
	_checkAccessor = "";

	// Grab access to the controls
	_dialog = findDisplay gunshop_DIALOG;
	_gunlist = _dialog displayCtrl gunshop_gun_list;
	_cartlist = _dialog displayCtrl gunshop_cart;
	_totalText = _dialog displayCtrl gunshop_total;

	//Get Selected Item
	_selectedItem = lbCurSel _gunlist;
	_itemText = _gunlist lbText _selectedItem;

	//Check Items Price
	{
		if (_itemText == _x select 0) exitWith
		{
			_price = _x select 2;
		};
	} forEach (call allGunStoreItems);

	gunStoreCart = gunStoreCart + _price;
	_totalText CtrlsetText format["Total: $%1", gunStoreCart];

	_cartlist lbAdd format["%1",_itemText];
};
