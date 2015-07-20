///////Simple House Patrol script vG 1.3 - SPUn / LostVar
//
//*infantry units patrols inside nearest building and outside of it
//*Syntax: nul = [this] execVM "addons\AI_Spawn\patrol-vG.sqf";

private ["_unit","_newPos","_i","_i2","_bPoss","_building","_dir","_range","_curPos","_outOrNot"];

if(isNil("LV_nearestBuilding"))then{LV_nearestBuilding = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_nearestBuilding.sqf";};

_unit = _this select 0;
_buildings = ["nearest one",_unit] call LV_nearestBuilding;
_building = _buildings select 0; 

while { alive _unit }do{
    if(isNull(_unit findNearestEnemy _unit))then{
        _unit forceSpeed 1;
        _unit setBehaviour "SAFE";
    };

    _bPoss = [];
	_i = 0;
	while { ((_building buildingPos _i) select 0) != 0 } do {
    		_bPoss set [count (_bPoss), (_building buildingPos _i)];
		_i = _i + 1;
	};
	_i2 = 0;
    	while{_i2 < (count _bPoss)}do{
       	_newPos = (floor(random(count _bPoss)));
        	_newPos = _bPoss select _newPos;
        	waitUntil {unitReady _unit || _unit distance _newPos < 2};
        	_unit doMove _newPos;
        	waitUntil {unitReady _unit || _unit distance _newPos < 2};
        	sleep 5 + random 25;
            
         _outOrNot = ceil(random 3);
        if(_outOrNot == 1)then{
            _dir = random 360;
            _range = 10 + (random 10);
            _curPos = getPos _unit;
            _newPos = [(_curPos select 0) + (sin _dir) * _range, (_curPos select 1) + (cos _dir) * _range, 0];
            _unit doMove _newPos;
            waitUntil {unitReady _unit || _unit distance _newPos < 2};
            sleep 5 + random 25;
        }else{
            _i2 = _i2 + 1;
        };
    	};
        
        
};

