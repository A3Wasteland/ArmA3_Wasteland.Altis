// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_setSpawnTimestamps.sqf
//	@file Author: AgentRev

#define TIMESTAMP_LOCAL (diag_tickTime - (_serverTime - _timestamp))

waitUntil {!isNull player};

[_this,
{
	params [["_spawnTimestamps",[],[[]]], ["_serverTime",0,[0]]];

	{
		_x params ["_location", "_timestamp"];

		if (_timestamp < _serverTime) then
		{
			if (_location isEqualType objNull && {_location getVariable ["a3w_spawnBeacon", false]}) then // beacon
			{
				_location setVariable ["spawnBeacon_lastUse", TIMESTAMP_LOCAL];
			};
			if (_location isEqualType "" && {count _location > 0}) then // town
			{
				player setVariable [_location + "_lastSpawn", TIMESTAMP_LOCAL];
			};
		};
	} forEach _spawnTimestamps;
}] execFSM "call.fsm";
