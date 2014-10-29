// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: weaponInfo.sqf
//	@file Author: [404] Deadbeat, [KoS] His_Shadow, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;

private ["_weap_type", "_picture", "_price", "_description", "_dialog", "_itemlist", "_itemlisttext", "_itemInfo", "_itemDesc", "_itemIndex", "_itemText", "_itemData", "_itemConfigInfo"];

//Initialize Values
_weap_type = "";
_picture = "";
_price = 0;
_description = "";

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlist = _dialog displayCtrl genstore_item_list;
_itemlisttext = _dialog displayCtrl genstore_item_TEXT;
_itemInfo = _dialog displayCtrl genstore_item_Info;
_itemDesc = _dialog displayCtrl genstore_item_desc;

//Get Selected Item
_itemIndex = lbCurSel _itemlist;
_itemText = _itemlist lbText _itemIndex;
_itemData = _itemlist lbData _itemIndex;

_itemlisttext ctrlSetText "";

_itemConfigInfo = [_itemText, _itemData] call getItemInfo;

_price = _itemConfigInfo select 1;
_description = _itemConfigInfo select 2;

_itemlisttext ctrlSetText format ["Price: $%1", [_price] call fn_numbersText];
_itemDesc ctrlSetStructuredText parseText _description;
