/*
				***		ARMA3Alpha REINFORCEMENT CHOPPER SCRIPT v2.0 - by SPUn / lostvar	***
	
				Spawns chopper which transports infantry group to position and leaves after that
				
		Calling the script:
		
			default: 		nul = [this] execVM "addons\AI_Spawn\reinforcementChopper.sqf";
			custom: 		nul = [spot,exact,side,type,captive,patrol,target,direction,distance,precise,
								cycle,groupSize,skills,smoke,group,custom init,ID,MP] execVM "addons\AI_Spawn\reinforcementChopper.sqf";
								
	Parameters:
	
	0)spot 	= 	landing spot 	(name of marker or object or unit, or position array) 									DEFAULT: this
	1)exact 	= 	true or false 	(true = tries landing exactly on *spot, false = finds place where it fits) 				DEFAULT: true
	2)side 	= 	1 or 2 or 3		(1 = west, 2 = east, 3 = independent)													DEFAULT: 2
	3)type 	= 	number 			(Depends on side)																		DEFAULT: 1
				WEST: 1 = B_Heli_Light_01_armed_F, 2 = B_Heli_Light_01_F, 3 = B_Heli_Transport_01_F
				EAST: 1 = O_Heli_Attack_02_F, 2 = O_Heli_Attack_02_black_F, 3 = O_Heli_Light_02_F, 4 = O_Heli_Light_02_unarmed_F
				INDEPENDENT: 1 = I_Heli_Transport_02_F
	4)captive = 	true/false 		(if true, enemies wont notice them before chopper has landed) 							DEFAULT: false
	5)patrol 	= 	true/false 		(if false, units wont patrol in any way <- handy if you set (group player) as *group) 	DEFAULT: true
	6)target 	= 	patrol target 	(patrolling target for infantry group, options:											DEFAULT: player
								unit 	= 	units name, ex: enemyunit1
								marker 	= 	markers' name, ex: "marker01" (remember quotes with markers!)
								marker array = array of markers in desired order, ex: ["marker01","marker02","marker03"]
								group	= 	groups name, ex: (group enemy1)	OR BlueGroup17
								group array, ex: [(group player), (group blue2)]
								["PATROL",center position,radius] = uses patrol-vD.sqf, ex: ["PATROL",(getPos player),150]
	7)direction 	= 	"random" or 0-360 (direction where chopper comes from, use quotes with random!) 									DEFAULT: "random"
	8)distance 	= 	number (from how far KA60 comes from) 																				DEFAULT: 1500
	9)precise 	= 	true or false (true = heli will land even in middle of war, false = heli might have air fights etc before landing) 	DEFAULT: true
	10)cycle 		= 	true or false (if true and target is array of markers, unit will cycle these markers) 								DEFAULT: false
	11)groupSize 	= 	1-8 (infantry groups' size) 																						DEFAULT: 8
	12)skills 		= 	"default" 	(default AI skills) 																					DEFAULT: "default"
				or	number	=	0-1.0 = this value will be set to all AI skills, ex: 0.8
				or	array	=	all AI skills invidiually in array, values 0-1.0, order:
						[aimingAccuracy, aimingShake, aimingSpeed, spotDistance, spotTime, courage, commanding, general, endurance, reloadSpeed] 
						ex: 	[0.75,0.5,0.6,0.85,0.9,1,1,0.75,1,1] 					
	13)smoke		=	[LZ smoke, cover smokes, flare, chemlights] (if chopper uses these on landing spot)									DEFAULT: [false,false,false,false]
	14)group 		= 	group name OR nil (if you want units in existing group, set it here. if this is left empty, new group is made) 		DEFAULT: nil
	15)custom init = 	"init commands" (if you want something in init field of units, put it here) 										DEFAULT: nil
					NOTE: Keep it inside quotes, and if you need quotes in init commands, you MUST use ' or "" instead of ",
						 ex: "hint 'this is hint';"
	16)ID 			= 	number (if you want to delete units this script creates, you'll need ID number for them)							DEFAULT: nil
	17)MP			= 	true/false	true = 'landing spot' will automatically be one of alive non-captive players								DEFAULT: false
	
	EXAMPLE: 	nul = [player,false,2,3,false,true,player,"random",1000,true,false,8,0.75,[false,true,false,true],nil,nil,33,false] execVM "addons\AI_Spawn\reinforcementChopper.sqf";
*/
if (!isServer)exitWith{};
private ["_BLUmen3","_mp","_smoke","_INDchoppers","_BLUchoppers","_OPFchoppers","_OPFarrays","_BLUarrays","_INDgrp","_INDhq","_INDmen","_OPFmen2","_BLUmen2","_captive","_patrol","_heliT","_chopperTypes","_chopperType","_setInit2","_setInit","_c0","_customInit","_tPos","_exactPos","_skls","_skills","_grpSize","_cycle","_precise","_man2","_direction","_distance","_targetM","_i2","_heliPad","_targetPos","_side","_targetMarker","_BLUmen","_OPFmen","_men","_hq","_grp1","_grp2","_man1","_man","_dir","_range","_pos","_heli","_vehSpots","_i","_wp1"];

