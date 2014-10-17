//	@file Version: 1.0
//	@file Name: flagHandler.sqf
//	@file Author: AgentRev
//	@file Created: 04/06/2013 21:31

if (typeName _this == "ARRAY" && {count _this > 4}) then
{
	private ["_sentChecksum", "_A3W_savingMethod", "_query"];
	_sentChecksum = _this select 4;

	if (_sentChecksum == _flagChecksum) then
	{
		private ["_playerName", "_playerID", "_hackType", "_hackValue"];

		_playerName = _this select 0;
		_playerID = _this select 1;
		_hackType = _this select 2;
		_hackValue = _this select 3;

		// Bug #8396 - serverCommand doesn't work for ARMA 3 as of 2013-05-16
		// serverCommand format ["#exec ban %1", _playerID];
		// serverCommand format ["#kick %1", _playerID];

		sleep 0.5;

		[[format ["[ANTI-HACK] %1 is using cheating scripts. (%2)", _playerName, _hackType], _playerID, _flagChecksum], "A3W_fnc_chatBroadcast", true, false] call A3W_fnc_MP;
		diag_log format ["ANTI-HACK: %1 (%2) was detected for [%3] with the value [%4]", _playerName, _playerID, _hackType, _hackValue];

		// Save detection infos in iniDB file for easy retrieval
		_A3W_savingMethod = ["A3W_savingMethod", 1] call getPublicVar;
		switch (_A3W_savingMethod) do
		{
			case 2: {
						["Hackers" call PDB_objectFileName, "Hackers", _playerID, [_playerName, _hackType, _hackValue]] call iniDB_write;
					};
			case 3: {
						_playerName = toArray _playerName;
						{
							if (_x == 58) then
							{
								_playerName set[_forEachIndex, -1];
							};
						} foreach _playerName;
						_playerName = _playerName - [-1];
						_playerName = toString _playerName;
						_query = "addHackerLog:" + str(call(A3W_extDB_ServerID)) + ":" + _playerID + ":" + _playerName + ":" + str(_hackType) + ":" + str(_hackValue);
						[_query] call extDB_Database_async;
					};
		};
	};
};
