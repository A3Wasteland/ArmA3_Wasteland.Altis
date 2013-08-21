//	@file Version: 1.0
//	@file Name: spawnAction.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args: [int(type of spawn)]

_switch = _this select 0;
_button = _this select 1;

player removeAllEventHandlers "HandleDamage";
player setVariable["cmoney",95,true];
[MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_add;
[MF_ITEMS_WATER, 1] call mf_inventory_add;

ppEffectDestroy BIS_fnc_feedback_fatigueBlur;
ppEffectDestroy BIS_fnc_feedback_damageBlur; 

switch(_switch) do 
{
    case 0:{execVM "client\functions\spawnRandom.sqf"};
    case 1:{
	    if(showBeacons) then { 	
	    	[_button] execVM "client\functions\spawnOnBeacon.sqf"
	    } else {
	    	[_button] execVM "client\functions\spawnInTown.sqf"
	    }; 
    };
};

if(isNil{client_firstSpawn}) then {
	client_firstSpawn = true;
	[] execVM "client\functions\welcomeMessage.sqf";
    
    true spawn {      
        _startTime = floor(time);
        _result = 0;
		waitUntil
		{ 
		    _currTime = floor(time);
		    if(_currTime - _startTime >= 180) then 
		    {
		    	_result = 1;    
		    };
		    (_result == 1)
		};
		if(playerSide in [west, east]) then {
			_found = false;
			{
				if(_x select 0 == playerUID) then {_found = true;};
			} forEach pvar_teamSwitchList;
			if(!_found) then {
				pvar_teamSwitchList set [count pvar_teamSwitchList, [playerUID, playerSide]];
				publicVariable "pvar_teamSwitchList";
                
                _side = "";
                if (playerSide == BLUFOR) then {
                    _side = "BLUFOR"; 
                };
           
                if (playerSide == OPFOR) then {
                    _side = "OPFOR"; 
                };
                
				titleText [format["You have been locked to %1",_side],"PLAIN",0];
			};
		};
	};
};
