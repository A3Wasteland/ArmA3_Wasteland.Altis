// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: ammoInfo.sqf
//	@file Author: [KoS] His_Shadow, AgentRev
//	@file Args:

#include "dialog\gunstoreDefines.sqf";

disableSerialization;
private ["_weap_type", "_picture", "_price", "_ammolist", "_dialog", "_ammolist", "_ammoText", "_itemIndex", "_itemText", "_itemData"];

//Initialize Values
_weap_type = "";
_picture = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay gunshop_DIALOG;
_ammolist = _dialog displayCtrl gunshop_ammo_list;
_ammoText = _dialog displayCtrl gunshop_ammo_TEXT;

//Get Selected Item
_itemIndex = lbCurSel _ammolist;
_itemText = _ammolist lbText _itemIndex;
_itemData = _ammolist lbData _itemIndex;

_ammoText ctrlSetText "";

{
	if (_itemData == _x select 1) then
	{
		_weap_type = _x select 1;
		_price = _x select 2;
		_ammoText ctrlSetText format ["Price: $%1", [_price] call fn_numbersText];
	};
} forEach (call ammoArray);
