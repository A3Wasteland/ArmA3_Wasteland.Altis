//	@file Version: 1.0
//	@file Name: populateGenStore.sqf
//	@file Author: [404] Deadbeat, [KoS] His_Shadow, AgentRev
//	@file Created: 20/11/2012 05:13
//	@file Args:

#include "dialog\genstoreDefines.sqf";
disableSerialization;
private ["_switch", "_dialog", "_itemlist", "_itemlisttext", "_itemDesc", "_showPicture", "_itemsArray", "_parentCfg", "_weapon", "_picture", "_listIndex", "_showItem", "_factionCfg", "_faction", "_uniformClassCfg", "_sideCfg", "_uniformSides", "_playerSides", "_side"];
_switch = _this select 0;

_getAllowedSides =
{
	private ["_unitType", "_sides", "_side"];

	_unitType = configFile >> "CfgVehicles" >> _this;
	_sides = [];
	
	while {isClass _unitType} do
	{
		_side = getNumber (_unitType >> "side");
		
		if !(_side in _sides) then
		{
			_sides set [count _sides, _side];
		};
		
		_unitType = inheritsFrom _unitType;
	};

	_sides
};

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
				_factionCfg = _parentCfg >> _weaponClass >> "faction";
				
				switch (true) do
				{
					case (isText _factionCfg):
					{
						_faction = getText _factionCfg;
						
						if (_faction != faction player &&
						   {_faction != "CIV_F"} &&
						   {_faction != "Default"} &&
						   {_faction != ""}) then
						{
							_showItem = false;
						};
					};
				};
			};
			case "CfgWeapons":
			{
				_uniformClassCfg = _parentCfg >> _weaponClass >> "ItemInfo" >> "uniformClass";
				_sideCfg = _parentCfg >> _weaponClass >> "ItemInfo" >> "side";
				
				switch (true) do
				{
					case (isText _uniformClassCfg):
					{
						_uniformSides = (getText _uniformClassCfg) call _getAllowedSides;
						_playerSides = getArray (configFile >> "CfgVehicles" >> typeOf player >> "modelSides");
						
						if ({_x in _playerSides} count _uniformSides == 0) then
						{
							_showItem = false;
						};
					};
					case (isNumber _sideCfg):
					{
						_side = getNumber _sideCfg;
						
						// Yes, the numbers are correct
						if ((_side == 1 && playerSide != BLUFOR) ||
							{_side == 0 && playerSide != OPFOR} ||
							{_side == 2 && playerSide != INDEPENDENT}) then
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
