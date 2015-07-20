///////Door Close Script 0.11 - SPUn / LostVar
private ["_unit","_building","_players","_n","_v","_inUnits","_sel","_position","_runningAlready","_doorPositions","_bdCfg","_avoidDoors","_goodToClose","_doors","_bDoors","_unUnits"];
_unit = _this select 0;
_building = _this select 1;

//Keep track of AI's patrolling this building, store the data in building
_inUnits = (_building getVariable "InUnits");
if(isNil("_inUnits"))then{_inUnits = [];};
if(!(_unit in _inUnits))then{
	_inUnits set[(count _inUnits),_unit];
	_building setVariable ["InUnits", _inUnits, false];
};
sleep 0.2;

//check if script is running on this building already
_runningAlready = (_building getVariable "RunningAlready");

if(isNil("_runningAlready"))then{//and if not, then mark it up as started
	_runningAlready = true;
	_building setVariable ["RunningAlready", _runningAlready, false];
	//and save door positions
	_doorPositions = [];
	_bdCfg = (configFile >> "cfgVehicles" >> (typeOf _building) >> "UserActions"); //get config for doors
	if ((count _bdCfg) <= 0) exitwith {}; //if none, exit
	
	for "_i" from 0 to ((count _bdCfg) - 1) step 3 do{ //gather doop positions from the config data:
		if (_i >= (count _bdCfg)) exitwith {};
		_sel = _bdCfg select _i;
		_position = getText (_sel >> "position");
		//hint format["%1",_position];sleep 2;
		_doorPositions set [(count _doorPositions),(_building modelToWorld  (_building selectionPosition _position))];
	};
	sleep 0.2;
	_building setVariable ["DoorPositions", _doorPositions, false];
	sleep 0.3;
};

while{(_unit in _inUnits)}do{ //run as long as there's AI's inside (count _inUnits)>0
	_doors = [];
	_doorPositions = (_building getVariable "DoorPositions");
	waitUntil{_doorPositions = (_building getVariable "DoorPositions");(!isNil("_doorPositions"));};
	_avoidDoors = (_building getVariable "AvoidDoors"); //door aims which player MAY HAVE caused, are stored in this
	if(isNil("_avoidDoors"))then{_avoidDoors = [];};
	for "_i" from 1 to (count _doorPositions) step 1 do { //save the anim numbers and phase values in data array +add positions along
		if(_building animationPhase "door_"  + str _i + "_rot" == 1)then{
			_doors set[(count _doors),[_i,1,(_doorPositions select (_i - 1))]];
		}else{
			_doors set[(count _doors),[_i,0,(_doorPositions select (_i - 1))]];
		};
	};
	sleep 0.2;
	_bDoors = (_building getVariable "Doors"); 
//hint format["%1",_bDoors];
	if(isNil("_bDoors"))then{ //if animation phase values has not been saved already,
		_building setVariable ["Doors", _doors, false]; //save them in building so we can compare them on next loop
	}else{ //now we have the phase values and we can observe if they change:

		{ //go thru all animations stored in building
			_n = _x select 0; //door order num
			_v = _x select 1; //door anim value
			if(((_doors select (_n - 1))select 1) != 0)then{ //if current value is different than stored one _v
				_players = [];
				if(isMultiplayer)then{_players = playableUnits;}else{_players = [player];}; //get players
					_goodToClose = true;
					{ //check if player is <3m away from the opened door and if so, skip the door closing
						if((_x distance ((_doors select (_n - 1)) select 2))<3)then{_goodToClose = false;};
					}forEach _players;
					
					//also skip if current unit is over 3m far from current door
					if((_unit distance ((_doors select (_n - 1)) select 2))>3)then{_goodToClose = false;};
					
					if(_goodToClose)then{ //if door is still in avoid-array, but good to go, remove it from the array
						if(_n in _avoidDoors)then{
							_avoidDoors = _avoidDoors - [_n];
							_building setVariable ["AvoidDoors", _avoidDoors, false];
						};
					};
					
					if(_goodToClose)then{
						if(!(_n in _avoidDoors))then{ //if anim is not possibly player-caused -> invert animation:
							[_unit,_building,_doors,_n,_v] spawn {
								private ["_unit","_building","_doors","_n","_v"];
								_unit = _this select 0;
								_building = _this select 1;
								_doors = _this select 2;
								_n = _this select 3;
								_v = _this select 4;
								waitUntil{((_unit distance ((_doors select (_n - 1)) select 2))>2)}; //wait till AI has passed door
								_building animate ["door_" + str _n + "_rot",0]; //_v
							};
						};
					}else{ //if player was near:
						_avoidDoors set[(count _avoidDoors),_n]; //store anim number and value
						_building setVariable ["AvoidDoors", _avoidDoors, false];
						[_building, _n, _v, _players] spawn { //wait until player goes 100 further and invert the animation then:
							private ["_building","_n","_v","_players","_stillNear"];
							_building = _this select 0;
							_n = _this select 1;
							_v = _this select 2;
							_players = _this select 3;
							_stillNear = true;
							while{_stillNear}do{
								_stillNear = false;
								{
									if((_x distance _building)<100)then{_stillNear = true;};
								}forEach _players;
								sleep 2;
							};
							_building animate ["door_" + str _n + "_rot",_v];
						};
					};
			};
		}forEach _bDoors;

	};

	_inUnits = (_building getVariable "InUnits"); //get the updated amount of units from building
	_unitTarget = _unit getVariable "TargetBuilding";
	if((!alive _unit)||(isNil("_unitTarget")))then{ //if current unit is dead or away, remove it from array
		_inUnits = _inUnits - [_unit]; //save new amount
		_building setVariable ["InUnits", _inUnits, false];
		//hint format["no target building, iu: %1",(count _inUnits)];
	};
	sleep 1;
};

//reset stuff when there's no AI units inside this building anymore:
if((count _inUnits)==0)then{
	_building setVariable ["RunningAlready", nil, false];
	_building setVariable ["AvoidDoors", nil, false];
	_building setVariable ["Doors", nil, false];
	_building setVariable ["InUnits", nil, false];
};