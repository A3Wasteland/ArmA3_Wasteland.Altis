//	@file Version: 1.0
//	@file Name: spawnAction.sqf
//	@file Author: [404] Deadbeat, [KoS] Bewilderbeest
//	@file Created: 20/11/2012 05:19
//	@file Args: [int(type of spawn)]

_switch = _this select 0;
_button = _this select 1;

player allowDamage true;

// If there are server donations, bump up the amount players spawn with
_baseMoney = call config_initial_spawn_money;
if (call config_player_donations_enabled == 1) then {
	_donationMoney = player getVariable ["donationMoney", 0];
	player setVariable["cmoney",_baseMoney + _donationMoney,true];
} else {
	player setVariable["cmoney",_baseMoney,true];
};

[MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_add;
[MF_ITEMS_WATER, 1] call mf_inventory_add;
[MF_ITEMS_REPAIR_KIT, 1] call mf_inventory_add;

// Remove unrealistic blur effects
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
	
	player addEventHandler ["Take",
	{
		private "_vehicle";
		_vehicle = _this select 1;
		
		if (_vehicle isKindOf "Car" && {!(_vehicle getVariable ["itemTakenFromVehicle", false])}) then
		{
			_vehicle setVariable ["itemTakenFromVehicle", true, true];
		};
	}];
    
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
