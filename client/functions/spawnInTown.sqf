//	@file Version: 1.1
//	@file Name: spawnInTown.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: 

private ["_buttonText", "_townName"];
_buttonText = _this select 0;
_townName = "[ERROR]";

{
	_name = _x select 2;
	if (_buttonText == _name) exitWith
	{
		_townName = _name;
		_pos = getMarkerPos (_x select 0);
		_rad = _x select 1;
		player setPos ([_pos,5,_rad,1,0,0,0] call findSafePos);
	};
} forEach (call cityList);

respawnDialogActive = false;
closeDialog 0;

sleep 5;

_hour = date select 3;
_mins = date select 4;
["Wasteland", _townName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
