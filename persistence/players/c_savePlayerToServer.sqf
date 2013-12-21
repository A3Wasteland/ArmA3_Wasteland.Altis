private["_uid"];
if (playerSetupComplete) then
{	
	_uid = getPlayerUID player;
	[_uid, _uid, "Health", damage player] call fn_SaveToServer;
	[_uid, _uid, "Side", str(side player)] call fn_SaveToServer;
	[_uid, _uid, "Account Name", name player] call fn_SaveToServer;

	{
		_keyName = _x select 0;
		_value = _x select 1;
		[_uid, _uid, _keyName, _value] call fn_SaveToServer;
	} forEach call mf_inventory_all;

	[_uid, _uid, "Vest", vest player] call fn_SaveToServer;
	[_uid, _uid, "Uniform", uniform player] call fn_SaveToServer;	
	[_uid, _uid, "Backpack", backpack player] call fn_SaveToServer;
	[_uid, _uid, "Goggles", goggles player] call fn_SaveToServer;
	[_uid, _uid, "HeadGear", headGear player] call fn_SaveToServer;

	//[_uid, _uid, "UniformItems", uniformItems player] call fn_SaveToServer;
	//[_uid, _uid, "VestItems", vestItems player] call fn_SaveToServer;
	//[_uid, _uid, "BackpackItems", backpackItems player] call fn_SaveToServer;
	
	[_uid, _uid, "Position", getPosATL vehicle player] call fn_SaveToServer;
	[_uid, _uid, "Direction", direction vehicle player] call fn_SaveToServer;

	[_uid, _uid, "PrimaryWeapon", primaryWeapon player] call fn_SaveToServer;
	[_uid, _uid, "PrimaryWeaponItems", primaryWeaponItems player] call fn_SaveToServer;
	//[_uid, _uid, "PrimaryWeaponMagazine", primaryWeaponMagazine player] call fn_SaveToServer;

	[_uid, _uid, "SecondaryWeapon", SecondaryWeapon player] call fn_SaveToServer;
	[_uid, _uid, "SecondaryWeaponItems", secondaryWeaponItems player] call fn_SaveToServer;
	//[_uid, _uid, "SecondaryWeaponMagazine", secondaryWeaponMagazine player] call fn_SaveToServer;

	[_uid, _uid, "HandgunWeapon", handgunWeapon player] call fn_SaveToServer;
	[_uid, _uid, "HandgunItems", handgunItems player] call fn_SaveToServer;
	//[_uid, _uid, "HandgunMagazine", handgunMagazine player] call fn_SaveToServer;

	[_uid, _uid, "Items", items player] call fn_SaveToServer;
	[_uid, _uid, "AssignedItems", assignedItems player] call fn_SaveToServer;
	
	_magsAmmo = [];
	{
		private "_magCounts";
		_mag = _x;
		
		{
			if (_x select 0 == _mag) then
			{
				_magCounts = _x select 1;
			};
		} forEach _magsAmmo;
		
		if (!isNil "_magCounts") then
		{
			_magCounts set [count _magCounts, _x select 1];
		}
		else
		{
			_magsAmmo set [count _magsAmmo, [_x select 0, [_x select 1]]];
		};
	} forEach (magazinesAmmo player);

	[_uid, _uid, "MagazinesWithAmmoCount", magsWithAmmoCounts] call fn_SaveToServer;
	//[_uid, _uid, "Weapons", Weapons player] call fn_SaveToServer;
	player globalChat "Player saved!";
};

// Possible new methods

