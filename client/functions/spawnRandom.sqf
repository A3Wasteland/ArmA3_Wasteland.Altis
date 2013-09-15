//	@file Version: 1.1
//	@file Name: spawnRandom.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap

waituntil {!isnil "bis_fnc_init"};

private ["_townName","_randomLoc","_pos"];

_randomLoc = (call cityList) call BIS_fnc_selectRandom;

_pos = getMarkerPos (_randomLoc select 0);
_pos = [_pos,(_randomLoc select 1),((_randomLoc select 1) + 30),1,0,0,0,[],[_pos]] call BIS_fnc_findSafePos;
_pos = [_pos select 0, _pos select 1, ((_pos select 2) + 5)];
player setPos _pos;

respawnDialogActive = false;
closeDialog 0;

_mins = floor(60 * (daytime - floor(daytime)));
_townName = _randomLoc select 2;
["Wasteland",_townName,format ["%1:%3%2", floor(daytime), _mins, if(_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
