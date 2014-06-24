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
		_UID = getPlayerUID player;
		_manualSave = [_this, 0, false, [false]] call BIS_fnc_param;

		// In case script is triggered via menu action
		if (!_manualSave) then
		{
			_manualSave = [_this, 3, false, [false]] call BIS_fnc_param;
		};

		_info = [];

		[_info, ["UID", _UID]] call BIS_fnc_arrayPush;
		[_info, ["Name", name player]] call BIS_fnc_arrayPush;
		[_info, ["Donator", if (player getVariable ["isDonator", false]) then { 1 } else { 0 }]] call BIS_fnc_arrayPush;
		[_info, ["LastSide", str side player]] call BIS_fnc_arrayPush;
		[_info, ["LastPlayerSide", str playerSide]] call BIS_fnc_arrayPush;

		_data = [];

		[_data, ["Damage", damage player]] call BIS_fnc_arrayPush;
		[_data, ["Hunger", ["hungerLevel", 0] call getPublicVar]] call BIS_fnc_arrayPush;
		[_data, ["Thirst", ["thirstLevel", 0] call getPublicVar]] call BIS_fnc_arrayPush;
		[_data, ["Money", player getVariable ["cmoney", 0]]] call BIS_fnc_arrayPush; // Money is always saved, but only restored if A3W_moneySaving = 1

		// Only save those when on ground or underwater (you probably wouldn't want to spawn 500m in the air if you get logged off in flight)
		if (isTouchingGround vehicle player || {(getPos player) select 2 < 1} || {(getPosASL player) select 2 < 1}) then
		{
			[_data, ["Position", getPosATL player]] call BIS_fnc_arrayPush;
			[_data, ["Direction", direction player]] call BIS_fnc_arrayPush;

			if (vehicle player == player) then
			{
				[_data, ["CurrentWeapon", format ["%1", currentMuzzle player]]] call BIS_fnc_arrayPush; // currentMuzzle returns a number sometimes, hence the format
				[_data, ["Stance", [player, ["P"]] call getMoveParams]] call BIS_fnc_arrayPush;
			};
		};

		_gear = [];

		[_gear, ["Uniform", uniform player]] call BIS_fnc_arrayPush;
		[_gear, ["Vest", vest player]] call BIS_fnc_arrayPush;
		[_gear, ["Backpack", backpack player]] call BIS_fnc_arrayPush;
		[_gear, ["Goggles", goggles player]] call BIS_fnc_arrayPush;
		[_gear, ["Headgear", headgear player]] call BIS_fnc_arrayPush;

		[_gear, ["PrimaryWeapon", primaryWeapon player]] call BIS_fnc_arrayPush;
		[_gear, ["SecondaryWeapon", secondaryWeapon player]] call BIS_fnc_arrayPush;
		[_gear, ["HandgunWeapon", handgunWeapon player]] call BIS_fnc_arrayPush;

		[_gear, ["PrimaryWeaponItems", primaryWeaponItems player]] call BIS_fnc_arrayPush;
		[_gear, ["SecondaryWeaponItems", secondaryWeaponItems player]] call BIS_fnc_arrayPush;
		[_gear, ["HandgunItems", handgunItems player]] call BIS_fnc_arrayPush;

		[_gear, ["AssignedItems", assignedItems player]] call BIS_fnc_arrayPush;


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
						_partialMags set [count _partialMags, [_mag, _ammo]];
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
				_loadedMags set [count _loadedMags, [_mag, _ammo]];
			};
		} forEach magazinesAmmoFull player;

		[_data, ["UniformWeapons", (getWeaponCargo uniformContainer player) call cargoToPairs]] call BIS_fnc_arrayPush;
		[_data, ["UniformItems", (getItemCargo uniformContainer player) call cargoToPairs]] call BIS_fnc_arrayPush;
		[_data, ["UniformMagazines", _uMags]] call BIS_fnc_arrayPush;

		[_data, ["VestWeapons", (getWeaponCargo vestContainer player) call cargoToPairs]] call BIS_fnc_arrayPush;
		[_data, ["VestItems", (getItemCargo vestContainer player) call cargoToPairs]] call BIS_fnc_arrayPush;
		[_data, ["VestMagazines", _vMags]] call BIS_fnc_arrayPush;

		[_data, ["BackpackWeapons", (getWeaponCargo backpackContainer player) call cargoToPairs]] call BIS_fnc_arrayPush;
		[_data, ["BackpackItems", (getItemCargo backpackContainer player) call cargoToPairs]] call BIS_fnc_arrayPush;
		[_data, ["BackpackMagazines", _bMags]] call BIS_fnc_arrayPush;

		[_gear, ["PartialMagazines", _partialMags]] call BIS_fnc_arrayPush;
		[_gear, ["LoadedMagazines", _loadedMags]] call BIS_fnc_arrayPush;

		_wastelandItems = [];
		{
			if (_x select 1 > 0) then
			{
				[_wastelandItems, [_x select 0, _x select 1]] call BIS_fnc_arrayPush;
			};
		} forEach call mf_inventory_all;

		[_gear, ["WastelandItems", _wastelandItems]] call BIS_fnc_arrayPush;


		_gearStr = str _gear;

		if (_gearStr != ["playerData_gear", ""] call getPublicVar) then
		{
			[_data, _gear] call BIS_fnc_arrayPushStack;
			playerData_gear = _gearStr;
		};

		if (alive player) then
		{
			savePlayerData = [_UID, _info, _data, player];
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
