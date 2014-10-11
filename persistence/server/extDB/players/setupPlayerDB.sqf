//	@file Name: setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

fn_deletePlayerSave = "persistence\server\extDB\players\deletePlayerSave.sqf" call mf_compile;
fn_loadAccount = "persistence\server\extDB\players\loadAccount.sqf" call mf_compile;


"savePlayerData" addPublicVariableEventHandler
{
	_this spawn
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


			[format["updatePlayerInfo:%1:%2:%3:%4", _player_uid, _player_lastgroupside, _player_lastPlayerside, _player_bank]] call extDB_Database_async;

			_query = "";
			if ((count _player_gear) == 0) then {
				if ((count _player_pos_info) == 4) then
				{
					// Player Position Info
					_player_pos = 			_player_pos_info select 0;
					_player_dir = 			_player_pos_info select 1;
					_player_cur_weapon = 	_player_pos_info select 2;
					_player_stance = 		_player_pos_info select 3;

					_query = "updatePlayerSaveNoGear:"
							// General
							+ str(call(A3W_extDB_PlayerSave_ServerID)) + ":" + _player_uid

							// Player Position Info
							+ ":" + str(_player_pos) + ":" + str(_player_dir) + ":" + str(_player_cur_weapon) + ":" + str(_player_stance)

							// Player Data
							+ ":" + str(_player_damage) + ":" + str(_player_hitpoints) + ":" + str(_player_hunger) + ":" + str(_player_thirst) + ":" + str(_player_money)

							+ ":" + str(_player_uniformWeapons) + ":" + str(_player_uniformItems) + ":" + str(_player_uniformMagazines) + ":" + str(_player_vestWeapons) + ":" + str(_player_vestItems)
							+ ":" + str(_player_vestMagazines) + ":" + str(_player_backpackWeapons) + ":" + str(_player_backpackItems) + ":" + str(_player_backpackMagazines);
				}
				else
				{
					_query = "updatePlayerSaveNoGearNoPos:"
							// General
							+ str(call(A3W_extDB_PlayerSave_ServerID)) + ":" + _player_uid

							// Player Data
							+ ":" + str(_player_damage) + ":" + str(_player_hitpoints) + ":" + str(_player_hunger) + ":" + str(_player_thirst) + ":" + str(_player_money)

							+ ":" + str(_player_uniformWeapons) + ":" + str(_player_uniformItems) + ":" + str(_player_uniformMagazines) + ":" + str(_player_vestWeapons) + ":" + str(_player_vestItems)
							+ ":" + str(_player_vestMagazines) + ":" + str(_player_backpackWeapons) + ":" + str(_player_backpackItems) + ":" + str(_player_backpackMagazines);
				};
			}
			else
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

				if ((count _player_pos_info) == 4) then
				{
					// Player Position Info
					_player_pos = 			_player_pos_info select 0;
					_player_dir = 			_player_pos_info select 1;
					_player_cur_weapon = 	_player_pos_info select 2;
					_player_stance = 		_player_pos_info select 3;

					_query = "updatePlayerSaveAll:"
							// General
							+ str(call(A3W_extDB_PlayerSave_ServerID)) + ":" + _player_uid

							// Player Position Info
							+ ":" + str(_player_pos) + ":" + str(_player_dir) + ":" +str(_player_cur_weapon) + ":" + str(_player_stance)

							// Player Data
							+ ":" + str(_player_damage) + ":" + str(_player_hitpoints) + ":" + str(_player_hunger) + ":" + str(_player_thirst) + ":" + str(_player_money)

							+ ":" + str(_player_uniformWeapons) + ":" + str(_player_uniformItems) + ":" + str(_player_uniformMagazines) + ":" + str(_player_vestWeapons) + ":" + str(_player_vestItems)
							+ ":" + str(_player_vestMagazines) + ":" + str(_player_backpackWeapons) + ":" + str(_player_backpackItems) + ":" + str(_player_backpackMagazines)

							// Player Gear
							+ ":" + _player_uniform + ":" + _player_vest + ":" + _player_backpack + ":" + _player_goggles + ":" + _player_headgear
							+ ":" + _player_primaryWeapon + ":" + _player_secondaryWeapon + ":" + _player_handgunWeapon
							+ ":" + str(_player_primaryWeaponItems) + ":" + str(_player_secondaryWeaponItems) + ":" + str(_player_handgunWeaponItems)
							+ ":" + str(_player_assignedItems) + ":" + str(_player_partialMags) + ":" + str(_player_loadedMags) + ":" + str(_player_wastelandItems);
				}
				else
				{
					_query = "updatePlayerSaveAllNoPos:"
							// General
							+ str(call(A3W_extDB_PlayerSave_ServerID)) + ":" + _player_uid

							// Player Data
							+ ":" + str(_player_damage) + ":" + str(_player_hitpoints) + ":" + str(_player_hunger) + ":" + str(_player_thirst) + ":" + str(_player_money)

							+ ":" + str(_player_uniformWeapons) + ":" + str(_player_uniformItems) + ":" + str(_player_uniformMagazines) + ":" + str(_player_vestWeapons) + ":" + str(_player_vestItems)
							+ ":" + str(_player_vestMagazines) + ":" + str(_player_backpackWeapons) + ":" + str(_player_backpackItems) + ":" + str(_player_backpackMagazines)

							// Player Gear
							+ ":" + _player_uniform + ":" + _player_vest + ":" + _player_backpack + ":" + _player_goggles + ":" + _player_headgear
							+ ":" + _player_primaryWeapon + ":" + _player_secondaryWeapon + ":" + _player_handgunWeapon
							+ ":" + str(_player_primaryWeaponItems) + ":" + str(_player_secondaryWeaponItems) + ":" + str(_player_handgunWeaponItems)
							+ ":" + str(_player_assignedItems) + ":" + str(_player_partialMags) + ":" + str(_player_loadedMags) + ":" + str(_player_wastelandItems);
				};
			};
			[_query] call extDB_Database_async;
		};

		if (!isNull _player && !alive _player) then
		{
			_player_uid call fn_deletePlayerSave;
		};
	};
};

"requestPlayerData" addPublicVariableEventHandler
{
	_this spawn
	{
		_player = _this select 1;

		applyPlayerData = _player call fn_loadAccount;

		(owner _player) publicVariableClient "applyPlayerData";
	};
};

"deletePlayerData" addPublicVariableEventHandler
{
	_this spawn
	{
		_player = _this select 1;
		(getPlayerUID _player) call fn_deletePlayerSave;
	};
};
