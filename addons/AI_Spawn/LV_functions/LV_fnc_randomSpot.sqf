//ARMA3Alpha function LV_fnc_randomSpot v0.5 - by SPUn / lostvar
//Picks random spot in range
private["_startSpot","_range","_dir","_newSpot","_minRange","_maxRange","_avoid"];
_startSpot = _this select 0;

if(count _this > 2)then{
	_minRange = _this select 2;
	_range = (random(_this select 1)) + _minRange;
}else{
	_range = (random(_this select 1));
};

_avoid = if (count _this > 3) then { _this select 3;} else {nil};	

if(isNil("_avoid"))then{
	_dir = random 360;
	_newSpot = [(_startSpot select 0) + (sin _dir) * _range, (_startSpot select 1) + (cos _dir) * _range, 0];
}else{
	_spotValid = false;
	while{!_spotValid}do{
		_spotValid = true;
		_dir = random 360;
		_newSpot = [(_startSpot select 0) + (sin _dir) * _range, (_startSpot select 1) + (cos _dir) * _range, 0];
		{
			if((_x distance _newSpot) <= 200)then{_spotValid = false;};
		}forEach _avoid;
		if(surfaceIsWater _newSpot)then{_spotValid = false;};
		sleep 1;
	};
};

_newSpot;