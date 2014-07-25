//	@file Version: 1.0
//	@file Name: populateGenStore.sqf
//	@file Author: [404] Deadbeat, [KoS] His_Shadow, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;
private ["_switch", "_dialog", "_itemlist", "_itemlisttext", "_itemDesc", "_showPicture", "_itemsArray", "_playerSideNum", "_parentCfg", "_weapon", "_picture", "_listIndex", "_showItem", "_factionCfg", "_faction", "_isUniform", "_sideCfg", "_side"];
_switch = _this select 0;

// Grab access to the controls
_dialog = findDisplay genstore_DIALOG;
_itemlist = _dialog displayCtrl genstore_item_list;
_itemlisttext = _dialog displayCtrl genstore_item_TEXT;
_itemDesc = _dialog displayCtrl genstore_item_desc;

[] execVM "client\systems\generalStore\getInventory.sqf";

//Clear the list
lbClear _itemlist;
_itemlist lbSetCurSel -1;
_itemlisttext ctrlSetText "";
_itemDesc ctrlSetText "";

_showPicture = true;

switch(_switch) do 
{
	case 0: 
	{
		_itemsArray = call headArray;
	};
	case 1: 
	{
		_itemsArray = call uniformArray;
	};
	case 2: 
	{
		_itemsArray = call vestArray;
	};
	case 3: 
	{
		_itemsArray = call backpackArray;
	};
	case 4: 
	{
		_itemsArray = call genItemArray;
	};
	case 5: 
	{
		_itemsArray = call customPlayerItems;
		
		if (playerSide == INDEPENDENT) then
		{
			_itemsArray = [_itemsArray, { _x select 1 != "warchest" }] call BIS_fnc_conditionalSelect;
		};
	};
	case 6: 
	{
		_itemsArray = call genObjectsArray;
		_showPicture = false;
	};
	default
	{
		_itemsArray = [];
	};
};

_playerSideNum = switch (playerSide) do
{
	case BLUFOR:      { 1 };
	case OPFOR:       { 0 };
	case INDEPENDENT: { 2 };
	default           { 3 };
};

{
	_weaponClass = _x select 1;

	switch (true) do
	{
		case (isClass (configFile >> "CfgVehicles" >> _weaponClass)):  { _parentCfg = configFile >> "CfgVehicles" };
		case (isClass (configFile >> "CfgWeapons" >> _weaponClass)):   { _parentCfg = configFile >> "CfgWeapons" };
		case (isClass (configFile >> "CfgMagazines" >> _weaponClass)): { _parentCfg = configFile >> "CfgMagazines" };
		case (isClass (configFile >> "CfgGlasses" >> _weaponClass)):   { _parentCfg = configFile >> "CfgGlasses" };
	};
	
	_showItem = true;
	
	// Side-based filtering
	if (!isNil "_parentCfg") then
	{
		switch (configName _parentCfg) do
		{
			case "CfgVehicles":
			{
				_sideCfg = _parentCfg >> _weaponClass >> "side";
				
				if (isNumber _sideCfg) then
				{
					_side = getNumber _sideCfg;
					
					if (_side in [0,1,2] && {_side != _playerSideNum}) then
					{
						_showItem = false;
					};
				};
			};
			case "CfgWeapons":
			{
				_isUniform = isText (_parentCfg >> _weaponClass >> "ItemInfo" >> "uniformClass");
				_sideCfg = _parentCfg >> _weaponClass >> "ItemInfo" >> "side";
				
				switch (true) do
				{
					case (_isUniform):
					{
						if !([player, _weaponClass] call canWear) then
						{
							_showItem = false;
						};
					};
					case (isNumber _sideCfg):
					{
						_side = getNumber _sideCfg;
						
						if (_side in [0,1,2] && {_side != _playerSideNum}) then
						{
							_showItem = false;
						};
					};
				};
			};
		};
	};
	
	if (_showItem) then
	{
		_listIndex = _itemlist lbAdd format ["%1", _x select 0];
		
		if (isNil "_parentCfg") then
		{
			_itemlist lbSetPicture [_listIndex, _x select 3];
		}
		else
		{
			// If BLUFOR ghillie suit, use picture from Independent ghillie suit
			if (_weaponClass == "U_B_GhillieSuit") then
			{
				_weapon = _parentCfg >> "U_I_GhillieSuit";
			}
			else
			{
				_weapon = _parentCfg >> _weaponClass;
			};
			
			_picture = getText (_weapon >> "picture");
			
			if (_showPicture) then
			{
				_itemlist lbSetPicture [_listIndex, _picture];
			};
		};
		
		_itemlist lbSetData [_listIndex, _weaponClass];
	};
} forEach _itemsArray;
