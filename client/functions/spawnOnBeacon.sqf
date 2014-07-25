//	@file Version: 1.1
//	@file Name: spawnOnBeacons.sqf
//	@file Author: [404] Costlyy, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Created: 08/12/2012 18:30
//	@file Args: 

private ["_pos", "_owner"];
_pos = _this select 0;
_owner = _this select 1;

_playerPos = [_pos,1,25,1,0,0,0] call findSafePos;
waitUntil {sleep 0.1; preloadCamera _playerPos};
player setPos _playerPos;

respawnDialogActive = false;
closeDialog 0;
[format ["You have spawned on %1's beacon", _owner], 5] call mf_notify_client;

sleep 5;

_hour = date select 3;
_mins = date select 4;
["Wasteland", "Spawn Beacon", format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
