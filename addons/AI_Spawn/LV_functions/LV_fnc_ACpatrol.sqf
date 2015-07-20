//ARMA3Alpha function LV_fnc_ACpatrol v1.9 - by SPUn / lostvar
private ["_area","_angLe","_sUnit","_nearestUnit","_nsUnit","_range","_dir","_newPos","_randomWay","_wp1","_wGroup","_leader","_i","_maxRange","_pType","_mp","_validSpot","_m","_tPos","_dis","_spawnPos","_avoidArray"];
_sUnit = _this select 0;
_maxRange = _this select 1;
_pType = _this select 2;
_mp = _this select 3;
if(_mp)then{if(isNil("LV_GetPlayers"))then{LV_GetPlayers = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_getPlayers.sqf";};};
if(isNil("LV_IsInMarker"))then{LV_IsInMarker = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_isInMarker.sqf";};
/*
fn_drawLine = compile preprocessFileLineNumbers "fn_drawLine.sqf";
fn_r2Dis = compile preprocessFileLineNumbers "fn_R2Dis.sqf";
fn_r2Ang = compile preprocessFileLineNumbers "fn_R2Ang.sqf";
fn_p2R = compile preprocessFileLineNumbers "fn_P2R.sqf";

fnc_Create_Marker = { //[position,color]
	private["_pos","_color","_nameValid","_num","_name","_marker"];
	_pos = _this select 0;
	_color = _this select 1;
	if(isNil("LV_Markers"))then{LV_Markers = [];};
	_nameValid = false;
	while{!_nameValid}do{
		_num = round(random 10000);
		_name = ("lvmarker"+(str _num));
		if(!(_name in LV_Markers))then{_nameValid = true;};
	};
	_marker = createMarker[_name,_pos];
	_name setMarkerShape "ICON";
	_name setMarkerType "mil_dot";
	_name setMarkerColor _color;
	LV_Markers set[(count LV_Markers),_name];
};
*/
while{true}do{
	//hint "patrol";
	_i = 0;
	while{_i < (count LV_ACS_activeGroups)}do{
		_wGroup = LV_ACS_activeGroups select _i;
		_leader = leader _wGroup;
		
		if(((typeName _sUnit) == "ARRAY")||(_mp))then{
			if(_mp)then{ _sUnit = call LV_GetPlayers;};
			if((count _sUnit)>1)then{
				_nearestUnit = _sUnit select 0;
				{
				  if((_x distance _leader)<(_nearestUnit distance _leader))then{
					_nearestUnit = _x;
				  };
				}forEach _sUnit;
				_nsUnit = _nearestUnit;
			}else{
				_nsUnit = _sUnit select 0;
			};	
		}else{
			_nsUnit = _sUnit;
		};
		
		if(unitReady _leader)then{
			_angLe = 45;
			_validSpot = false;
			_range = _leader distance _nsUnit;
			if(_range < _maxRange)then{_range = _maxRange;};
			while{!_validSpot}do{
				
				_dir = (((getPos _nsUnit) select 0) - ((getPos _leader) select 0)) atan2 (((getPos _nsUnit) select 1) - ((getPos _leader) select 1));
				//hint format["%1 - %2",((getPos _nsUnit) select 0),((getPos _leader) select 0)];
				if(_dir < 0) then {_dir = _dir + 360;}; 
				_dir = (_dir - _angLe) + random (_angLe * 2);
				if(_dir < 0) then {_dir = _dir + 360;}; 
				_newPos = [((getPos _leader) select 0) + (sin _dir) * (_range), ((getPos _leader) select 1) + (cos _dir) * (_range), 0];
				
				if(!surfaceIsWater (getPos _leader))then{ //land units
					if(surfaceIsWater _newPos)then{ 
						//private["_randomWay","_dir"];
						_dir = (((getPos _nsUnit) select 0) - ((getPos _leader) select 0)) atan2 (((getPos _nsUnit) select 1) - ((getPos _leader) select 1));
						_randomWay = floor(random 2);
						while{surfaceIsWater _newPos}do{
							if(_randomWay == 0)then{_dir = _dir + 20;}else{_dir = _dir - 20;};
							if(_dir < 0) then {_dir = _dir + 360;}; 
							_newPos = [((getPos _nsUnit) select 0) + (sin _dir) * _range, ((getPos _nsUnit) select 1) + (cos _dir) * _range, 0];
						};
						_validSpot = true;
					}else{
						_validSpot = true;
					}; 
				}else{ //water units
					_newPos = [_newPos,0,200,5,2,10,0] call BIS_fnc_findSafePos;
					_validSpot = true;
				};

				if(_validSpot)then{
					_avoidArray = [];
					for "_i" from 0 to 30 do {
						if(_i == 0)then{_m = "ACavoid";}else{_m = ("ACavoid_" + str _i);};
						if(_m in allMapMarkers)then{_avoidArray set[(count _avoidArray),_m];};
					};
					{
						_area = _x;
						if([_newPos,_area] call LV_IsInMarker)exitWith{_validSpot = false;};
						_dir = ((_newPos select 0) - ((getPos _leader) select 0)) atan2 ((_newPos select 1) - ((getPos _leader) select 1));
						_dis = _range * 2;
						while{_dis > 0}do{
							_tPos = [((getPos _leader) select 0) + (sin _dir) * _dis, ((getPos _leader) select 1) + (cos _dir) * _dis, 0];
							//[_tPos, "COLORRED"] call fnc_Create_Marker;
							if([_tPos,_area] call LV_IsInMarker)exitWith{_validSpot = false;};
							_dis = _dis - 15;
						};
						if(!_validSpot)exitWith{};
					}forEach _avoidArray;
					//if(_angLe < 90)then{_angLe = _angLe + 10;};
					_range = _range - 25;
				};
			};
				//[_newPos, "COLORGREEN"] call fnc_Create_Marker;
				//[(getPos _leader), "COLORBLUE"] call fnc_Create_Marker;
				//nul = [_newPos, (getPos _leader), "COLORGREEN", 2, 2] call fn_drawLine;

			if((typeName _pType) == "ARRAY")then{
				_wp1 = _wGroup addWaypoint [_newPos, 0];
				_wp1 setWaypointType (_pType select 1);
				_wp1 setWaypointBehaviour (_pType select 0);
				_wp1 setWaypointCombatMode "RED";
				_wp1 setWaypointSpeed "FULL";
			}else{
				{_x doMove _newPos;}forEach units _wGroup;
			};
		};
		sleep 1;
		_i = _i + 1;
	};
	sleep 20;
};