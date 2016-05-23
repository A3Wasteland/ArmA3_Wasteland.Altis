// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: populateGunStore.sqf
//	@file Author: [404] Deadbeat, [KoS] His_Shadow, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Args: [int (0 = populate list with guns 1 = populate list with ammo 2 = populate list with equipment)]

#include "dialog\gunstoreDefines.sqf";
disableSerialization;
private ["_switch", "_dialog", "_gunlisttext", "_gunlist", "_ammolist", "_ammoBtn", "_ammoLbl", "_gunDesc", "_showAmmo", "_playerSideNum", "_itemsArray", "_parentCfg", "_weaponClass", "_weapon", "_picture", "_gunlistIndex"];
_switch = _this select 0;

// Grab access to the controls
_dialog = findDisplay gunshop_DIALOG;
_gunlisttext = _dialog displayCtrl gunshop_gun_TEXT;
_gunlist = _dialog displayCtrl gunshop_gun_list;
_ammolist = _dialog displayCtrl gunshop_ammo_list;
_ammoBtn = _dialog displayCtrl gunshop_but_butammo;
_ammoLbl = _dialog displayCtrl gunshop_ammo_TEXT;
_gunDesc = _dialog displayCtrl gunshop_gun_desc;

_ammoLbl ctrlSetText "";

lbClear _gunlist;
lbClear _ammolist;
_gunlist lbSetCurSel -1;

_showAmmo = false;

_playerSideNum = switch (playerSide) do
{
	case BLUFOR:      { 1 };
	case OPFOR:       { 0 };
	case INDEPENDENT: { 2 };
	default           { 3 };
};

switch(_switch) do
{
	case 0:
	{
		_itemsArray = call pistolArray;
		_showAmmo = true;
	};
	case 1:
	{
		_itemsArray = call smgArray;
		_showAmmo = true;
	};
	case 2:
	{
		_itemsArray = call rifleArray;
		_showAmmo = true;
	};
	case 3:
	{
		_itemsArray = call lmgArray;
		_showAmmo = true;
	};
	case 5:
	{
		_itemsArray = call launcherArray;
		_showAmmo = true;
	};
	case 6:
	{
		_itemsArray = call throwputArray;
	};
	case 7:
	{
		_itemsArray = call accessoriesArray;
	};
	case 8:
	{
		_itemsArray = [];

		{
			if (getNumber (configFile >> "CfgVehicles" >> _x select 1 >> "side") in [_playerSideNum, 3]) then
			{
				_itemsArray pushBack _x;
			};
		} forEach (call staticGunsArray);
	};
	default
	{
		_itemsArray = [];
	};
};

if (_showAmmo) then
{
	_ammoBtn ctrlShow true;
	_ammoLbl ctrlShow true;
	_ammolist ctrlShow true;
}
else
{
	_ammoBtn ctrlShow false;
	_ammoLbl ctrlShow false;
	_ammolist ctrlShow false;
};

{
	_weaponClass = _x select 1;

	_parentCfg = switch (true) do
	{
		case ("HIDDEN" in (_x select [3,999])):                        { nil };
		case (isClass (configFile >> "CfgVehicles" >> _weaponClass)):  { configFile >> "CfgVehicles" };
		case (isClass (configFile >> "CfgWeapons" >> _weaponClass)):   { configFile >> "CfgWeapons" };
		case (isClass (configFile >> "CfgMagazines" >> _weaponClass)): { configFile >> "CfgMagazines" };
		case (isClass (configFile >> "CfgGlasses" >> _weaponClass)):   { configFile >> "CfgGlasses" };
	};

	if (!isNil "_parentCfg") then
	{
		_weapon = _parentCfg >> _weaponClass;
		_picture = getText (_weapon >> "picture");

		_gunlistIndex = _gunlist lbAdd format ["%1", [_x select 0, getText (_weapon >> "displayName")] select (_x select 0 == "")];
		_gunlist lbSetData [_gunlistIndex, _weaponClass];
	
		// Show scope on sniper rifle pictures
		if ([["_SOS_F", "_LRPS_F"], _weaponClass] call fn_findString != -1) then
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

		if (_picture != "" && _picture != "pictureThing") then
		{
			_gunlist lbSetPicture [_gunlistIndex, _picture];
		};
	};
} forEach _itemsArray;