//Extra options:
_doorHandling = true;
//

//Check parameters:
_tPos = if (count _this > 0) then {_this select 0};
_exactPos = if (count _this > 1) then {_this select 1; }else{true;};
_side = if (count _this > 2) then {_this select 2; }else{2;};
_chopperType = if (count _this > 3) then {_this select 3; }else{3;};
_captive = if (count _this > 4) then {_this select 4; }else{false;};
_patrol = if (count _this > 5) then {_this select 5; }else{true;};
_targetMarker = if (count _this > 6) then {_this select 6; }else{player;};
_direction = if (count _this > 7) then {_this select 7; }else{"random";};
_distance = if (count _this > 8) then {_this select 8; }else{1500;};
_precise = if (count _this > 9) then {_this select 9; }else{true;};
_cycle = if (count _this > 10) then {_this select 10; }else{false;};
_grpSize = if (count _this > 11) then {_this select 11; }else{8;};
_skills = if (count _this > 12) then {_this select 12; }else{"default";};
_smoke = if (count _this > 13) then {_this select 13; }else{[false,false,false,false];};
_grp2 = if (count _this > 14) then {_this select 14; }else{nil;};
_customInit = if (count _this > 15) then {_this select 15; }else{nil;};
_grpId = if (count _this > 16) then { _this select 16;} else {nil};
_mp = if (count _this > 17) then { _this select 17;} else {false};

