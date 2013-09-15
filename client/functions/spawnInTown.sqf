//	@file Version: 1.1
//	@file Name: spawnInTown.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap
//	@file Created: 20/11/2012 05:19
//	@file Args: [int(which button)]

#define respawn_Town_Button0 3403
#define respawn_Town_Button1 3404
#define respawn_Town_Button2 3405
#define respawn_Town_Button3 3406
#define respawn_Town_Button4 3407
disableSerialization;

private ["_townNameSelected","_townName"];

_switch = _this select 0;

_display = uiNamespace getVariable "RespawnSelectionDialog";
_buttonZero = _display displayCtrl respawn_Town_Button0;
_buttonOne = _display displayCtrl respawn_Town_Button1;
_buttonTwo = _display displayCtrl respawn_Town_Button2;
_buttonThree = _display displayCtrl respawn_Town_Button3;
_buttonFour = _display displayCtrl respawn_Town_Button4;

switch(_switch) do 
{
    case 0:
    {
        {
			_name = _x select 2;
			if(ctrlText _buttonZero == _name) then
			{
                _townName = _name;
				_pos = getMarkerPos (_x select 0);
				_rad = _x select 1;
				_pos = [_pos,5,_rad,1,0,0,0] call BIS_fnc_findSafePos;
				_pos = [_pos select 0, _pos select 1, (_pos select 2) + 10];				
				player setPos _pos;
				respawnDialogActive = false;
				closeDialog 0;
			};
		}forEach (call cityList);
    };
    case 1:
    {
        {
			_name = _x select 2;
			if(ctrlText _buttonOne == _name) then
			{
                _townName = _name;
				_pos = getMarkerPos (_x select 0);
				_rad = _x select 1;
				_pos = [_pos,5,_rad,1,0,0,0] call BIS_fnc_findSafePos;
				_pos = [_pos select 0, _pos select 1, (_pos select 2) + 10];			
				player setPos _pos;
				respawnDialogActive = false;
				closeDialog 0;
			};
		}forEach (call cityList);
    };
    case 2:
    {
        {
			_name = _x select 2;
			if(ctrlText _buttonTwo == _name) then
			{
                _townName = _name;
				_pos = getMarkerPos (_x select 0);
				_rad = _x select 1;
				_pos = [_pos,5,_rad,1,0,0,0] call BIS_fnc_findSafePos;
				_pos = [_pos select 0, _pos select 1, (_pos select 2) + 10];			
				player setPos _pos;
				respawnDialogActive = false;
				closeDialog 0;
			};
		}forEach (call cityList);
    };
    case 3:
    {
        {
			_name = _x select 2;
			if(ctrlText _buttonThree == _name) then
			{
                _townName = _name;
				_pos = getMarkerPos (_x select 0);
				_rad = _x select 1;
				_pos = [_pos,5,_rad,1,0,0,0] call BIS_fnc_findSafePos;
				_pos = [_pos select 0, _pos select 1, (_pos select 2) + 10];			
				player setPos _pos;
				respawnDialogActive = false;
				closeDialog 0;
			};
		}forEach (call cityList);
    };
    case 4:
    {
        {
			_name = _x select 2;
			if(ctrlText _buttonFour == _name) then
			{
                _townName = _name;
				_pos = getMarkerPos (_x select 0);
				_rad = _x select 1;
				_pos = [_pos,5,_rad,1,0,0,0] call BIS_fnc_findSafePos;
				_pos = [_pos select 0, _pos select 1, (_pos select 2) + 10];			
				player setPos _pos;
				respawnDialogActive = false;
				closeDialog 0;
			};
		}forEach (call cityList);
    };
};
sleep 5;
_mins = floor(60 * (daytime - floor(daytime)));
[
	"Wasteland",_townName,format ["%1:%3%2", floor(daytime), _mins, if(_mins < 10) then {"0"} else {""}]
] spawn BIS_fnc_infoText;
