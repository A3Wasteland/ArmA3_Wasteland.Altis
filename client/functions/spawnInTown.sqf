//	@file Version: 1.1
//	@file Name: spawnInTown.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: 

private ["_marker", "_townName"];
_marker = _this;

{
	if (_x select 0 == _marker) exitWith
	{
		_pos = getMarkerPos _marker;
		_rad = _x select 1;
		_townName = _x select 2;
		
		_playerPos = [_pos,5,_rad,1,0,0,0] call findSafePos;
		waitUntil {sleep 0.1; preloadCamera _playerPos};
		player setPos _playerPos;
	};
} forEach (call cityList);

respawnDialogActive = false;
closeDialog 0;

sleep 5;

_hour = date select 3;
_mins = date select 4;
["Wasteland", _townName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
