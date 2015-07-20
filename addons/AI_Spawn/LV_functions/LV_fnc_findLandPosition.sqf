//ARMA3Alpha function LV_fnc_findLandPosition v1.0 - by SPUn / lostvar
//Find position in land relative to given positions
private ["_dir","_pos2","_randomWay","_type","_pos1","_range"];
_type = _this select 0;
_pos1 = _this select 1;
_pos2 = _this select 2;
_range = _this select 3;

switch(_type)do{
	case 1:{
		_dir = ((_pos1 select 0) - (_pos2 select 0)) atan2 ((_pos1 select 1) - (_pos2 select 1));
		_randomWay = floor(random 2); 
		while{surfaceIsWater _pos2}do{
			if(_randomWay == 0)then{_dir = _dir + 20;}else{_dir = _dir - 20;};
			if(_dir < 0) then {_dir = _dir + 360;}; 
			_pos2 = [(_pos1 select 0) + (sin _dir) * _range, (_pos1 select 1) + (cos _dir) * _range, 0];
		};
		_pos2
	};
	case 2:{
		while{surfaceIsWater _pos2}do{
			_dir = random 360; 
			_pos2 = [(_pos1 select 0) + (sin _dir) * _range, (_pos1 select 1) + (cos _dir) * _range, 0];
		};
		_pos2
	};

};