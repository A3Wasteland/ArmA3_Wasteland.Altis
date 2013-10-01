//	@file Version: 1.1
//	@file Name: spawnInTown.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: [int(which button)]

#define respawn_Town_Button0 3403
#define respawn_Town_Button1 3404
#define respawn_Town_Button2 3405
#define respawn_Town_Button3 3406
#define respawn_Town_Button4 3407
disableSerialization;

private ["_display", "_selectedButton", "_townName"];

_display = uiNamespace getVariable "RespawnSelectionDialog";
_selectedButton = _display displayCtrl (respawn_Town_Button0 + (_this select 0));

{
	_name = _x select 2;
	if (ctrlText _selectedButton == _name) exitWith
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

_mins = date select 4;
["Wasteland", _townName, format ["%1:%3%2", date select 3, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
