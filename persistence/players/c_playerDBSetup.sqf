//===========================================================================
applyPlayerDBValues =
{
	private ["_array","_varName","_varValue","_i","_in","_exe","_backpack","_sendToServer","_uid"];
	//diag_log format["applyPlayerDBValues called with %1", _this];
	_array = _this;
	_uid = _array select 0;
	_varName = _array select 1;

	if (count _array == 3) then {
		_varValue = _array select 2;
	} else {
		 diag_log format["applyPlayerDBValues failed to get a value for %1", _varName];
	};

	// Donation error catch
	if(((getPlayerUID player) != _uid) AND ((getPlayerUID player) + "_donation" != _uid)) exitWith {if(_varName == 'DonationMoney') then {donationMoneyLoaded = 1;};};

	//if there is not a value for items we care about exit early
	if(isNil '_varValue') exitWith 	
	{
		diag_log format["applyPlayerDBValues early termination with nil value for %1", _varName];
		if(_varName == 'Position') then {positionLoaded = 1;};
		if(_varName == 'DonationMoney') then {donationMoneyLoaded = 1;};
		
		if(_varName == 'PrimaryWeapon') then {primaryLoaded = 1;};
		if(_varName == 'HandgunWeapon') then {handgunLoaded = 1;};
		if(_varName == 'SecondaryWeapon') then {secondaryLoaded = 1;};

		if(_varName == 'Backpack') then { backpackLoaded = 1;};
		if(_varName == 'Vest') then { vestLoaded = 1;};
		if(_varName == 'Uniform') then { uniformLoaded = 1;};
		if(_varName == 'Items') then { itemsLoaded = 1;};
	};
	
	if(_varName == 'DonationMoney') then {player setVariable["donationMoney",_varValue,true]; donationMoneyLoaded = 1;};

	// Inventory item section. Use mf_inventory_registered_item_ids as set up by mf_inventory_create
	{
		_itemID = _x;
		if (_varName == _itemID) then {
			// Special call to mf_inventory_add specifying an absolute value
			[_varName, _varValue, true] call mf_inventory_add;
		};
	} forEach mf_inventory_registered_item_ids;

	if(_varName == 'Health') then {player setDamage _varValue;};

	//if(_varName == 'Magazines') then {{player addMagazine _x;}foreach _varValue;};

	if((_varName == 'Items')
		|| (_varName == 'Magazines')
		|| (_varName == 'HandgunMagazine')
		|| (_varName == 'SecondaryWeaponMagazine')
		|| (_varName == 'PrimaryWeaponMagazine')) then 
	{
		for "_i" from 0 to (count _varValue) - 1 do 
		{
			_name = _varValue select _i;
			_backpack = unitBackpack player;
			_inCfgWeapons = isClass (configFile >> "cfgWeapons" >> _name);

			// Optics seems to denote an 'item' if 1 or 'weapon' is 0
			_cfgOptics = getNumber (configFile >> "cfgWeapons" >> _name >> "optics");

			if((str(_inCfgWeapons) == "true") && _cfgOptics == 0 && (!isNil '_backpack'))then{_backpack addWeaponCargo [_name,1];}
			else
			{
				_inCfgMagazines = isClass (configFile >> "cfgMagazines" >> _name);
				_fits = [player, (_name)] call fn_fitsInventory;
				if((_fits == 1)||(_fits == 2))then
				{
					if(str(_inCfgMagazines) == "false")then{player addItem _name;}
					else{player addMagazine _name;};
				};
				if(_fits == 3) then
				{
					if(str(_inCfgMagazines) == "false")then
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

	if(_varName == 'PrimaryWeaponItems') then 
	{
		{
			player addPrimaryWeaponItem _x;
		}foreach _varValue;
	};
	if(_varName == 'SecondaryWeaponItems') then 
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
