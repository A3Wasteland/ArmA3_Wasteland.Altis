// Cargo drop script.
// Created by MarKeR - Helo and assistance from F2k Sel. Much obliged.
// For Use - Anyone, just leave these lines in here please. Thanks

// Cargo drop script used by 404Games with permission from [OCUK] MarKeR.
// Modifications made by [404] Costlyy

#include "mainMissionDefines.sqf";

if(!isServer) exitwith {};

private ["_randomPos","_plane","_cargoItem_1","_cargoItem_2","_cargoItem_3","_cargoItem_4","_parachute","_dropPosition","_picture","_vehicleName","_missionType","_hint","_startTime","_currTime"];

_plane = _this select 0;
_randomPos = _this select 1;
_picture = _this select 2;
_vehicleName = _this select 3;
_missionType = _this select 4;

_cargoItem_1 = "RUVehicleBox";
_cargoItem_2 = "USVehicleBox"; 
_cargoItem_3 = "Barrels";
_cargoItem_4 = "Land_stand_small_EP1"; 
_parachute = "ParachuteMediumWest";

_startTime = floor(time);
Waituntil {	
	_currTime = floor(time);
	if(_currTime - _startTime >= 1200) then {_result = 1;};
	(_result == 1) OR ((_plane distance _randomPos) < 2000)
};

_plane animate ["ramp_top",1];
_plane animate ["ramp_bottom",1];
_plane FlyInHeight 125;
_plane forceSpeed 150;
sleep 7;

// Spawn a parallel flare thread to make the drop off more realistic
[_plane] spawn {
	private["_plane"];	
	_plane = _this select 0;

	for "_i" from 1 to 45 do {
		if ((_plane ammo "CMFlareLauncher") == 0) then {
			_plane addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine",[-1]];
    		reload _plane;
		};
		_plane action ["useWeapon", _plane, driver _plane,0];
		sleep 0.3;
	};
};
	
Waituntil {
#ifdef __A2NET__
_currTime = floor(netTime);
#else
_currTime = floor(time);
#endif
if(_currTime - _startTime >= 1200) then {_result = 1;};
(_result == 1) OR ((_plane distance _randomPos) < 200) OR (damage _plane == 1) OR ((_plane distance _randomPos) > 2500)};

if(damage _plane == 1) then {
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Drop Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The<t color='%4'> %3</t>, was destroyed before the target area!</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
} else {
    if (((getPosATL _plane select 2) > 200) OR ((_plane distance _randomPos) > 500)) then {
        _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Drop Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The<t color='%4'> %3</t>, could not complete due to environmental conditions</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
		[_hint] call hintBroadcast;
	} else {
	    sleep 0.3;
		_dropPosition = getpos _plane;
		sleep 0.3;
		
	    //parachuteClass, position, cargoClass
	    [_parachute,_dropPosition,_cargoItem_1] call createCargoItem;
			
	    sleep 0.3;
		_dropPosition = getpos _plane;
		sleep 0.3;
	
		//parachuteClass, position, cargoClass
	    [_parachute,_dropPosition,_cargoItem_2] call createCargoItem;
			
	    sleep 0.3;
		_dropPosition = getpos _plane;
		sleep 0.3;
	
		//parachuteClass, position, cargoClass
	    [_parachute,_dropPosition,_cargoItem_3] call createCargoItem;
			
	    sleep 0.3;
		_dropPosition = getpos _plane;   
		sleep 0.3;
	    
	    //parachuteClass, position, cargoClass
	    [_parachute,_dropPosition,_cargoItem_4] call createCargoItem;         
		
	    sleep 1;
	        	
		_plane setspeedmode "full";
		_plane flyInHeight 500;
	
		// Closing Cargo Bay Doors
		_plane animate ["ramp_top",0];
		_plane animate ["ramp_bottom",0];
		
        _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Supply Drop Succesfull!</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The<t color='%4'> %3</t>, has relinquished the supplies.</t>", _missionType, _picture, _vehicleName, mainMissionColor, subTextColor];
		[_hint] call hintBroadcast;   
    
	    _plane flyInHeight 1500;
		_plane forceSpeed 600;
		Waituntil {
		_currTime = floor(time);
		if(_currTime - _startTime >= 1200) then {_result = 1;};
		(_result == 1) OR((_plane distance _randomPos) > 2500) OR (damage _plane == 1)};
	};   
};
	
