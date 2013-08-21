//	@file Name: groupIcons.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap


private["_inGroup","_isLeader","_refresh","_distance","_myGroup","_tempArray","_icon"];

_tempArray = [];
_refresh = 0.34;  //lol they forgot to define the duration :)  also added streamfriendly support



while {true} do
{
    if(count units group player > 1) then 
    {	
        //Getting your group
		_tempArray = [];
        {
        	_tempArray set [count _tempArray,getPlayerUID _x];    
        }forEach units player;
        
		//Player Tags	   
		_target = cursorTarget;
		if (_target isKindOf "Man" && player == vehicle player) then 
        {
			if(player distance _target < 300)then 
            {
				if(getPlayerUID _target in _tempArray) then
                {
					if(isStreamFriendlyUIEnabled) then 
					{
						_nameString = "<t size='0.3' shadow='2' color='#7FFF00'>[PLAYER]</t>";
					} else {
						_nameString = "<t size='0.3' shadow='2' color='#7FFF00'>" + format['%1',_target getVariable ['unitname', name _target]] + "</t>";
					};
					if not(isNil "_nameString") then { [_nameString,0,0.8,_refresh,0,0,3] spawn bis_fnc_dynamicText; };
                };				
			};
		};
	    
	    if (!(_target isKindOf "Man") && {_target isKindOf "AllVehicles"} && {player == vehicle player}) then
        {
			if(player distance _target < 300)then 
            {
				if(getPlayerUID _target in _tempArray) then
                {
				if(isStreamFriendlyUIEnabled) then 
					{
						_nameString = "<t size='0.3' shadow='2' color='#7FFF00'>[VEHICLE]</t>";
					} else {
						_nameString = "<t size='0.3' shadow='2' color='#7FFF00'>" + format['%1',_target getVariable ['unitname', name _target]] + "</t>";
					};	
					if not(isNil "_nameString") then { [_nameString,0,0.8,_refresh,0,0,3] spawn bis_fnc_dynamicText; };
                };				
			};
		}; 	
	} else {
		_tempArray = [];
        sleep 1;        
    };
        
    private ["_storeInteractionBuffer","_storeInteractionZone","_currPos","_store","_relativeDir","_absoluteDir"];
          
    _storeInteractionBuffer = 10;
    _storeInteractionZone = 3; // The furthest away the player can be from a store to interact with it. Higher = further.
    _currPos = getPosATL player;
        
    _gunStore = nearestObjects [_currPos, ["C_man_1_1_F"], _storeInteractionZone];    
    _genStore = nearestObjects [_currPos, ["C_man_1_2_F"], _storeInteractionZone];  
     
    if (!isNull (_gunStore select 0)) then {  
        _relativeDir = [player, _gunStore select 0] call BIS_fnc_relativeDirTo;
       	_absoluteDir = abs _relativeDir;      
        
        if (_absoluteDir < _storeInteractionBuffer OR _absoluteDir > (360 - _storeInteractionBuffer)) then {
        	_nameString = "<t size='0.5' shadow='2' color='#FFFFFF'>" + "Gun Store (Press E, or use scroll wheel)" + "</t>";
       		[_nameString,0,0.8,0.5,0,0,3] spawn bis_fnc_dynamicText;
        };
    }; 
    
    if (!isNull (_genStore select 0)) then {
        _relativeDir = [player, _genStore select 0] call BIS_fnc_relativeDirTo;
       	_absoluteDir = abs _relativeDir;      
        
        if (_absoluteDir < _storeInteractionBuffer OR _absoluteDir > (360 - _storeInteractionBuffer)) then {
        	_nameString = "<t size='0.5' shadow='2' color='#FFFFFF'>" + "General Store (Press E, or use scroll wheel)" + "</t>";
       		[_nameString,0,0.8,0.5,0,0,3] spawn bis_fnc_dynamicText;
        };
    };         
};