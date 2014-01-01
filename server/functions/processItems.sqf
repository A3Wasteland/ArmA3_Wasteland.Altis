//	@file Version: 1.0
//	@file Name: processItems.sqf
//	@file Author: AgentRev
//	@file Created: 27/12/2013 23:02

private ["_vehicle", "_items", "_type", "_class", "_quantity", "_magsQty", "_mag"];

_vehicle = _this select 0;
_items = _this select 1;

// Add items
{
	_type = _x select 0; // Item type ("I" for item, "W" for weapon, "M" for magazine)
	_class = _x select 1; // Item class (string or array of strings)
	_quantity = _x select 2; // Item quantity
	_magsQty = if (count _x > 3) then { _x select 3 } else { 0 }; // If item is weapon, quantity of magazines for each weapon (default = 0)
	
	// If item class is an array, chose a random element
	if (typeName _class == "ARRAY") then
	{
		_class = _class call BIS_fnc_selectRandom;
	};
	
	// Check first letter of uppercased type string
	switch (toString [(toArray toUpper _type) select 0]) do
	{
		case "W":
		{
			_vehicle addWeaponCargoGlobal [_class, _quantity];
			
			if (_magsQty > 0) then
			{
				_mag = ((getArray (configFile >> "CfgWeapons" >> _class >> "magazines")) select 0) call getBallMagazine;
				_vehicle addMagazineCargoGlobal [_mag, _quantity * _magsQty];
			};
		};
		case "M":
		{
			_vehicle addMagazineCargoGlobal [_class, _quantity];
		};
		case "I":
		{
			_vehicle addItemCargoGlobal [_class, _quantity];
		};
	};
} forEach _items;
