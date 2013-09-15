//	@file Version: 1.0
//	@file Name: radarPack.sqf
//	@file Author: [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args: [obj(tank), player]

private["_radarTank","_player", "_stringEscapePercent", "_totalDuration", "_lockDuration", "_iteration", "_playerSide", "_playerPos", "_radarStation", "_uniqueID"];

_radarStation = (nearestobjects [getpos player, ["M1130_HQ_unfolded_Base_EP1"],  10] select 0);

// PRECONDITION: Check if mutex lock is active.
if(mutexScriptInProgress) exitWith {
	player globalChat localize "STR_WL_Errors_InProgress";
};

// PRECONDITION: Check that a player is not currently a car (driving)
if(vehicle player != player) exitWith {
	player globalChat localize "STR_WL_Errors_InVehicle";
};

// All is good, commence to re-pack

_stringEscapePercent = "%"; // Required to get the % sign into a formatted string.
_totalDuration = 45; // This will NOT be easy >:)
_actionDuration = _totalDuration;
_iteration = 0;
_playerSide = str(playerSide);
		
player switchMove "AinvPknlMstpSlayWrflDnon_medic"; // Begin the full medic animation...

mutexScriptInProgress = true;

for "_iteration" from 1 to _actionDuration do {
		
	if(vehicle player != player) exitWith {
		player globalChat localize "STR_WL_Errors_BeaconInVehicle";
        player action ["eject", vehicle player];
		sleep 1;
	};
    
    if (doCancelAction) exitWith {// Player selected "cancel action".
    	2 cutText ["", "PLAIN DOWN", 1];
        doCancelAction = false;
    	mutexScriptInProgress = false;
	}; 
    
    if (!(alive player)) exitWith {// If the player dies, revert state.
		2 cutText ["Pack radar station interrupted...", "PLAIN DOWN", 1];
    	mutexScriptInProgress = false;
	}; 

	if(player distance _currObject > 5) exitWith { // If the player dies, revert state.
		2 cutText ["Pack radar station interrupted...", "PLAIN DOWN", 1];
		mutexScriptInProgress = false;       
    };                         
                                                        	    
	if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then { // Keep the player locked in medic animation for the full duration of the placement.
		player switchMove "AinvPknlMstpSlayWrflDnon_medic";
	};
			    
	_actionDuration = _actionDuration - 1;
	_iterationPercentage = floor (_iteration / _totalDuration * 100);
					    
	2 cutText [format["Re-packing radar station %1%2 complete", _iterationPercentage, _stringEscapePercent], "PLAIN DOWN", 1];
	sleep 1;
					    
	if (_iteration >= _totalDuration) exitWith { // Sleep a little extra to show that place has completed.
		sleep 1;
		2 cutText ["", "PLAIN DOWN", 1];
	         
        _radarStationAmount = (nearestObjects [getpos player, ["M1130_HQ_unfolded_Base_EP1"],  10]);
                
		if(count _radarStationAmount == 0) exitWith { // Check the cheeky fuckers haven't tried to pull a fast one...
            hint "Your attempt to re-pack the radar station was unsuccessful.";
            mutexScriptInProgress = false;
        };               
                         
        _uniqueID = _radarStation getVariable "UID";               
        _playerPos = getPosATL player;
        _stationPos = position _radarStation;
        _radarTank = "M1133_MEV_EP1" createVehicle (_stationPos);
        _radarTank setVariable ["deployed", 0, true];
        _radarTank setVariable [call vChecksum, true, false];
        _radarTank setFuel (_radarStation getVariable "prevFuel");
        _radarTank setDamage (_radarStation getVariable "prevDamage");
      	deleteVehicle (nearestobjects [getpos player, ["M1130_HQ_unfolded_Base_EP1"],  15] select 0);
      
		{
	    	if(_x select 0 == _uniqueID) then {
		    	clientRadarMarkers set [_forEachIndex, "REMOVETHISCRAP"];
				clientRadarMarkers = clientRadarMarkers - ["REMOVETHISCRAP"];
		        publicVariableServer "clientRadarMarkers";    
		    };
		}forEach clientRadarMarkers;   
                                   
		mutexScriptInProgress = false; 
        hint "You have successfully re-packed the Mobile Radar Station.";       
	};     
};        		

player SwitchMove "amovpknlmstpslowwrfldnon_amovpercmstpsraswrfldnon"; // Redundant reset of animation state to avoid getting locked in animation. 