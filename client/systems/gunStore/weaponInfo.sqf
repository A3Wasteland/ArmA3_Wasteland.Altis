
//	@file Version: 1.0
//	@file Name: weaponInfo.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\gunstoreDefines.sqf";

disableSerialization;
private["_weap_type","_picture","_price","_dialog","_gunlist","_ammolist","_gunlisttext","_ammoText","_selectedItem","_itemText","_weapon","_compatible","_name","_conf","_ammolistIndex"];
//Initialize Values
_weap_type = "";
_picture = "";
_price = 0;

// Grab access to the controls
_dialog = findDisplay gunshop_DIALOG;
_gunlist = _dialog displayCtrl gunshop_gun_list;
_ammolist = _dialog displayCtrl gunshop_ammo_list;
_gunlisttext = _dialog displayCtrl gunshop_gun_TEXT;
_ammoText = _dialog displayCtrl gunshop_ammo_TEXT;

//Get Selected Item
_selectedItem = lbCurSel _gunlist;
_itemText = _gunlist lbText _selectedItem;
_gunlisttext ctrlSetText format [""];

//Check Items Price
{
if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
    
	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	
	_compatible = [];
	lbClear _ammolist;
	
	_compatible = [];
	{
		_compatible = _compatible + getArray( (if ( _x == "this" ) then { _weapon } else { _weapon >> _x }) >> "magazines")
    } forEach getArray(_weapon >> "muzzles");
	
	{
		_name = getText(configFile >> "CfgMagazines" >> _x >> "displayname");
		_conf = (configFile >>  "CfgMagazines" >> _x);
		_picture = getText(_conf >> "picture");
		_ammolistIndex = _ammolist lbAdd format["%1",_name];
		_ammolist lbSetPicture [_ammolistIndex,_picture];
	}foreach _compatible;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call pistolArray);

{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
    
	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	
	_compatible = [];
	lbClear _ammolist;
	
	_compatible = [];
	{
		_compatible = _compatible + getArray( (if ( _x == "this" ) then { _weapon } else { _weapon >> _x }) >> "magazines")
    } forEach getArray(_weapon >> "muzzles");
	
	{
		_name = getText(configFile >> "CfgMagazines" >> _x >> "displayname");
		_conf = (configFile >>  "CfgMagazines" >> _x);
		_picture = getText(_conf >> "picture");
		_ammolistIndex = _ammolist lbAdd format["%1",_name];
		_ammolist lbSetPicture [_ammolistIndex,_picture];
	}foreach _compatible;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call smgArray);

{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
    
	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	
	_compatible = [];
	lbClear _ammolist;
	
	_compatible = [];
	{
		_compatible = _compatible + getArray( (if ( _x == "this" ) then { _weapon } else { _weapon >> _x }) >> "magazines")
    } forEach getArray(_weapon >> "muzzles");
	
	{
		_name = getText(configFile >> "CfgMagazines" >> _x >> "displayname");
		_conf = (configFile >>  "CfgMagazines" >> _x);
		_picture = getText(_conf >> "picture");
		_ammolistIndex = _ammolist lbAdd format["%1",_name];
		_ammolist lbSetPicture [_ammolistIndex,_picture];
	}foreach _compatible;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call rifleArray);

{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
    
	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	
	_compatible = [];
	lbClear _ammolist;
	
	_compatible = [];
	{
		_compatible = _compatible + getArray( (if ( _x == "this" ) then { _weapon } else { _weapon >> _x }) >> "magazines")
    } forEach getArray(_weapon >> "muzzles");
	
	{
		_name = getText(configFile >> "CfgMagazines" >> _x >> "displayname");
		_conf = (configFile >>  "CfgMagazines" >> _x);
		_picture = getText(_conf >> "picture");
		_ammolistIndex = _ammolist lbAdd format["%1",_name];
		_ammolist lbSetPicture [_ammolistIndex,_picture];
	}foreach _compatible;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call shotgunArray);

{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	_compatible = [];
	lbClear _ammolist;

	_compatible = [];
	{
		_compatible = _compatible + getArray( (if ( _x == "this" ) then { _weapon } else { _weapon >> _x }) >> "magazines")
    } forEach getArray(_weapon >> "muzzles");

	{
		if(_x != "RPG32_AA_F") then
		{
			_name = getText(configFile >> "CfgMagazines" >> _x >> "displayname");
			_conf = (configFile >>  "CfgMagazines" >> _x);
			_picture = getText(_conf >> "picture");
			_ammolistIndex = _ammolist lbAdd format["%1",_name];
			_ammolist lbSetPicture [_ammolistIndex,_picture];
		};
	}foreach _compatible;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call launcherArray);

{if(_itemText == _x select 0) then
{
	_weap_type = _x select 1; 
	_price = _x select 2;
	
	lbClear _ammolist;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call throwputArray);

{if(_itemText == _x select 0) then{
	_price = _x select 2;
	
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call accessoriesArray);

{if(_itemText == _x select 0) then{
	_price = _x select 2;    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call backpackArray);

{if(_itemText == _x select 0) then{
	_price = _x select 2;
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call apparelArray);

{if(_itemText == _x select 0) then{
	_price = _x select 2;
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}}forEach (call staticGunsArray);