if(_mp)then{if(isNil("LV_GetPlayers"))then{LV_GetPlayers = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_getPlayers.sqf";};};

if(_mp)then{
	_tPos = call LV_GetPlayers;
	_targetPos = getPos(_tPos call BIS_fnc_selectRandom);
}else{
	//Check if spot is marker, object, or position array:
	if(_tPos in allMapMarkers)then{
		_targetPos = getMarkerPos _tPos;
	}else{
		if (typeName _tPos == "ARRAY") then{
			_targetPos = _tPos;
		}else{
			_targetPos = getPos _tPos;
		};
	};
};

//LZ smoke
if((_smoke select 0))then{
	[_targetPos,_distance] spawn {
		private["_targetPos","_a","_timesLimit","_distance"];
		_targetPos = _this select 0;
		_distance = _this select 1;
		_a = 0;
		_timesLimit = ceil(_distance / 1000);
		while{_a < _timesLimit}do{
			_smoke1 = "SmokeShellGreen" createVehicle _targetPos;
			sleep 50;
			_a = _a + 1;
		};
	};
};

//Prepare functions:
if(isNil("LV_ACskills"))then{LV_ACskills = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_ACskills.sqf";};
if(isNil("LV_RandomSpot"))then{LV_RandomSpot = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_randomSpot.sqf";};
if(isNil("LV_vehicleInit"))then{LV_vehicleInit = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_vehicleInit.sqf";};

//Unit arrays:
_BLUmen = ["B_Soldier_A_F","B_soldier_AR_F","B_medic_F","B_engineer_F","B_soldier_exp_F","B_Soldier_GL_F","B_soldier_M_F","B_soldier_AA_F","B_soldier_AT_F","B_officer_F","B_soldier_repair_F","B_Soldier_F","B_soldier_LAT_F","B_Soldier_lite_F","B_Soldier_SL_F","B_Soldier_TL_F","B_soldier_AAR_F","B_soldier_AAA_F","B_soldier_AAT_F"];
_BLUmen2 = ["B_recon_exp_F","B_recon_JTAC_F","B_recon_M_F","B_recon_medic_F","B_recon_F","B_recon_LAT_F","B_recon_TL_F","B_soldier_AAR_F","B_soldier_AAA_F","B_soldier_AAT_F"];
_BLUmen3 = ["B_G_Soldier_A_F","B_G_soldier_AR_F","B_G_medic_F","B_G_engineer_F","B_G_soldier_exp_F","B_G_Soldier_GL_F","B_G_soldier_M_F","B_G_officer_F","B_G_Soldier_F","B_G_soldier_LAT_F","B_G_Soldier_lite_F","B_G_Soldier_SL_F","B_G_Soldier_TL_F"];
_BLUarrays = [_BLUmen,_BLUmen2,_BLUmen3];

_OPFmen = ["O_Soldier_A_F","O_soldier_AR_F","O_medic_F","O_engineer_F","O_soldier_exp_F","O_Soldier_GL_F","O_soldier_M_F","O_soldier_AA_F","O_soldier_AT_F","O_officer_F","O_soldier_repair_F","O_Soldier_F","O_soldier_LAT_F","O_Soldier_lite_F","O_Soldier_SL_F","O_Soldier_TL_F","O_soldier_AAR_F","O_soldier_AAA_F","O_soldier_AAT_F"];
_OPFmen2 = ["O_recon_exp_F","O_recon_JTAC_F","O_recon_M_F","O_recon_medic_F","O_recon_F","O_recon_LAT_F","O_recon_TL_F","O_soldier_AAR_F","O_soldier_AAA_F","O_soldier_AAT_F"];
_OPFarrays = [_OPFmen,_OPFmen2];

_INDmen = ["I_Soldier_A_F","I_soldier_AR_F","I_medic_F","I_engineer_F","I_soldier_exp_F","I_Soldier_GL_F","I_soldier_M_F","I_soldier_AA_F","I_soldier_AT_F","I_officer_F","I_soldier_repair_F","I_Soldier_F","I_soldier_LAT_F","I_Soldier_lite_F","I_Soldier_SL_F","I_Soldier_TL_F","I_soldier_AAR_F","I_soldier_AAA_F","I_soldier_AAT_F"];

_BLUchoppers = ["B_Heli_Light_01_armed_F","B_Heli_Light_01_F","B_Heli_Transport_01_F"];
_OPFchoppers = ["O_Heli_Attack_02_F","O_Heli_Attack_02_black_F","O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F"];
_INDchoppers = ["I_Heli_Transport_02_F"];

_chopperTypes = [];

//Side related group creation:
switch(_side)do{
	case 1:{
		_hq = createCenter west;
		_grp1 = createGroup west;
		if(isNil("_grp2"))then{_grp2 = createGroup west;}else{_grp2 = _grp2;};
		_men = (_BLUarrays call BIS_fnc_selectRandom);
		_chopperTypes = _BLUchoppers;
	};
	case 2:{
		_hq = createCenter east;
		_grp1 = createGroup east;
		if(isNil("_grp2"))then{_grp2 = createGroup east;}else{_grp2 = _grp2;};
		_men = (_OPFarrays call BIS_fnc_selectRandom);
		_chopperTypes = _OPFchoppers;
	};
	case 3:{
		_hq = createCenter resistance;
		_grp1 = createGroup resistance;
		if(isNil("_grp2"))then{_grp2 = createGroup resistance;}else{_grp2 = _grp2;};
		_men = _INDmen;
		_chopperTypes = _INDchoppers;
	};
	case 4:{
		_center = createCenter civilian;
		_grp1 = createGroup civilian;
		if(isNil("_grp2"))then{_grp2 = createGroup civilian;}else{_grp2 = _grp2;};
		_men = _INDmen;
		_chopperTypes = _INDchoppers;
	};		

};

//If *exact* is false, find landing spot which is not close another ones:
if(!_exactPos)then{
	if(isNil("REKA60padArray"))then{REKA60padArray = [];};
	_finding = 1;
	_ra = 20;
	while{_finding > 0}do{
		
		_tPos = [];
		while{count _tPos < 1}do{
			_spot = [_targetPos, _ra] call LV_RandomSpot;
			_tPos = _spot isflatempty [12,0,0.3,4,0,false,objnull];
			_ra = _ra + 10; //try and get them to land further out sooner
		};
		
		sleep 0.001;
		_targetPos = _tPos;
		_e1 = 0;
		_finding = 0;
		
		while{_e1<(count REKA60padArray)}do{
			if(((REKA60padArray select _e1) distance _targetPos)<15)then{_finding = 1;};
			_e1 = _e1 + 1;
		};
	};
	REKA60padArray set [(count REKA60padArray), _targetPos];
	
	//LZ smoke --DEBUG Testing of Heli Code
		
			[_targetPos,_distance] spawn {
				private["_targetPos","_a","_timesLimit","_distance"];
				_targetPos = _this select 0;
				_distance = _this select 1;
				_a = 0;
				_timesLimit = ceil(_distance / 1000);
				while{_a < _timesLimit}do{
					_smoke1 = "SmokeShellGreen" createVehicle _targetPos;
					sleep 50;
					_a = _a + 1;
				};
			};
		
};

_heliT = _chopperTypes select (_chopperType - 1);
_heliPad = createVehicle ["Land_helipadEmpty_F", _targetPos, [], 0, "NONE"]; 

if(typeName _direction == "STRING")then{_dir = random 360;}else{_dir = _direction;};
_range = _distance;
_pos = [(_targetPos select 0) + (sin _dir) * _range, (_targetPos select 1) + (cos _dir) * _range, 0];
_heli = createVehicle [_heliT, _pos, [], 0, "FLY"];

if(_grpSize > (getNumber (configFile >> "CfgVehicles" >> _heliT >> "transportSoldier")))then{
	_vehSpots = getNumber (configFile >> "CfgVehicles" >> _heliT >> "transportSoldier");
}else{
	_vehSpots = _grpSize;
};

_man1 = _men select (floor(random(count _men)));
//_man = _grp1 createUnit [_man1, _pos, [], 0, "NONE"];
_man = [_grp1, _pos] call createRandomSoldier;
_man moveInDriver _heli;
_man setUnitRank "SERGEANT";
if(_precise)then{_man setBehaviour "CARELESS";};

[_man,_heli,_targetPos] spawn {
	_man = _this select 0;
	_heli = _this select 1;
	_targetPos = _this select 2;
	waitUntil {sleep 1; !isNil "_man" && !isNil "_heli"};
	waitUntil {sleep 1; !alive _man || !canMove _heli || isNil "_man" || isNil "_heli"};
	if (true) exitWith {
		if (!isNil "_targetPos" && !isNil "REKA60padArray") then {
			if ((_heli distance _targetPos) > 50)then{REKA60padArray = REKA60padArray - [_targetPos];};
		};
		if(_heli distance _targetPos > 200)then{
			sleep 15;
			deleteVehicle _man;
			sleep 15;
			deleteVehicle _heli;
		};
	};
};

_i = 1; 
for "_i" from 1 to _vehSpots do {
	_man1 = _men select (floor(random(count _men)));
	_man2 = [_grp2, _pos] call createRandomSoldier;
	_man2 moveInCargo _heli;
};
if((_vehSpots == 0)&&(_grpSize > 0))then{
	_man1 = _men select (floor(random(count _men)));
	_man2 = [_grp2, _pos] call createRandomSoldier;
	_man2 moveInTurret [_heli, [0]];
};

if(!isNil("_grpId"))then{
	call compile format ["LVgroup%1 = _grp2",_grpId];
	diag_log format ["Reinforcements grpID %1", _grpID];
};

if(_captive)then{
	{ _x setCaptive true; }forEach units _grp1;
	{ _x setCaptive true; }forEach units _grp2;
};
/*
_heli doMove _targetPos;
while { _heli distance _targetPos > 260 } do { sleep 4; };
doStop _heli;
_heli land "LAND"; //you can also try "GET OUT" (then it wont land, only hovers)
while { (getPos _heli) select 2 > 3 } do { sleep 2; };
*/
//Trying to get helo to land
	_waypoint = _grp1 addWaypoint [_targetPos,0,1];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointCompletionRadius 50;
	_waypoint setWaypointCombatMode "WHITE";
	_waypoint setWaypointBehaviour "AWARE";
	_waypoint setWaypointFormation "STAG COLUMN";
	
	_waypoint = _grp1 addWaypoint [_targetPos,0,2];
	_waypoint = setWaypointType "TR UNLOAD";
	
	
	

if((_smoke select 1))then{//Cover smoke
	[_targetPos,_heli] spawn {
		private["_targetPos","_a","_dir","_heli"];
		_targetPos = _this select 0;
		_heli = _this select 1;
		_dir = 0;
		_a = 0;
		while{_a < 16}do{
			_sPos = [((getPos _heli) select 0) + (sin _dir) * 12, ((getPos _heli) select 1) + (cos _dir) * 12, ((getPos _heli) select 2)];
			_smoke1 = "SmokeShell" createVehicle _sPos;
			_a = _a + 1;
			_dir = _dir + (360 / 16);
		};
	};
};
if((_smoke select 2))then{//Flare
	[_heli] spawn {
		private["_heli"];
		_heli = _this select 0;
		_flare = "F_40mm_Red" createVehicle [(getPos _heli) select 0,(getPos _heli) select 1,0];
	};
};
if((_smoke select 3))then{//Chemlights
		[_targetPos,_heli] spawn {
		private["_targetPos","_a","_dir","_heli"];
		_targetPos = _this select 0;
		_heli = _this select 1;
		_dir = 0;
		_a = 0;
		while{_a < 8}do{
			_sPos = [((getPos _heli) select 0) + (sin _dir) * 12, ((getPos _heli) select 1) + (cos _dir) * 12, ((getPos _heli) select 2)];
			_smoke1 = "Chemlight_red" createVehicle _sPos;
			_a = _a + 1;
			_dir = _dir + (360 / 8);
		};
	};
};

while { (getPos _heli) select 2 > 1 } do { sleep 1; };

if(_captive)then{
	{ _x setCaptive false; }forEach units _grp1;
	{ _x setCaptive false; }forEach units _grp2;
};

_grp2 leaveVehicle _heli;
{
	unassignVehicle _x;
	doGetOut _x; 
	_x setBehaviour "AWARE";
} forEach units _grp2;
_grp2 setCombatMode "RED";
while { (count (crew _heli)) > 1 } do { sleep 2;  };
_heli doMove _pos;



if(_patrol)then{
	if(typeName _targetMarker == "ARRAY")then{ //TARGET is array
		if((!((_targetMarker select 0) in allMapMarkers))&&(!((_targetMarker select 0) in allGroups)))then{
			if((typeName (_targetMarker select 0)) == "STRING")then{
				if((_targetMarker select 0) == "PATROL")then{ ////USE patrol-vD.sqf
					{
						_cPosition = _targetMarker select 1;
						_cRadius = _targetMarker select 2;
						nul = [_x,_cPosition,_cRadius,_doorHandling] execVM "addons\AI_Spawn\patrol-vD.sqf";
					}forEach units _grp2;
				};
			};
		}else{ //TARGET is array of Markers or Groups
			{ 
				_x setVariable ["target0",_targetMarker,false];
				_x setVariable ["mDis0", 1000, false];
				if(_cycle)then{
					nul = [_x,true] execVM "addons\AI_Spawn\LV_functions\LV_fnc_follow.sqf";
				}else{
					nul = [_x,false] execVM "addons\AI_Spawn\LV_functions\LV_fnc_follow.sqf";
				};
				sleep 2;
			}forEach units _grp2;
		};
	}else{
		if(_targetMarker in allMapMarkers)then{ /////TARGET is single Marker
			{ _x doMove getMarkerPos _targetMarker; } forEach units _grp2;
		}else{
				{ ////TARGET is single Unit/Object
					_x setVariable ["target0",_targetMarker,false];
					_x setVariable ["mDis0", 1000, false];
					nul = [_x] execVM "addons\AI_Spawn\LV_functions\LV_fnc_follow.sqf";
				}forEach units _grp2;
		};
	};
}else{
	//If patrol is set to false, units will idle. Additionally you can set custom actions here:
	
};

while { (_heli distance _pos > 200) } do { sleep 4; };

if((!_exactPos)&&((_heli distance _targetPos) > 50))then{REKA60padArray = REKA60padArray - [_targetPos];};

if((_heli distance _pos < 200))exitWith{
	deleteVehicle _man;
	deleteVehicle _heli;
	waituntil {sleep 1;(count units _grp1)==0};
    	deletegroup _grp1; 
};

