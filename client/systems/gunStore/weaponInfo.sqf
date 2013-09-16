
//	@file Version: 1.0
//	@file Name: weaponInfo.sqf
//	@file Author: [404] Deadbeat, AgentRev
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

_gunpicture ctrlSettext "";
_itempicture ctrlSettext "";
_gunlisttext ctrlSetText format [""];

_descCapacity =
{
	private ["_item", "_type", "_text", "_containerClass", "_defaultCapacity", "_newCapacity", "_diff"];
	_item = _this select 0;
	_type = _this select 1;
	_text = "";
	_defaultCapacity = 0;
	_newCapacity = 0;
	
	switch (_type) do
	{
		case "vest":
		{
			switch (playerSide) do
			{
				case BLUFOR: { _containerClass = getText (configFile >> "CfgWeapons" >> "V_PlateCarrierGL_rgr" >> "ItemInfo" >> "containerClass") };
				case OPFOR:  { _containerClass = getText (configFile >> "CfgWeapons" >> "V_HarnessO_brn" >> "ItemInfo" >> "containerClass") };
				default      { _containerClass = getText (configFile >> "CfgWeapons" >> "V_PlateCarrierIA2_dgtl" >> "ItemInfo" >> "containerClass") };
			};
			
			_defaultCapacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
			
			_containerClass = getText (configFile >> "CfgWeapons" >> _item >> "ItemInfo" >> "containerClass");
			_newCapacity = getNumber (configFile >> "CfgVehicles" >> _containerClass >> "maximumLoad");
			
			_text = "vest";
		};
		case "bpack":
		{
			_defaultCapacity = getNumber (configFile >> "CfgVehicles" >> "B_Kitbag_Base" >> "maximumLoad");
			_newCapacity = getNumber (configFile >> "CfgVehicles" >> _item >> "maximumLoad");
			
			_text = "backpack";
		};
	};
	
	_diff = round (((_newCapacity / _defaultCapacity) - 1) * 100);
	
	if (_diff > 0) then
	{
		_text = (str abs _diff) + "% more capacity than default " + _text;
	};
	if (_diff < 0) then
	{
		_text = (str abs _diff) + "% less capacity than default " + _text;
	};
	if (_diff == 0) then
	{
		_text = "Same capacity as default " + _text;
	};
	
	_text
};

//Check Items Price
{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;
    
	_weapon = (configFile >> "CfgWeapons" >> _weap_type);
    _gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", getText(_weapon >> "displayName"), getText(_weapon >> "descriptionShort")]);
    
	_itempicture ctrlSettext "";
	
	_picture = getText(_weapon >> "picture");
	
	// Show scope on gunstore's sniper pictures
	if ([_weap_type, (count toArray _weap_type) - 6] call BIS_fnc_trimString == "_SOS_F") then
	{
		private ["_picArr", "_picLen"];
		_picArr = toArray _picture;
		_picLen = count _picArr;
		
		if (toString [_picArr select (_picLen - 8)] == "X") then
		{
			_picArr set [(_picLen - 8), (toArray "T") select 0];
			_picture = toString _picArr;
		};
	};
	
	_gunpicture ctrlSettext _picture;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}} forEach (call weaponsArray);

{if(_itemText == _x select 0) then{
	_weap_type = _x select 1; 
	_price = _x select 2;
    
    _weapon = (configFile >> "CfgMagazines" >> _weap_type);
    _gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", getText(_weapon >> "displayName"), getText(_weapon >> "descriptionShort")]);
    
	_gunpicture ctrlSettext "";
	
    _picture = getText(_weapon >> "picture");
	_itempicture ctrlSettext _picture;
	
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}} forEach (call ammoArray);

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
			
			_gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", _name, _description]);
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
			
			_gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", _itemText, _description]);
		};
		case "gogg":
		{
			_weapon = (configFile >> "CfgGlasses" >> _weap_type);
			_gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", _itemText, "Increases underwater visibility"]);
		};
		case "mag":
		{
			_weapon = (configFile >> "CfgMagazines" >> _weap_type);
			_name = getText (_weapon >> "displayName");
			_description = getText( _weapon >> "descriptionShort");
			_gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", getText(_weapon >> "displayName"), getText(_weapon >> "descriptionShort")]);
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
			
			_gunInfo ctrlSetStructuredText parseText (format ["%1<br/>%2", _name, _description]);
		};
	};
	
	_picture = getText(_weapon >> "picture");
    
	_gunpicture ctrlSettext "";
	_itempicture ctrlSettext _picture;
    
	_gunlisttext ctrlSetText format ["Price: $%1", _price];	
}} forEach ((call accessoriesArray) + (call gearArray));
