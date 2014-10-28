// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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


		_player_pos_info = [];
		// Only save those when on ground or underwater (you probably wouldn't want to spawn 500m in the air if you get logged off in flight)
		if (isTouchingGround vehicle player || {(getPos player) select 2 < 0.5 || (getPosASL player) select 2 < 0.5}) then
		{
			_player_pos_info pushBack getPosATL player; // "Position"
			_player_pos_info pushBack direction player; // "Direction"

			if (vehicle player == player) then
			{
				_player_pos_info pushBack format ["%1", currentMuzzle player];  // "CurrentWeapon" currentMuzzle returns a number sometimes, hence the format
				_player_pos_info pushBack ([player, ["P"]] call getMoveParams); 	// "Stance",
			}
			else
			{
				_player_pos_info pushBack "";
				_player_pos_info pushBack "";
			};
		};

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

		_player_data =
		[
			damage player,  											// "Damage"
			_hitPoints, 												// "HitPoints"
			["hungerLevel", 0] call getPublicVar, 						// "Hunger"
			["thirstLevel", 0] call getPublicVar, 						// "Thirst"
			player getVariable ["cmoney", 0], 							// Money is always saved, but only restored if A3W_moneySaving = 1
			(getWeaponCargo uniformContainer player) call cargoToPairs, // UniformWeapons
			(getItemCargo uniformContainer player) call cargoToPairs, 	// UniformItems
			_uMags, 													// UniformMagazines
			(getWeaponCargo vestContainer player) call cargoToPairs, 	// VestWeapons
			(getItemCargo vestContainer player) call cargoToPairs, 		// VestItems
			_vMags, 													// VestMagazines
			(getWeaponCargo backpackContainer player) call cargoToPairs, // BackpackWeapons
			(getItemCargo backpackContainer player) call cargoToPairs, 	// BackpackItems
			_bMags 														// BackpackMagazines
		];


		// Create _gear array
		_wastelandItems = [];
		{
			if (_x select 1 > 0) then
			{
				_wastelandItems pushBack [_x select 0, _x select 1];
			};
		} forEach call mf_inventory_all;

		_gear =
		[
			uniform player,  				// "Uniform"
			vest player, 					// "Vest"
			backpack player, 				// "Backpack"
			goggles player, 				// "Goggles"
			headgear player, 				// "Headgear"

			primaryWeapon player, 			// "PrimaryWeapon"
			secondaryWeapon player,			// "SecondaryWeapon"
			handgunWeapon player, 			// "HandgunWeapon"

			primaryWeaponItems player, 		// "PrimaryWeaponItems"
			secondaryWeaponItems player, 	// "SecondaryWeaponItems"
			handgunItems player, 			// "HandgunItems"

			assignedItems player, 			// "AssignedItems"
			_partialMags, 					// "PartialMagazines"
			_loadedMags, 					// "LoadedMagazines"
			_wastelandItems 				// "Wasteland Items"

		];

		// Check if Gear needs to be updated
		_gearStr = str _gear;
		if (_gearStr != (["playerData_gear", ""] call getPublicVar)) then
		{
			playerData_gear = _gearStr;
		}
		else
		{
			_gear = [];
		};

		if (alive player) then
		{
			_player_info = [str side group player, str playerSide, player getVariable ["bmoney",0]];
			savePlayerData = [player, getPlayerUID player, _player_info, _player_pos_info, _player_data, _gear];
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
