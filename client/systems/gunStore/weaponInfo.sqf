
//	@file Version: 1.0
//	@file Name: weaponInfo.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\gunstoreDefines.sqf";

disableSerialization;

//Initialize Values
_weap_type = "";
_picture = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay gunshop_DIALOG;
_gunlist = _dialog displayCtrl gunshop_gun_list;
_gunpicture = _dialog displayCtrl gunshop_gun_pic;
_itempicture = _dialog displayCtrl gunshop_item_pic;
_gunlisttext = _dialog displayCtrl gunshop_gun_TEXT;
_gunInfo = _dialog displayCtrl gunshop_gun_Info;

//Get Selected Item
_selectedItem = lbCurSel _gunlist;
_itemText = _gunlist lbText _selectedItem;

_gunpicture ctrlSettext _picture;
_itempicture ctrlSettext _picture;
_gunlisttext ctrlSetText format [""];

//Check Items Price
{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;
    
	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
    _gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", getText(_weapon >> "displayName"), getText(_weapon >> "descriptionShort")]);
    
	_itempicture ctrlSettext "";
	
    _picture = getText(_weapon >> "picture");
	_gunpicture ctrlSettext _picture;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call weaponsArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;
    
    _weapon = (configFile >> "CfgMagazines" >> _weap_type);
    _gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", getText(_weapon >> "displayName"), getText(_weapon >> "descriptionShort")]);
    
	_gunpicture ctrlSettext "";
	
    _picture = getText(_weapon >> "picture");
	_itempicture ctrlSettext _picture;
	
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call ammoArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;
	
	_weapon = "";
	
	if (_x select 3 == "backpack") then {
		_weapon = (configFile >> "CfgVehicles" >> _weap_type);
		_description = "";
		
		switch (_weap_type) do
		{
			case "B_Bergen_Base": {
				_description = "25% more capacity than normal backpack";
			};
			case "B_Carryall_Base": {
				_description = "40% more capacity than normal backpack";
			};
		};
		
		_gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", _x select 0, _description]);
	}
	else {
		_weapon = (configFile >> "CfgWeapons" >> _weap_type);
		_gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", getText(_weapon >> "displayName"), getText(_weapon >> "descriptionShort")]);
	};
    
	_gunpicture ctrlSettext "";
	
    _picture = getText(_weapon >> "picture");
	_itempicture ctrlSettext _picture;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call accessoriesArray);
