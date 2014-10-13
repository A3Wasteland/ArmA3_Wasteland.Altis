//	@file Version: 1.0
//	@file Name: loadAccount.sqf
//	@file Author: AgentRev
//	@file Created: 25/02/2014 22:21

if (!isServer) exitWith {};

private ["_player_uid", "_data", "_playerSaveValid", "_getValue"];

_player = _this;
_player_uid = getPlayerUID _player;

_bank = 0;
_money = 0;
_data = [];

_result = ([format["existPlayerInfo:%1", _player_uid],2] call extDB_Database_async) select 0;

if (!_result) then
{
	_player_guid = getPlayerUID _player;
	_player_name = name _player;

	_player_name = toArray _player_name;
	{
		if (_x == 58) then
		{
			_player_name set[_forEachIndex, -1];
		};
	} foreach _player_name;
	_player_name = _player_name - [-1];
	_player_name = toString _player_name;

	[format["insertPlayerInfo+Save:%1:%2:%3", call(A3W_extDB_PlayerSave_ServerID), _player_guid, _player_name], 2] call extDB_Database_async;
	_data = [
				["PlayerSaveValid", false],
				["BankMoney", _bank]
			];
}
else
{
	if (["A3W_moneySaving"] call isConfigOn) then
	{
		_bank = ([format["getPlayerInfoBank:%1", _player_uid],2] call extDB_Database_async) select 0;
	};

	_result = [format["getPlayerSaveData:%1:%2", call(A3W_extDB_PlayerSave_ServerID), _player_uid],2] call extDB_Database_async;

	_pos = "";
	if ((count _result) > 0) then // Check if There is a PlayerSaveData
	{
		_pos = _result select 2;
	};
	if (typeName _pos != "ARRAY") then
	{
		[format["replacePlayerSaveData:%1:%2", call(A3W_extDB_PlayerSave_ServerID), _player_uid],2] call extDB_Database_async; //ASYNC METHOD 2 to prevent any possible race condition of INSERT / UPDATE

		_data = [
					["PlayerSaveValid", false],
					["BankMoney", _bank]
				];
	}
	else
	{
		_pos = _result select 2;
		_playerSaveValid = false;
		if ((count _pos) > 0) then
		{
			_playerSaveValid = true;
		};

		if (["A3W_moneySaving"] call isConfigOn) then
		{
			_money = _result select 6;
		};

		_data = [["PlayerSaveValid", 		_playerSaveValid],

				["HitPoints", 				_result select 1],
				["Damage",    				_result select 0],
				["Hunger", 	  				_result select 4],
				["Thirst", 	  				_result select 5],

				["Money", 			  		_money],
				["BankMoney",		  		_bank],

				["LoadedMagazines",  		_result select 31],

				["PrimaryWeapon",  			_result select 23],
				["SecondaryWeapon",  		_result select 24],
				["HandgunWeapon",  			_result select 25],

				["PrimaryWeaponItems",  	_result select 26],
				["SecondaryWeaponItems",	_result select 27],
				["HandgunItems",  			_result select 28],

				["AssignedItems",  			_result select 29],

				["CurrentWeapon",  			_result select 7],
				["Stance",  				_result select 8],

				["Uniform",  				_result select 11],
				["Vest",  					_result select 12],
				["Backpack",  				_result select 13],
				["Goggles",  				_result select 10],
				["Headgear",  				_result select 9],

				["UniformWeapons",  		_result select 14],
				["UniformItems",  			_result select 15],
				["UniformMagazines",  		_result select 16],

				["VestWeapons",  			_result select 17],
				["VestItems",  				_result select 18],
				["VestMagazines",  			_result select 19],

				["BackpackWeapons",  		_result select 20],
				["BackpackItems",  			_result select 21],
				["BackpackMagazines",  		_result select 22],

				["PartialMagazines",  		_result select 30],

				["WastelandItems",  		_result select 32],

				["Position",  				_pos],
				["Direction",  				_result select 3]];
	};
};

_data