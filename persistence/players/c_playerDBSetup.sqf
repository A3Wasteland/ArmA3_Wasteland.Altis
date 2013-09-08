//===========================================================================
applyPlayerDBValues =
{
	private ["_array","_varName","_varValue","_i","_in","_exe","_backpack","_sendToServer","_uid"];
	diag_log format["applyPlayerDBValues called with %1", _this];
	_array = _this;
	_uid = _array select 0;
	_varName = _array select 1;

	if (count _array == 3) then {
		_varValue = _array select 2;
	} else {
		 diag_log format["Failed to load value for %1", _varName];
	};

	//ensure this is the correct player
	if(((getPlayerUID player) != _uid) AND ((getPlayerUID player) + "_donation" != _uid)) exitWith {if(_varName == 'ComputedMoney') then {moneyLoaded = 1;};};

	//if there is not a value for items we care about exit early
	if(isNil '_varValue') exitWith 
	{
		diag_log format["Early termination with nil value for %1", _varName];
		if(_varName == 'Position') then {positionLoaded = 1;};
		if(_varName == 'ComputedMoney') then {moneyLoaded = 1;};
		
		if(_varName == 'PrimaryWeapon') then {primaryLoaded = 1;};
		if(_varName == 'HandgunWeapon') then {handgunLoaded = 1;};
		if(_varName == 'SecondaryWeapon') then {secondaryLoaded = 1;};

		if(_varName == 'Backpack') then { backpackLoaded = 1;};
		if(_varName == 'Vest') then { vestLoaded = 1;};
		if(_varName == 'Uniform') then { uniformLoaded = 1;};
		if(_varName == 'Items') then { itemsLoaded = 1;};
	};
	
	//player globalChat format["%1", _varName];
	if(_varName == 'ComputedMoney') then {player setVariable["computedMoney",_varValue,true]; moneyLoaded = 1;};
	if(_varName == 'Money') then {
		if (_varValue > 5000) then { _varValue = 5000;};
		player setVariable["cmoney",_varValue,true];
	};

	if(_varName == MF_ITEMS_WATER) then { [MF_ITEMS_WATER, _varValue] call mf_inventory_add; };
	if(_varName == MF_ITEMS_CANNED_FOOD) then { [MF_ITEMS_CANNED_FOOD, _varValue] call mf_inventory_add; };
	//if(_varName == MF_ITEMS_MEDKIT) then { [MF_ITEMS_MEDKIT, _varValue] call mf_inventory_add; };
	if(_varName == MF_ITEMS_REPAIR_KIT) then { [MF_ITEMS_REPAIR_KIT, _varValue] call mf_inventory_add; };
	if(_varName == MF_ITEMS_JERRYCAN_FULL) then { [MF_ITEMS_JERRYCAN_FULL, _varValue] call mf_inventory_add; };
	if(_varName == MF_ITEMS_JERRYCAN_EMPTY) then { [MF_ITEMS_JERRYCAN_EMPTY, _varValue] call mf_inventory_add; };
	if(_varName == MF_ITEMS_SPAWN_BEACON) then { [MF_ITEMS_SPAWN_BEACON, _varValue] call mf_inventory_add; };
	if(_varName == MF_ITEMS_CAMO_NET) then { [MF_ITEMS_CAMO_NET, _varValue] call mf_inventory_add; };
	if(_varName == MF_ITEMS_SYPHON_HOSE) then { [MF_ITEMS_SYPHON_HOSE, _varValue] call mf_inventory_add; };
	if(_varName == MF_ITEMS_ENERGY_DRINK) then { [MF_ITEMS_ENERGY_DRINK, _varValue] call mf_inventory_add; };

	if(_varName == 'Health') then {player setDamage _varValue;};

	//if(_varName == 'Magazines') then {{player addMagazine _x;}foreach _varValue;};

	if((_varName == 'Items') || (_varName == 'Magazines') || (_varName == 'HandgunMagazine') || (_varName == 'SecondaryMagazine') || (_varName == 'PrimaryMagazine')) then 
	{
		for "_i" from 0 to (count _varValue) - 1 do 
		{
			_name = _varValue select _i;
			_backpack = unitBackpack player;
			_in = isClass (configFile >> "cfgWeapons" >> _name);
			if((str(_in) == "true") && (!isNil '_backpack'))then{_backpack addWeaponCargo [_name,1];}
			else
			{
				_in = isClass (configFile >> "cfgMagazines" >> _name);
				_fits = [player, (_name)] call fn_fitsInventory;
				if((_fits == 1)||(_fits == 2))then
				{
					if(str(_in) == "false")then{player addItem _name;}
					else{player addMagazine _name;};
				};
				if(_fits == 3) then
				{
					if(str(_in) == "false")then
					{
						_backpack = unitBackpack player;
						_backpack addItemCargo [_name,1];
					}
					else
					{	
						_backpack = unitBackpack player;
						_backpack addMagazineCargo [_name,1];
					};
				};
			};
		};
		if(_varName == 'Items') then {itemsLoaded = 1;};
	};
	if(_varName == 'PrimaryItems') then 
	{
		{
			player addPrimaryWeaponItem _x;
		}foreach _varValue;
	};
	if(_varName == 'SecondaryItems') then 
	{
		{
			player addSecondaryWeaponItem _x;
		}foreach _varValue;
	};
	if(_varName == 'HandgunItems') then 
	{
		{
			player addHandgunItem _x;
		}foreach _varValue;
	};

	if(_varName == 'Uniform') then {removeUniform player; player addUniform _varValue; uniformLoaded = 1;};
	if(_varName == 'Vest') then {removeVest player; player addVest _varValue; vestLoaded = 1;};
	if(_varName == 'Backpack') then {removeBackpack player; player addBackpack _varValue; backpackLoaded = 1;};
	if(_varName == 'HeadGear') then {removeHeadgear player; player addHeadgear _varValue;};
	if(_varName == 'Goggles') then {player addGoggles _varValue};

	if(_varName == 'Position') then {player setPos _varValue; player setVariable["positionLoaded",1,true]; positionLoaded = 1;};
	if(_varName == 'Direction') then {player setDir _varValue;};

	if(_varName == 'PrimaryWeapon') then{player addWeapon _varValue; primaryLoaded = 1;};
	if(_varName == 'HandgunWeapon') then{player addWeapon _varValue; handgunLoaded = 1;};
	if(_varName == 'SecondaryWeapon') then {player addWeapon _varValue; secondaryLoaded = 1;};

	if(_varName == 'AssignedItems') then {
		{
			player addItem _varValue;
			player assignItem _varValue;
		} foreach _varValue;
	};
};

//===========================================================================
_sendToServer =
"
	accountToServerLoad = _this;
	publicVariableServer 'accountToServerLoad';
";

sendToServer = compile _sendToServer;
//===========================================================================
"accountToClient" addPublicVariableEventHandler 
{
	(_this select 1) spawn applyPlayerDBValues;
};
//===========================================================================

statFunctionsLoaded = 1;
