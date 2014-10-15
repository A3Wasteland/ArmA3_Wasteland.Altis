//	@file Version: 1.1
//	@file Name: spawnRandom.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev

waituntil {!isnil "bis_fnc_init"};

private ["_preload", "_randomLoc", "_pos", "_rad", "_townName", "_playerPos"];
_preload = [_this, 1, false, [false]] call BIS_fnc_param;

_randomLoc = (call cityList) call BIS_fnc_selectRandom;

_pos = getMarkerPos (_randomLoc select 0);
_rad = _randomLoc select 1;
_townName = _randomLoc select 2;

_playerPos = [_pos,5,_rad,1,0,0,0] call findSafePos;
if (_preload) then { waitUntil {sleep 0.1; preloadCamera _playerPos} };
player setPos _playerPos;

respawnDialogActive = false;
closeDialog 0;

_townName spawn
{
	_townName = _this;
	sleep 1;

	_hour = date select 3;
	_mins = date select 4;
	["Wasteland", _townName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
};
