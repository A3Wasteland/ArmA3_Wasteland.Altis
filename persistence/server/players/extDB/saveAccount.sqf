// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: saveAccount.sqf
//	@file Author: AgentRev

params ["_UID", "_info", "_data"];
private ["_i", "_sqlValues"];

if !(_info isEqualTo []) then
{
	private _statuses = [];
	private _storage = [];

	for "_i" from (count _info - 1) to 0 step -1 do
	{
		switch ((_info select _i) param [0,""]) do
		{
			case "BankMoney";
			case "Bounty";
			case "BountyKills":    { _statuses pushBack (_info deleteAt _i) };
			case "PrivateStorage": { _storage = (_info deleteAt _i) param [1,[],[[]]] };
		};
	};

	if !(_statuses isEqualTo []) then
	{
		_sqlValues = [_statuses, [0,1]] call extDB_pairsToSQL;
		[["insertOrUpdatePlayerStatus", _UID, call A3W_extDB_MapID, _sqlValues select 0, _sqlValues select 1]] call extDB_Database_async;
	};

	if (["A3W_privateStorage"] call isConfigOn && !(_storage isEqualTo [])) then
	{
		_sqlValues = [_storage, [0,1]] call extDB_pairsToSQL;
		[["insertOrUpdatePlayerStorage", _UID, call A3W_extDB_MapID, _sqlValues select 0, _sqlValues select 1]] call extDB_Database_async;
	};

	if !(_info isEqualTo []) then
	{
		_sqlValues = [_info, [0,1], false] call extDB_pairsToSQL;
		[["insertOrUpdatePlayerInfo", _UID, _sqlValues select 0, _sqlValues select 1]] call extDB_Database_async;
	};
};

if !(_data isEqualTo []) then
{
	_sqlValues = [_data, [0,1]] call extDB_pairsToSQL;
	[["insertOrUpdatePlayerSave", _UID, call A3W_extDB_MapID, call A3W_extDB_ServerID, _sqlValues select 0, _sqlValues select 1]] call extDB_Database_async;
};
