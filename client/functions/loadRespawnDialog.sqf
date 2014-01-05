//	@file Version: 1.0
//	@file Name: loadRespawnDialog.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, MercyfulFate
//	@file Created: 20/11/2012 05:19
//	@file Args:

#define respawn_Content_Text 3401
#define respawn_MissionUptime_Text 3402
#define respawn_Town_Button0 3403
#define respawn_Town_Button1 3404
#define respawn_Town_Button2 3405
#define respawn_Town_Button3 3406
#define respawn_Town_Button4 3407
#define respawn_PlayersInTown_Text0 3408
#define respawn_PlayersInTown_Text1 3409
#define respawn_PlayersInTown_Text2 3410
#define respawn_PlayersInTown_Text3 3411
#define respawn_PlayersInTown_Text4 3412

waitUntil{!isnil "bis_fnc_init"};
disableSerialization;

private["_player","_city","_radius","_name","_enemyCount","_friendlyCount","_side","_dynamicControlsArray", "_enemyPresent","_inGroup","_tempArray", "_text", "_players", "_playerArray"];

createDialog "RespawnSelectionDialog";
_display = uiNamespace getVariable "RespawnSelectionDialog";
_display displayAddEventHandler ["KeyDown", "_return = false; if(respawnDialogActive && (_this select 1) == 1) then {_return = true;}; _return"];
_respawnText = _display displayCtrl respawn_Content_Text;
_missionUptimeText = _display displayCtrl respawn_MissionUptime_Text;
_friendlyCount = 0;
_enemyCount = 0;

if(playerSide == BLUFOR) then {_side = "BLUFOR"};
if(playerSide == OPFOR) then {_side = "OPFOR"};
if(playerSide in [INDEPENDENT,sideEnemy]) then {_side = "Independent"}; 
_respawnText ctrlSetStructuredText parseText (format["Welcome to Wasteland<br/>You are on %1. Please select a spawn point.",_side]);
respawnDialogActive = true;

_dynamicControlsArray = [
	[respawn_Town_Button0,respawn_PlayersInTown_Text0],
    [respawn_Town_Button1,respawn_PlayersInTown_Text1],
    [respawn_Town_Button2,respawn_PlayersInTown_Text2],
    [respawn_Town_Button3,respawn_PlayersInTown_Text3],
    [respawn_Town_Button4,respawn_PlayersInTown_Text4]];

{
    _button = _display displayCtrl (_x select 0);
    _button ctrlSetText format[""];
    _button ctrlShow false;
}foreach _dynamicControlsArray;

