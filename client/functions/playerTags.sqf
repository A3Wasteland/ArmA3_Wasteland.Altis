//#define __DEBUG true
if (playerSide in [INDEPENDENT,sideEnemy]) exitWith {};
#define __REFRESH 0.34
#define __DISTANCE 300

while{true}do{
   
	_target = cursorTarget;
	if (_target isKindOf "Man" && player == vehicle player) then{
		if((side _target == playerSide || playerSide in [INDEPENDENT,sideEnemy]) && (player distance _target) < __DISTANCE)then{
			if(isStreamFriendlyUIEnabled) then
			{
				_namestring = "<t size='0.5' shadow='2' color='#7FFF00'>[PLAYER]</t>";
			} else {
				_nameString = "<t size='0.5' shadow='2' color='#7FFF00'>" + format['%1',_target getVariable ['unitname', name _target]] + "</t>";
			};
			if (!isNil "_nameString") then { [_nameString,0,0.8,__REFRESH,0,0,3] spawn bis_fnc_dynamicText };
		};
	};
	
    if (!(_target isKindOf "Man") && {_target isKindOf "AllVehicles"} && {player == vehicle player}) then{
		if((side _target == playerSide || playerSide in [INDEPENDENT,sideEnemy]) && (player distance _target) < __DISTANCE && ((count crew _target) > 0))then{
            _unit = crew _target select 0;
			if(isStreamFriendlyUIEnabled) then
			{
				_namestring = "<t size='0.5' shadow='2' color='#7FFF00'>[VEHICLE]</t>";
			} else {
				_nameString = "<t size='0.5' shadow='2' color='#7FFF00'>" + format['%1',_unit getVariable ['unitname', name _target]] + "</t>";
			};
			if (!isNil "_nameString") then { [_nameString,0,0.8,__REFRESH,0,0,3] spawn bis_fnc_dynamicText };
		};
	};
    
	sleep __REFRESH;
};