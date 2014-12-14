// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
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
		private ["_playerName", "_playerUID", "_hackType", "_hackValue"];

		_playerName = _this select 0;
		_playerUID = _this select 1;
		_hackType = _this select 2;
		_hackValue = _this select 3;

		sleep 0.5;

		[[format ["[ANTI-HACK] %1 is using cheating scripts. (%2)", _playerName, _hackType], _playerUID, _flagChecksum], "A3W_fnc_chatBroadcast", true, false] call A3W_fnc_MP;
		diag_log format ["ANTI-HACK: %1 (%2) was detected for [%3] with the value [%4]", _playerName, _playerUID, _hackType, _hackValue];

		switch (["A3W_savingMethod", "profile"] call getPublicVar) do
		{
			case "iniDB":
			{
				["Hackers" call PDB_playerFileName, "Hackers", _playerUID, [_playerName, _hackType, _hackValue]] call iniDB_write;
			};
			case "extDB":
			{
				[format ["addAntihackLog:%1:%2:%3:%4:%5", call A3W_extDB_ServerID, toString (toArray _playerName - toArray ":"), _playerUID, _hackType, _hackValue]] call extDB_Database_async;
			};
		};
	};
};
