//	@file Version: 1.0
//	@file Name: loadAccount.sqf
//	@file Author: AgentRev
//	@file Created: 25/02/2014 22:21

if (!isServer) exitWith {};

private ["_player_uid", "_data", "_playerSaveValid", "_getValue"];

_player = _this;
_player_uid = getPlayerUID _player;

_data = [];

_result = [format["existPlayerInfo:%1", _player_uid],2] call extDB_async;

if (_result select 0) then {

	_result = [format["getPlayerSaveData:%1", _player_uid],2] call extDB_async;

	_pos = _result select 3;
	_playerSaveValid = false;
	if (_pos != "") then
	{
		_playerSaveValid = true;
	};

	_bank = 0;
	_money = 0;
	if (["A3W_moneySaving"] call isConfigOn) then
	{
		_money = _result select 7;
		_bank = [format["getPlayerInfoBank:%1", _player_uid],2] call extDB_async;
	};

	_data = [["Damage",    		_result select 1],
			["HitPoints", 		_result select 2],
			["Position",  		_pos],
			["Direction",  		_result select 4],
			["Hunger", 	  		_result select 5],
			["Thirst", 	  		_result select 6],
			["Money", 	  		_money],
			["CurrentWeapon",  	_result select 8],
			["Stance",  		_result select 9],
			["Headgear",  		_result select 10],
			["Goggles",  		_result select 11],
			["Uniform",  		_result select 12],
			["Vest",  			_result select 13],
			["Backpack",  			_result select 14],
			["UniformWeapons",  	_result select 15],
			["UniformItems",  		_result select 16],
			["UniformMagazines",  	_result select 17],
			["VestWeapons",  		_result select 18],
			["VestItems",  			_result select 19],
			["VestMagazines",  		_result select 20],
			["BackpackWeapons",  	_result select 21],
			["BackpackItems",  		_result select 22],
			["BackpackMagazines",  	_result select 23],
			["PrimaryWeapon",  			_result select 24],
			["SecondaryWeapon",  		_result select 25],
			["HandgunWeapon",  			_result select 26],
			["PrimaryWeaponItems",  	_result select 27],
			["SecondaryWeaponItems",	_result select 28],
			["HandgunItems",  			_result select 29],
			["AssignedItems",  			_result select 30],
			["PartialMagazines",  		_result select 31],
			["LoadedMagazines",  		_result select 32],
			["WastelandItems",  		_result select 33],
			["BankMoney",		  		_bank],
			["PlayerSaveValid", 		_playerSaveValid]];
}
else
{
	[format["insertPlayerInfo:%1:%2", getPlayerUID _player, name _player], 2] call extDB_async; //ASYNC METHOD 2 to prevent any possible race condition of INSERT / UPDATE
};

_data