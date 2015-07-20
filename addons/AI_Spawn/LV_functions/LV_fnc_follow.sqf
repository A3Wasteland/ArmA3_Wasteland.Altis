//ARMA3Alpha function LV_fnc_follow v1.2 - by SPUn / lostvar
//Makes unit follow its target(s), which is set elsewhere (unit setVariable ["target0", target, false];) 
//Syntax: nul = [this,cycle] execVM "addons\AI_Spawn\LV_functions\LV_fnc_follow.sqf"; (on units init)
//*cycle = true or false (IF target0 is array of markers then true will make unit cycle those markers) DEFAULT: false
private ["_cycle","_unit","_target","_i2","_targetM","_dir","_nearTarget","_maxDistance","_g0","_tTarget","_groupArr","_ttE"];
_unit = _this select 0;
_cycle = _this select 1;
_target = _unit getVariable "target0";
_maxDistance = _unit getVariable "mDis0";

if(isNil("_cycle"))then{_cycle = false;}else{_cycle = _cycle;};
if(isNil("_maxDistance"))then{_maxDistance = 400;}else{_maxDistance = _maxDistance;};

[_unit] spawn {
	private ["_unit"];
	_unit = _this select 0;
	if(!alive _unit)exitWith{};
};

_groupArr = [];

if(((typeName _target) == "ARRAY"))then{
_ttE = _target select 0;
if(_ttE in allMapMarkers)then{
	if(_cycle)then{ 
	//hint "Target is MARKER ARRAY, CYCLE is ON";
		while{alive _unit}do{
			_i2 = 0;
			while{ _i2 < (count _target) } do {
				if(!alive _unit) exitWith{};
				_targetM = _target select _i2;
				_unit doMove (getMarkerPos _targetM);
				while { ((alive _unit)&&((_unit distance (getMarkerPos _targetM)) > 10))||(!unitReady _unit) } do { sleep 10; };
				_i2 = _i2 + 1;
			};
		};
	}else{
	//hint "Target is MARKER ARRAY, CYCLE is OFF";
		_i2 = 0;
		while{ _i2 < (count _target) } do {
			if(!alive _unit) exitWith{};
			_targetM = _target select _i2;
			_unit doMove (getMarkerPos _targetM);
			while { ((alive _unit)&&((_unit distance (getMarkerPos _targetM)) > 10))||(!unitReady _unit) } do { sleep 10; };
			_i2 = _i2 + 1;
		};
	};
	}else{
		if(typeName _ttE == "GROUP")then{
			//hint "Target is GROUP ARRAY";
			_g0 = 0;
			while{_g0 < count _target}do{
				{ _groupArr set[(count _groupArr), _x] } forEach units (_target select _g0);
				_g0 = _g0 + 1;
			};
				
			while{true}do{
				_tTarget = _groupArr select floor(random(count _groupArr));
				{
					if((_x distance _unit) < (_tTarget distance _unit))then{
						_tTarget = _x;
					};	
				}forEach _groupArr;
				if((_tTarget distance _unit) < _maxDistance)then{
					if(side _unit == side _tTarget)then{
						_dir = random 360;
						_nearTarget = [((getPos _tTarget) select 0) + (sin _dir) * 35, ((getPos _tTarget) select 1) + (cos _dir) * 35, 0];
						if(_unit distance _tTarget > 35)then{ _unit domove _nearTarget; };
					}else{
						_unit doMove (getPos _tTarget);
					};
				}else{
					//hint "Target too far, AI idling";
				};
				sleep 10;
			};

		};
	};
}else{
	if(((typeName _target) == "GROUP"))then{
		//hint "Target is single GROUP";
		if((typeName _target) == "GROUP")then{ //if target is single group
			{ _groupArr set[(count _groupArr), _x] } forEach units _target;
		};	
	
		while{true}do{
			_tTarget = _groupArr select floor(random(count _groupArr));
			{
				if((_x distance _unit) < (_tTarget distance _unit))then{
					_tTarget = _x;
				};	
			}forEach _groupArr;
			if((_tTarget distance _unit) < _maxDistance)then{
				if(side _unit == side _tTarget)then{
					_dir = random 360;
					_nearTarget = [((getPos _tTarget) select 0) + (sin _dir) * 35, ((getPos _tTarget) select 1) + (cos _dir) * 35, 0];
					if(_unit distance _tTarget > 35)then{ _unit domove _nearTarget; };
				}else{
					_unit doMove (getPos _tTarget);
				};
			}else{
				//hint "Target too far, AI idling";
			};
			sleep 10;
		};
			
	}else{ 
	//hint "Target is single UNIT";
		while {true} do { 
			if(!alive _target)then{waitUntil{sleep 1; alive _target};};
			if(side _unit == side _target)then{
				_dir = random 360;
				_nearTarget = [((getPos _target) select 0) + (sin _dir) * 35, ((getPos _target) select 1) + (cos _dir) * 35, 0];
				if(_unit distance _target > 35)then{ _unit domove _nearTarget; };
			}else{
				_unit doMove (getPos _target);
			};
			sleep 10; 
		};
	};
};
