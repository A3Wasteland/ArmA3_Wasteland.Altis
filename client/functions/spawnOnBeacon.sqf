//	@file Version: 1.1
//	@file Name: spawnOnBeacons.sqf
//	@file Author: [404] Costlyy, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Created: 08/12/2012 18:30
//	@file Args: 

private ["_beacon", "_pos", "_owner", "_preload", "_playerPos"];
_beacon = _this select 0;
_pos = _beacon select 0;
_owner = _beacon select 1;
_preload = [_this, 1, false, [false]] call BIS_fnc_param;

_playerPos = [_pos,1,25,1,0,0,0] call findSafePos;
if (_preload) then { waitUntil {sleep 0.1; preloadCamera _playerPos} };
player setPos _playerPos;

respawnDialogActive = false;
closeDialog 0;

_owner spawn
{
	_owner = _this;
	_ownerArr = toArray _owner;
	_letter = if (toString [_ownerArr select (count _ownerArr - 1)] == "s") then { "" } else { "s" };
	sleep 1;

	_hour = date select 3;
	_mins = date select 4;
	["Wasteland", format ["%1'%2 beacon", _owner, _letter], format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
};
