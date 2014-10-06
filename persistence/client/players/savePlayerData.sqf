//	@file Name: c_savePlayerData.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};
if (!isNil "savePlayerHandle" && {typeName savePlayerHandle == "SCRIPT"} && {!scriptDone savePlayerHandle}) exitWith {};

savePlayerHandle = _this spawn
{
	if (alive player &&
	   {!isNil "isConfigOn" && {["A3W_playerSaving"] call isConfigOn}} &&
	   {!isNil "playerSetupComplete" && {playerSetupComplete}} &&
	   {!isNil "respawnDialogActive" && {!respawnDialogActive}} &&
	   {player getVariable ["FAR_isUnconscious", 0] == 0}) then
	{
		_manualSave = [_this, 0, false, [false]] call BIS_fnc_param;

		// In case script is triggered via menu action
		if (!_manualSave) then
		{
			_manualSave = [_this, 3, false, [false]] call BIS_fnc_param;
		};

		_hitPoints = [];
		{
			_hitPoint = configName _x;
			_hitPoints pushBack [_hitPoint, player getHitPointDamage _hitPoint];
		} forEach (player call getHitPoints);

		_data =
		[
			["Damage", damage player],
			["HitPoints", _hitPoints],
			["Hunger", ["hungerLevel", 0] call getPublicVar],
			["Thirst", ["thirstLevel", 0] call getPublicVar],
			["Money", player getVariable ["cmoney", 0]] // Money is always saved, but only restored if A3W_moneySaving = 1
		];

		// Only save those when on ground or underwater (you probably wouldn't want to spawn 500m in the air if you get logged off in flight)
		if (isTouchingGround vehicle player || {(getPos player) select 2 < 0.5 || (getPosASL player) select 2 < 0.5}) then
		{
			_data pushBack ["Position", getPosATL player];
			_data pushBack ["Direction", direction player];

			if (vehicle player == player) then
			{
				_data pushBack ["CurrentWeapon", format ["%1", currentMuzzle player]]; // currentMuzzle returns a number sometimes, hence the format
				_data pushBack ["Stance", [player, ["P"]] call getMoveParams];
			};
		};

		_gear =
		[
			["Uniform", uniform player],
			["Vest", vest player],
			["Backpack", backpack player],
			["Goggles", goggles player],
			["Headgear", headgear player],

			["PrimaryWeapon", primaryWeapon player],
			["SecondaryWeapon", secondaryWeapon player],
			["HandgunWeapon", handgunWeapon player],

			["PrimaryWeaponItems", primaryWeaponItems player],
			["SecondaryWeaponItems", secondaryWeaponItems player],
			["HandgunItems", handgunItems player],

			["AssignedItems", assignedItems player]
		];


		_uMags = [];
		_vMags = [];
		_bMags = [];
		_partialMags = [];

		{
			_magArr = _x select 0;

			{
				_mag = _x select 0;
				_ammo = _x select 1;

				if (_ammo == getNumber (configFile >> "CfgMagazines" >> _mag >> "count")) then
				{
					[_magArr, _mag, 1] call fn_addToPairs;
				}
				else
				{
					if (_ammo > 0) then
					{
						_partialMags pushBack [_mag, _ammo];
					};
				};
			} forEach magazinesAmmoCargo (_x select 1);
		}
		forEach
		[
			[_uMags, uniformContainer player],
			[_vMags, vestContainer player],
			[_bMags, backpackContainer player]
		];

		_loadedMags = [];

		{
			_mag = _x select 0;
			_ammo = _x select 1;
			_loaded = _x select 2;
			_type = _x select 3;

			// if loaded in weapon, not empty, and not hand grenade
			if (_loaded && _ammo > 0 && _type != 0) then
			{
				_loadedMags pushBack [_mag, _ammo];
			};
		} forEach magazinesAmmoFull player;

		_data pushBack ["UniformWeapons", (getWeaponCargo uniformContainer player) call cargoToPairs];
		_data pushBack ["UniformItems", (getItemCargo uniformContainer player) call cargoToPairs];
		_data pushBack ["UniformMagazines", _uMags];

		_data pushBack ["VestWeapons", (getWeaponCargo vestContainer player) call cargoToPairs];
		_data pushBack ["VestItems", (getItemCargo vestContainer player) call cargoToPairs];
		_data pushBack ["VestMagazines", _vMags];

		_data pushBack ["BackpackWeapons", (getWeaponCargo backpackContainer player) call cargoToPairs];
		_data pushBack ["BackpackItems", (getItemCargo backpackContainer player) call cargoToPairs];
		_data pushBack ["BackpackMagazines", _bMags];

		_gear pushBack ["PartialMagazines", _partialMags];
		_gear pushBack ["LoadedMagazines", _loadedMags];

		_wastelandItems = [];
		{
			if (_x select 1 > 0) then
			{
				_wastelandItems pushBack [_x select 0, _x select 1];
			};
		} forEach call mf_inventory_all;

		_gear pushBack ["WastelandItems", _wastelandItems];


		_gearStr = str _gear;

		if (_gearStr != ["playerData_gear", ""] call getPublicVar) then
		{
			{ _data pushBack _x } forEach _gear;
			playerData_gear = _gearStr;
		};

		if (alive player) then
		{
			savePlayerData = [player, getPlayerUID player, str side group player, str playerSide, player getVariable ["bmoney",0], _data];
			publicVariableServer "savePlayerData";

			if (_manualSave) then
			{
				cutText ["\nPlayer saved!", "PLAIN DOWN", 0.2];
			};
		};
	};
};

if (typeName savePlayerHandle == "SCRIPT") then
{
	_savePlayerHandle = savePlayerHandle;
	waitUntil {scriptDone _savePlayerHandle};
	savePlayerHandle = nil;
};