_friendlyTowns = [];
_tempArray = [];
showBeacons = false;
_inGroup = false;
while {respawnDialogActive} do
{
    _timeText = [time/60/60] call BIS_fnc_timeToString;
    _missionUptimeText ctrlSetText format["Mission uptime: %1", _timeText];
    if(_side != "Independent") then
    {  
        if(!showBeacons) then {
            {
                _pos = getMarkerPos (_x select 0);
                _name = _x select 2;
                _rad = _x select 1;
                _playerArray = [];

                {
                    if((getPos _x distance _pos) < _rad) then
                    {
                        if(side _x == playerSide AND alive _x) then
                        {
                            _friendlyCount = _friendlyCount + 1;
							if(isStreamFriendlyUIEnabled) then
							{ 
								_playerArray set [count _playerArray, "[PLAYER]"]; 
							} else {
								_playerArray set [count _playerArray, name _x];
							};     
                        }else{
                            _enemyCount = _enemyCount + 1;
                        };
                    }; 
                }forEach playableUnits;  

                if((_friendlyCount > 0) AND (_enemyCount == 0)) then
                {
                    _friendlyTowns set [count _friendlyTowns, [_name, _playerArray]];                    
                };
                _friendlyCount = 0;
                _enemyCount = 0; 
                
            }forEach (call cityList); 

            {
                _button = _display displayCtrl (_x select 0);
                _text = _display displayCtrl (_x select 1);
                
                if(_forEachIndex <= count _friendlyTowns -1) then
                {
                	// Set the button details
                    _button ctrlShow true;
                    _name = _friendlyTowns select _forEachIndex select 0;
                    _button ctrlSetText	format["%1",_name]; 
                    // Set the players in town text details
                    _text ctrlShow true;
                    _players = _friendlyTowns select _forEachIndex select 1;
                    _text ctrlSetText format["%1",_players]; 
                } else {
                    _name = "";
                    // reset button text and disable
                    _button ctrlSetText _name;
                    _button ctrlShow false; 
                    // reset players text and disable
                    _text ctrlSetText _name;
                    _text ctrlShow false; 
                };          
            } forEach _dynamicControlsArray;
            
            _friendlyTowns = [];    
            
        } else {
            _enemyCount = 0;
            {
                _button = _display displayCtrl (_x select 0);
                _text = _display displayCtrl (_x select 1);
                
                _button ctrlSetText format[""];
                _button ctrlShow false;   
                _text ctrlSetText format[""];
                _text ctrlShow false;  
                
            } foreach _dynamicControlsArray;
            _btn_number = 0;
            _btn_max = count _dynamicControlsArray;
			
            if (!isNil "pvar_spawn_beacons") then
            {
                { // forEach pvar_spawn_beacons
                    if(_x getVariable ["side", ""] == playerSide) then {
                        _button = _display displayCtrl (_dynamicControlsArray select _btn_number select 0);
                        _enemyCount = 0;
                        _centrePos = getPos _x;
                        { 
                            if(playerSide != side _x) then {
                                if((_x distance _centrePos) < 100) then {
                                    _enemyCount = _enemyCount + 1; 
                                }; 
                            };  
                        } forEach playableUnits;

                        _allowed = false;
                        _groupOnly = _x getVariable ["groupOnly", false];
                        _beaconOwnerUID = _x getVariable ["ownerUID", 0];
                        if (_groupOnly) then {
                            {
                                if (getPlayerUID _x == _beaconOwnerUID) then {
                                    _allowed = true;
                                };
                            } forEach (units group player);
                        } else {
                            _allowed = true;
                        };

                        if(_allowed && {_enemyCount == 0} && {damage _x < 1}) then {
                            _button ctrlSetText format["%1",_x getVariable ["ownerName", ""]]; 
                            _button ctrlShow true;
                            _btn_number = _btn_number + 1;
                        };
                    };
                    if (_btn_number >= _btn_max) exitWith {}; // no more buttons to display on
                } forEach pvar_spawn_beacons;
			};
        };
    } else {
        _tempArray = [];
        {
        	_tempArray set [count _tempArray,getPlayerUID _x];    
        }forEach units player;
                    
        //Towns
    	if(!showBeacons) then 
        {
        	{
                _pos = getMarkerPos (_x select 0);
                _name = _x select 2;
                _rad = _x select 1;

                {
                    if((getPos _x distance _pos) < _rad) then
                    {
                        if(getPlayerUID _x in _tempArray) then
                        {
                            _friendlyCount = _friendlyCount + 1;
                        }else{
                            _enemyCount = _enemyCount + 1;
                        };
                    };
                }forEach playableUnits;

                if((_friendlyCount > 0) AND (_enemyCount == 0)) then
                {
					_friendlyTowns set [count _friendlyTowns, _name];
                };
                _friendlyCount = 0;
                _enemyCount = 0; 
            }forEach (call cityList); 

            {
                _button = _display displayCtrl (_x select 0);
                if(_forEachIndex <= count _friendlyTowns -1) then
                {
                    _button ctrlShow true;
                    _name = _friendlyTowns select _forEachIndex;
                    _button ctrlSetText	format["%1",_name];  
                } else {
                    _name = "";
                    _button ctrlSetText _name;
                    _button ctrlShow false; 
                };          
            }forEach _dynamicControlsArray;
            _friendlyTowns = [];    
        } else { // Independant Spawn Beacons
diag_log "==============starting spawn beacon check";
            {
                if([_x] call mf_items_spawn_beacon_can_use) then {
diag_log format["checking beacon %1: %2, %3", _forEachIndex, _x getVariable "side", _x getVariable "groupOnly"];
                    _button = _display displayCtrl (_dynamicControlsArray select _btn_number select 0);
                    _enemyCount = 0;
                    _centrePos = getPos _x;
                    { 
                        if(group player != group _x) then {
                            if((_x distance _centrePos) < 100) then {
                                _enemyCount = _enemyCount + 1; 
diag_log "Enemy too close";
                            }; 
                        };  
                    } forEach playableUnits;

                    if({_enemyCount == 0} && {damage _x < 1}) then {
diag_log "adding beacon";
                        _button ctrlSetText format["%1",_x getVariable ["ownerName", ""]]; 
                        _button ctrlShow true;
                        _btn_number = _btn_number + 1;
                    };
                };
                if (_btn_number >= _btn_max) exitWith {}; // no more buttons to display on
            } forEach pvar_spawn_beacons;
        };	    
    };
    sleep 0.1;
};
