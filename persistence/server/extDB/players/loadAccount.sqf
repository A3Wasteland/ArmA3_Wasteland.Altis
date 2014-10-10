//	@file Version: 1.0
//	@file Name: loadAccount.sqf
//	@file Author: AgentRev
//	@file Created: 25/02/2014 22:21

if (!isServer) exitWith {};

private ["_player_uid", "_data", "_playerSaveValid", "_getValue"];

_player = _this;
_player_uid = getPlayerUID _player;

_result = [format["existPlayerInfo:%1", _player_uid],2] call extDB_Database_async;
if (!_result select 0) then
{
	_player_guid = getPlayerUID _player;
	_player_name = name _player;
	[format["insertPlayerInfo:%1:%2", _player_guid, _player_name], 2] call extDB_Database_async; //ASYNC METHOD 2 to prevent any possible race condition of INSERT / UPDATE
	[format["insertPlayerSaveData:%1:%2", call(A3W_extDB_ServerID), _player_guid], 2] call extDB_Database_async; //ASYNC METHOD 2 to prevent any possible race condition of INSERT / UPDATE
};


_bank = 0;
_money = 0;
if (["A3W_moneySaving"] call isConfigOn) then
{
	_bank = ([format["getPlayerInfoBank:%1", _player_uid],2] call extDB_Database_async) select 0;
};

_result = [format["getPlayerSaveData:%1:%2", call(A3W_extDB_ServerID), _player_uid],2] call extDB_Database_async;

_data = [];
if ((count _result) == 0) then
{
	[format["insertPlayerSaveData:%1:%2", call(A3W_extDB_ServerID), _player_uid],2] call extDB_Database_async; //ASYNC METHOD 2 to prevent any possible race condition of INSERT / UPDATE

	_data = [
				["PlayerSaveValid", false],
				["BankMoney", _bank]
			];
}
else
{
	_pos = _result select 2;
	_playerSaveValid = false;
	if (count _pos > 0) then
	{
		_playerSaveValid = true;
	};

	if (["A3W_moneySaving"] call isConfigOn) then
	{
		_money = _result select 6;
	};

<<<<<<< HEAD
		_data = [["Damage",    		_result select 0],
				["HitPoints", 		_result select 1],
				["Position",  		_pos],
				["Direction",  		_result select 3],
				["Hunger", 	  		_result select 4],
				["Thirst", 	  		_result select 5],
				["Money", 	  		_money],
				["CurrentWeapon",  	_result select 7],
				["Stance",  		_result select 8],
				["Headgear",  		_result select 9],
				["Goggles",  		_result select 10],
				["Uniform",  		_result select 11],
				["Vest",  			_result select 12],
				["Backpack",  			_result select 13],
				["UniformWeapons",  	_result select 14],
				["UniformItems",  		_result select 15],
				["UniformMagazines",  	_result select 16],
				["VestWeapons",  		_result select 17],
				["VestItems",  			_result select 18],
				["VestMagazines",  		_result select 19],
				["BackpackWeapons",  	_result select 20],
				["BackpackItems",  		_result select 21],
				["BackpackMagazines",  	_result select 22],
				["PrimaryWeapon",  			_result select 23],
				["SecondaryWeapon",  		_result select 24],
				["HandgunWeapon",  			_result select 25],
				["PrimaryWeaponItems",  	_result select 26],
				["SecondaryWeaponItems",	_result select 27],
				["HandgunItems",  			_result select 28],
				["AssignedItems",  			_result select 29],
				["PartialMagazines",  		_result select 30],
				["LoadedMagazines",  		_result select 31],
				["WastelandItems",  		_result select 32],
				["BankMoney",		  		_bank],
				["PlayerSaveValid", 		_playerSaveValid]];
	}

}
else
{
	_player_guid = getPlayerUID _player;
	_player_name = name _player;
	[format["insertPlayerInfo:%1:%2", _player_guid, _player_name], 2] call extDB_Database_async; //ASYNC METHOD 2 to prevent any possible race condition of INSERT / UPDATE
	[format["insertPlayerSaveData:%1:%2", call(A3W_extDB_ServerID), _player_guid], 2] call extDB_Database_async; //ASYNC METHOD 2 to prevent any possible race condition of INSERT / UPDATE
=======
	_data = [["PlayerSaveValid", 		_playerSaveValid],

			["HitPoints", 		_result select 1],
			["Damage",    		_result select 0],
			["Hunger", 	  		_result select 4],
			["Thirst", 	  		_result select 5],

			["Money", 	  		_money],
			["BankMoney",		  		_bank],

			["LoadedMagazines",  		_result select 31],

			["PrimaryWeapon",  			_result select 23],
			["SecondaryWeapon",  		_result select 24],
			["HandgunWeapon",  			_result select 25],

			["PrimaryWeaponItems",  	_result select 26],
			["SecondaryWeaponItems",	_result select 27],
			["HandgunItems",  			_result select 28],

			["AssignedItems",  			_result select 29],

			["CurrentWeapon",  	_result select 7],
			["Stance",  		_result select 8],

			["Uniform",  		_result select 11],
			["Vest",  			_result select 12],
			["Backpack",  			_result select 13],
			["Goggles",  		_result select 10],
			["Headgear",  		_result select 9],

			["UniformWeapons",  	_result select 14],
			["UniformItems",  		_result select 15],
			["UniformMagazines",  	_result select 16],

			["VestWeapons",  		_result select 17],
			["VestItems",  			_result select 18],
			["VestMagazines",  		_result select 19],

			["BackpackWeapons",  	_result select 20],
			["BackpackItems",  		_result select 21],
			["BackpackMagazines",  	_result select 22],

			["PartialMagazines",  		_result select 30],

			["WastelandItems",  		_result select 32],

			["Position",  		_pos],
			["Direction",  		_result select 3]];
>>>>>>> 61b987e... Another Fix for Player Loading
};

_data