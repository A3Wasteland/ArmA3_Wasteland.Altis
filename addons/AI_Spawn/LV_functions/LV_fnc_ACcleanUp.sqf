//ARMA3Alpha function LV_fnc_ACcleanUp v1.1 - by SPUn / lostvar
//removes dead groups and groups in defined distance
private ["_sUnit","_nearestUnit","_nsUnit","_wGroup","_leader","_uns","_i","_maxDis","_mp"];
_sUnit = _this select 0;
_maxDis = _this select 1;
_mp = _this select 2;
if(_mp)then{if(isNil("LV_GetPlayers"))then{LV_GetPlayers = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_getPlayers.sqf";};};

while{true}do{
	_i = 0;
	while{_i < (count LV_ACS_activeGroups)}do{
		_wGroup = LV_ACS_activeGroups select _i;
		_leader = leader _wGroup;
		_uns = { alive _x } count units _wGroup;
		
		
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
		
		
		if(_uns < 1)then{
			LV_ACS_activeGroups = LV_ACS_activeGroups - [_wGroup];
			switch(side _wGroup)do{
				case west:{
					LV_AI_westGroups = LV_AI_westGroups - [_wGroup];
				};
				case east:{
					LV_AI_eastGroups = LV_AI_eastGroups - [_wGroup];
				};
				case resistance:{
					LV_AI_indeGroups = LV_AI_indeGroups - [_wGroup];
				};
			};
		}else{
			if((_leader distance _nsUnit) > _maxDis)then{
				LV_ACS_activeGroups = LV_ACS_activeGroups - [_wGroup];
				switch(side _wGroup)do{
					case west:{
						LV_AI_westGroups = LV_AI_westGroups - [_wGroup];
					};
					case east:{
						LV_AI_eastGroups = LV_AI_eastGroups - [_wGroup];
					};
					case resistance:{
						LV_AI_indeGroups = LV_AI_indeGroups - [_wGroup];
					};
				};
				{ deleteVehicle _x }forEach units _wGroup;
			};
		};
		sleep 1;
		_i = _i + 1;
	};
	sleep 20;
};