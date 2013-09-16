//	@file Version: 1.0
//	@file Name: populateGunStore.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = populate list with guns 1 = populate list with ammo 2 = populate list with equipment)]

#include "dialog\gunstoreDefines.sqf";
disableSerialization;
private["_switch","_dialog","_gunlisttext","_gunlist","_ammolist","_ammoBut","_ammoLbl","_weapon","_picture","_gunlistIndex"];
_switch = _this select 0;

// Grab access to the controls
_dialog = findDisplay gunshop_DIALOG;
_gunlisttext = _dialog displayCtrl gunshop_gun_TEXT;
_gunlist = _dialog displayCtrl gunshop_gun_list;
_ammolist = _dialog displayCtrl gunshop_ammo_list;
_ammoBut = _dialog displayCtrl gunshop_but_butammo;							
_ammoLbl = _dialog displayCtrl gunshop_ammo_TEXT;

switch(_switch) do 
{
	case 0: 
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow true;
		_ammoLbl ctrlShow true;
		_ammolist ctrlShow true;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgWeapons" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call pistolArray);
	};
	
	case 1: 
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow true;
		_ammoLbl ctrlShow true;
		_ammolist ctrlShow true;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgWeapons" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call rifleArray);
	};
	
	case 2: 
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow true;
		_ammoLbl ctrlShow true;
		_ammolist ctrlShow true;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgWeapons" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call smgArray);
	};
	
	case 3: 
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow true;
		_ammoLbl ctrlShow true;
		_ammolist ctrlShow true;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgWeapons" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call shotgunArray);
	};
	
	case 4: 
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow true;
		_ammoLbl ctrlShow true;
		_ammolist ctrlShow true;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgWeapons" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call launcherArray);
	};
	
	case 5: 
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow false;
		_ammoLbl ctrlShow false;
		_ammolist ctrlShow false;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgMagazines" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call throwputArray);
	};

	case 6:
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow false;
		_ammoLbl ctrlShow false;
		_ammolist ctrlShow false;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgWeapons" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call accessoriesArray);	
	};
	
	case 7:
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow false;
		_ammoLbl ctrlShow false;
		_ammolist ctrlShow false;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgVehicles" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call backpackArray);	
	};

	case 8:
	{
		//Clear the list
		lbClear _gunlist;
		lbClear _ammolist;
		_ammoBut ctrlShow false;
		_ammoLbl ctrlShow false;
		_ammolist ctrlShow false;
		_gunlist lbSetCurSel -1;

		// Populate the gun shop weapon list
		{
			_weapon = (configFile >> "CfgVehicles" >> _x select 1);
			_picture = getText (_weapon >> "picture");
			_gunlistIndex = _gunlist lbAdd format["%1",_x select 0];
			_gunlist lbSetPicture [_gunlistIndex,_picture];
		} forEach (call staticGunsArray);	
	};
};
