///////Simple Patrol script vE 1.8 - SPUn / LostVar
//
//*simple vehicle patrol around center position
//*Syntax: nul = [this] execVM "addons\AI_Spawn\patrol-vE.sqf";
//     or: nul = [this,center,(optional: radius)] execVM "addons\AI_Spawn\patrol-vE.sqf";
//*center : [position array] (center point of patrol, f.ex. (getMarkerPos "marker1")) DEFAULT: (getPos _unit) = unit's starting position
//		  or "marker"
//		  or unit/object
//*radius : [number,random number] patrol radius as number + random(random number) DEFAULT: [50,100] (50-149)

private ["_newCenter","_unit","_newPos","_center","_pos","_crew","_run","_pDir","_pRange","_dir","_radius"];

_unit = _this select 0;
_center = _this select 1;
_radius = if (count _this > 2) then { _this select 2; }else{[50,100];};

if(isNil("_center"))then{_center = (getPos _unit);}else{_center = _center;};

_newPos = getPos _unit;
_crew = crew _unit;
_run = true;

while{_run}do{
	if(typeName _center == "ARRAY")then{
		_newCenter = _center;
	}else{
		if(_center in allMapMarkers)then{
			_newCenter = getMarkerPos _center;
		}else{
			_newCenter = getPos _center;
		};
	};

	_pDir = random 360;
    _pRange = (_radius select 0) + (random (_radius select 1));
    _newPos = [(_newCenter select 0) + (sin _pDir) * _pRange, (_newCenter select 1) + (cos _pDir) * _pRange, 0];
   
	if(surfaceIsWater _newPos)then{
			private["_randomWay","_dir"];
			_dir = ((_newCenter select 0) - (_newPos select 0)) atan2 ((_newCenter select 1) - (_newPos select 1));
			_randomWay = floor(random 2); 
			while{surfaceIsWater _newPos}do{
				if(_randomWay == 0)then{_dir = _dir + 20;}else{_dir = _dir - 20;};
				if(_dir < 0) then {_dir = _dir + 360;}; 
				_newPos = [(_newCenter select 0) + (sin _dir) * _pRange, (_newCenter select 1) + (cos _dir) * _pRange, 0];
			};
	};
	
    _pos = _newPos;
		
    {
        _x doMove _newPos;
        _x setBehaviour "SAFE";
        _x limitSpeed 1;
    } foreach _crew;
	
	if({alive _x} count crew _unit == 0)exitWith{_run = false};
    waitUntil {(unitReady _unit)||(_unit distance _pos)<30};

	
    //sleep 5 + (random 10);
};

