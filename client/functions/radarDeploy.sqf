//	@file Version: 1.0
//	@file Name: radarDeploy.sqf
//	@file Author: [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args: [obj(tank), player]

private["_radarTank","_player", "_stringEscapePercent", "_totalDuration", "_lockDuration", "_iteration", "_playerSide", "_playerPos", "_radarStation", "_radarStationPos", "_uniqueID", "_temp", "_markerState", "_tankFuel", "_tankDamage"];

_radarTank = (nearestobjects [getpos player, ["M1133_MEV_EP1"],  10] select 0);

// PRECONDITION: Check if mutex lock is active.
if(mutexScriptInProgress) exitWith {
	player globalChat localize "STR_WL_Errors_InProgress";
};

// PRECONDITION: Check that a player is not currently a car (driving)
if(vehicle player != player) exitWith {
	player globalChat localize "STR_WL_Errors_InVehicle";
};

// PRECONDITION: Check the vehicle is alive
if(getDammage _radarTank == 1) exitWith {
	player globalChat "NICE TRY BUT THIS TRUCK HAS HAD IT.";
    deleteVehicle _radarTank;
};

// All is good, commence to unpacking...
{
	moveOut _x;
} forEach crew _radarTank;

_radarTank setVehicleLock "LOCKED";
_radarTank limitSpeed 0;

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
		2 cutText ["Radar deploy interrupted...", "PLAIN DOWN", 1];
    	mutexScriptInProgress = false;
	};     
    
    if(player distance _currObject > 5) exitWith { // If the player dies, revert state.
		2 cutText ["Radar deploy interrupted...", "PLAIN DOWN", 1];
		mutexScriptInProgress = false;       
    };          
                                                        	    
	if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then { // Keep the player locked in medic animation for the full duration of the placement.
		player switchMove "AinvPknlMstpSlayWrflDnon_medic";
	};
			    
	_actionDuration = _actionDuration - 1;
	_iterationPercentage = floor (_iteration / _totalDuration * 100);
					    
	2 cutText [format["Unpacking radar station %1%2 complete", _iterationPercentage, _stringEscapePercent], "PLAIN DOWN", 1];
	sleep 1;					   
					    
	if (_iteration >= _totalDuration) exitWith { // Sleep a little extra to show that place has completed.
		sleep 1;
		2 cutText ["", "PLAIN DOWN", 1];
		
        
        _radarTankAmount = (nearestObjects [getpos player, ["M1133_MEV_EP1"],  10]);
                
		if(count _radarTankAmount == 0) exitWith { // Check the cheeky fuckers haven't tried to pull a fast one...
            hint "Your attempt to unpack the the radar truck was unsuccessful.";
            mutexScriptInProgress = false;
        };
                            
		_uniqueID = random 1000000;
        _temp = _uniqueID / random 1000000;
        _uniqueID = format["Radar_Marker%1", _temp];
        _markerState = 0;    
        _tankFuel = fuel _radarTank;
        _tankDamage = getDammage _radarTank;
                                                                                                                                                                                    	
		_playerPos = getPosATL player;
        _tankPos = position _radarTank;       
		_radarStation = "M1130_HQ_unfolded_Base_EP1" createVehicle ([_tankPos select 0, (_tankPos select 1) - 4, 0]);    
        _radarStation allowDamage false;
		_radarStation setVariable["R3F_LOG_disabled", true]; 
        _radarStation setVariable["UID", _uniqueID, true];          
        _radarStation setVariable["deployed", 1, true];
        _radarStation setVariable["prevFuel", _tankFuel, true];
        _radarStation setVariable["prevDamage", _tankDamage, true];
        _radarStationPos = getPos _radarStation;  
        deleteVehicle (nearestobjects [getpos player, ["M1133_MEV_EP1"],  15] select 0);

        clientRadarMarkers set [count clientRadarMarkers,[_uniqueID,_radarStationPos,_playerSide, _markerState]];
		publicVariableServer "clientRadarMarkers";
           
		mutexScriptInProgress = false;  
        hint "You have successfully unpacked the Mobile Radar Station.";
       
        player setVariable ['PG_result',[]];
        _command = format["if isServer then {this setVariable [""PG_result"",[call {[%1,%2,%3,%4] execVM 'server\functions\radarMarkerUpdate.sqf'}],true]}",str(_uniqueID),str(_radarStationPos),str(_playerSide),_markerState];
		[player, _command] spawn fn_vehicleInit;
		//processInitCommands;      
	};     
};        		

player SwitchMove "amovpknlmstpslowwrfldnon_amovpercmstpsraswrfldnon"; // Redundant reset of animation state to avoid getting locked in animation. 
