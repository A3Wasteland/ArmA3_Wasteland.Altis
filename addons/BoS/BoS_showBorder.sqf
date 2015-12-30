//	@file Version: 1.0
//	@file Name: showBorder.sqf
//	@file Author: Cael817, all credit to Larrow
//	@file Created: 20150217 21:19
//	@file Info:

#define RADIUS 30
#define AMOUNT 100


_target = cursorTarget;
_target_pos = getPos _target;

//hint format["%1", _target_pos];

if (isNil "borderObjects") then {
    borderObjects = [];
    _rad = RADIUS;
    _bcount = AMOUNT;
    _inc = 360/_bcount; 
    for "_ang" from 1 to 360 step _inc do {
        _a = (_target_pos select 0)+(sin(_ang)*_rad);
        _b = (_target_pos select 1)+(cos(_ang)*_rad);
        _pos = [_a,_b,_target_pos select 2];
        _light = "Sign_Arrow_Large_F" createVehicle _pos;
        _light setPos _pos;
		borderObjects pushBack _light;
    };
	//["Added Markers around the base radius (30m) they will be removed in 30 seconds", 5] call mf_notify_client;
	[format ["Added Markers around the base radius (%1m) they will be removed in 30 seconds",RADIUS], 5] call mf_notify_client;	
};

sleep 30;
if ( !(isNil "borderObjects") ) then {
    {
        deleteVehicle _x;    
    }forEach borderObjects;
    borderObjects = nil;
};  
