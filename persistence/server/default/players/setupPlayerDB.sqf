//	@file Name: setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

fn_deletePlayerSave = "persistence\server\default\players\deletePlayerSave.sqf" call mf_compile;
fn_loadAccount = "persistence\server\default\players\loadAccount.sqf" call mf_compile;


"savePlayerData" addPublicVariableEventHandler
{
	_array = _this select 1;

	_player = _array select  0;
	_player_uid = _array select 1;


	if (!isNull _player && alive _player && _player getVariable ["FAR_isUnconscious", 0] == 0) then
	{
		_player_info = 		_array select 2;
		_player_pos_info = 	_array select 3;
		_player_data = 		_array select 4;
		_player_gear = 		_array select 5;

		// Info
		_player_lastgroupside = 	_player_info select 0;
		_player_lastplayerside = 	_player_info select 1;
		_player_bank = 				_player_info select 2;

		// Player Position Info
		_player_pos = 			_player_pos_info select 0;
		_player_dir = 			_player_pos_info select 1;
		_player_cur_weapon = 	_player_pos_info select 2;
		_player_stance = 		_player_pos_info select 3;

		// Data
		_player_damage = 	_player_data select 0;
		_player_hitpoints = _player_data select 1;
		_player_hunger = 	_player_data select 2;
		_player_thirst = 	_player_data select 3;
		_player_money = 	_player_data select 4;

		_player_uniformWeapons = 	_player_data select 5;
		_player_uniformItems = 		_player_data select 6;
		_player_uniformMagazines = 	_player_data select 7;
		_player_vestWeapons = 		_player_data select 8;
		_player_vestItems = 		_player_data select 9;
		_player_vestMagazines = 	_player_data select 10;
		_player_backpackWeapons = 	_player_data select 11;
		_player_backpackItems = 	_player_data select 12;
		_player_backpackMagazines = _player_data select 13;

		// Player Info
		[_player_uid call PDB_playerFileName, "PlayerInfo", "LastGroupSide", _player_lastgroupside] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerInfo", "LastPlayerSide", _player_lastplayerside] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerInfo", "BankMoney", _player_bank] call PDB_write; // iniDB_write

		// Player Position Info
		[_player_uid call PDB_playerFileName, "PlayerSave", "Position", _player_pos] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "Direction", _player_dir] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "CurrentWeapon", _player_cur_weapon] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "Stance", _player_stance] call PDB_write; // iniDB_write

		// Data
		[_player_uid call PDB_playerFileName, "PlayerSave", "Damage", _player_damage] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "HitPoints", _player_hitpoints] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "Hunger", _player_hunger] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "Thirst", _player_thirst] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "Money", _player_money] call PDB_write; // iniDB_write

		[_player_uid call PDB_playerFileName, "PlayerSave", "UniformWeapons", _player_uniformWeapons] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "UniformItems", _player_uniformItems] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "UniformMagazines", _player_uniformMagazines] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "VestWeapons", _player_vestWeapons] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "VestItems", _player_vestItems] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "VestMagazines", _player_vestMagazines] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "BackpackWeapons", _player_backpackWeapons] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "BackpackItems", _player_backpackItems] call PDB_write; // iniDB_write
		[_player_uid call PDB_playerFileName, "PlayerSave", "BackpackMagazines", _player_backpackMagazines] call PDB_write; // iniDB_write

		if ((count _player_gear) > 0) then
		{
			_player_uniform = 				_player_gear select 0;
			_player_vest = 					_player_gear select 1;
			_player_backpack = 				_player_gear select 2;
			_player_goggles = 				_player_gear select 3;
			_player_headgear = 				_player_gear select 4;

			_player_primaryWeapon = 		_player_gear select 5;
			_player_secondaryWeapon = 		_player_gear select 6;
			_player_handgunWeapon = 		_player_gear select 7;
			_player_primaryWeaponItems = 	_player_gear select 8;
			_player_secondaryWeaponItems = 	_player_gear select 9;
			_player_handgunWeaponItems = 	_player_gear select 10;

			_player_assignedItems = 		_player_gear select 11;
			_player_partialMags = 			_player_gear select 12;
			_player_loadedMags = 			_player_gear select 13;
			_player_wastelandItems = 		_player_gear select 14;

			[_player_uid call PDB_playerFileName, "PlayerSave", "Uniform", _player_uniform] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "Vest", _player_vest] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "Backpack", _player_backpack] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "Goggles", _player_goggles] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "Headgear", _player_headgear] call PDB_write; // iniDB_write

			[_player_uid call PDB_playerFileName, "PlayerSave", "PrimaryWeapon", _player_primaryWeapon] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "SecondaryWeapon", _player_secondaryWeapon] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "HandgunWeapon", _player_handgunWeapon] call PDB_write; // iniDB_write

			[_player_uid call PDB_playerFileName, "PlayerSave", "PrimaryWeaponItems", _player_primaryWeaponItems] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "SecondaryWeaponItems", _player_secondaryWeaponItems] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "HandgunItems", _player_handgunWeaponItems] call PDB_write; // iniDB_write

			[_player_uid call PDB_playerFileName, "PlayerSave", "AssignedItems", _player_assignedItems] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "PartialMagazines", _player_partialMags] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "LoadedMagazines", _player_loadedMags] call PDB_write; // iniDB_write
			[_player_uid call PDB_playerFileName, "PlayerSave", "WastelandItems", _player_wastelandItems] call PDB_write; // iniDB_write
		};
	};

	if (!isNull _player && !alive _player) then
	{
		_player_uid call fn_deletePlayerSave;
	};
};

"requestPlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;

	applyPlayerData = _player call fn_loadAccount;

	(owner _player) publicVariableClient "applyPlayerData";
};

"deletePlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;
	(getPlayerUID _player) call fn_deletePlayerSave;
};