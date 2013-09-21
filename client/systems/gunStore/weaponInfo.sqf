
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
_gunInfo = _dialog displayCtrl gunshop_gun_desc;

//Get Selected Item
_selectedItem = lbCurSel _gunlist;
_itemText = _gunlist lbText _selectedItem;
_gunlisttext ctrlSetText format [""];

//Check Items Price
{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;

	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	_description = getText( _weapon >> "descriptionShort");

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
	_gunInfo ctrlSetStructuredText parseText _description;
}}forEach (call pistolArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;

	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	_description = getText( _weapon >> "descriptionShort");

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
	_gunInfo ctrlSetStructuredText parseText _description;
}}forEach (call smgArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;

	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	_description = getText( _weapon >> "descriptionShort");
	diag_log format["Found rifle desc: %1", _description];

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
	_gunInfo ctrlSetStructuredText parseText _description;

}}forEach (call rifleArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;

	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
	_name = "";
	_description = "";

	switch (_x select 3) do
	{
		case "bpack":
		{
			_weapon = (configFile >> "CfgVehicles" >> _weap_type);
			
			switch (_itemText) do 
			{
				case "Parachute":
				{
					_name = getText (_weapon >> "displayName");
					_description = "Safely jump from above";
				};
				case "Quadrotor UAV":
				{
					private "_uavType";
					
					switch (faction player) do
					{
						case "BLU_F": { _uavType = "B_UAV_01_F" };
						case "OPF_F": { _uavType = "O_UAV_01_F" };
						default       { _uavType = "I_UAV_01_F" };
					};
					
					_weapon = configFile >> "CfgVehicles" >> _uavType;
					_itempicture = _gunpicture;
					
					_name = getText (_weapon >> "displayName") + " UAV";
					_description = "Remote-controled quadcopter to spy on your neighbors, pre-packaged in a backpack.<br/>UAV Terminal sold separately. Ages 8+";
				};
				default
				{
					_name = _itemText;
					_description = [_weap_type, "bpack"] call _descCapacity;
				};
			};			
		};
		case "vest":
		{
			if (["Rebreather", _weap_type] call BIS_fnc_inString) then
			{
				_description = "Underwater oxygen supply";
			}
			else
			{
				_description = [_weap_type, "vest"] call _descCapacity;
			};
		};
		case "gogg":
		{
			_weapon = (configFile >> "CfgGlasses" >> _weap_type);
			_description = "Increases underwater visibility";
		};
		case "mag":
		{
			_weapon = (configFile >> "CfgMagazines" >> _weap_type);
			_name = getText (_weapon >> "displayName");
			_description = getText( _weapon >> "descriptionShort");
		};
		default
		{
			switch (_itemText) do
			{
				case "Default Uniform":
				{
					_name = _itemText;
					_description = "In case you lost your clothes";
				};
				case "Ghillie Suit": 
				{
					_name = _itemText;
					_description = "Disguise as a swamp monster";
				};
				case "Wetsuit": 
				{
					_name = _itemText;
					_description = "Allows faster swimming";
				};
				case "UAV Terminal": 
				{
					_name = getText (_weapon >> "displayName");
					_description = getText( _weapon >> "descriptionShort") + "<br/>Assign to GPS slot.";
				};
				default
				{
					_name = getText (_weapon >> "displayName");
					_description = getText( _weapon >> "descriptionShort");
				};
			};
		};
	}foreach _compatible;

	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
	_gunInfo ctrlSetStructuredText parseText _description;
}}forEach (call launcherArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;
	
	lbClear _ammolist;

	_weapon = (configFile >> "CfgMagazines" >> _weap_type);
	_description = getText( _weapon >> "descriptionShort");

	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
	_gunInfo ctrlSetStructuredText parseText _description;
}}forEach (call throwputArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;
	
	_weapon = (configFile >> "CfgMagazines" >> _weap_type);
	_description = getText( _weapon >> "descriptionShort");

	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
	_gunInfo ctrlSetStructuredText parseText _description;
}}forEach (call accessoriesArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;    
	_weapon = (configFile >> "CfgMagazines" >> _weap_type);
	_description = getText( _weapon >> "descriptionShort");

	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
	_gunInfo ctrlSetStructuredText parseText _description;
}}forEach (call backpackArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;    
	_weapon = (configFile >> "CfgMagazines" >> _weap_type);
	_description = getText( _weapon >> "descriptionShort");

	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
	_gunInfo ctrlSetStructuredText parseText _description;
}}forEach (call apparelArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;    
	_weapon = (configFile >> "CfgMagazines" >> _weap_type);
	_description = getText( _weapon >> "descriptionShort");

	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
	_gunInfo ctrlSetStructuredText parseText _description;
}}forEach (call staticGunsArray);
