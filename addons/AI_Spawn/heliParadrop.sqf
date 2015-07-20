/*
				***		ARMA3Alpha HELI PARADROP v1.0 - by SPUn / lostvar	***
	
					Spawns chopper which delivers paradrop group to scene
				
		Calling the script:
		
			default: 		nul = [this] execVM "addons\AI_Spawn\heliParadrop.sqf";
			
			custom: 		nul = [spot, side, allowDamage, captive, distance, direction, flyby, fly height, jump distance,
								group size, jump delay, open height, smokes, flares, chems, patrol, target, cycle, skills,
								group, custom init, ID, MP] execVM "addons\AI_Spawn\heliParadrop.sqf";
								
	Parameters:
	
spot 	= 	drop spot 		(name of marker or object or unit, or position array) 									DEFAULT: --
side 	= 	1 or 2 or 3		(1 = west, 2 = east, 3 = independent)													DEFAULT: 2
allowDamage = 	true/false	(allow or disallow damage for chopper)													DEFAULT: true
captive 	= 	true/false 	(if true, enemies wont notice chopper) 													DEFAULT: false
distance 	= 	number 		(from how far chopper comes from) 														DEFAULT: 1500
direction 	= 	"random" or 0-360 (direction where chopper comes from, use quotes with random!) 					DEFAULT: "random"
flyby	=	true/false		(true = chopper just flies thru target, false = stays still while dropping units)		DEFAULT: true
fly height	= number 		(how high chopper flies)																DEFAULT: 200
jump distance =	number 		(how many meters before target location units starts jumping out of heli)				DEFAULT: 150
group size	= number 		(how many units is in para drop group)													DEFAULT: 8
jump delay	= number 		(how many seconds is the delay between jumps)											DEFAULT: 0.5
open height = number		(in which height units opens their parachutes)											DEFAULT: 50
smokes	=	true/false		(will units throw cover smokes (on 10m height))											DEFAULT: false
flares	=	true/false		(will units throw flares (on 30m height))												DEFAULT: false	
chems	=	true/false		(will units throw chemlights (on 30m height))											DEFAULT: false
patrol 	= 	true/false 		(if false, units wont patrol in any way <- handy if you set (group player) as *group) 	DEFAULT: true
target 	= 	patrol target 	(patrolling target for infantry group, options:											DEFAULT: player
							unit 	= 	units name, ex: enemyunit1
							marker 	= 	markers' name, ex: "marker01" (remember quotes with markers!)
							marker array = array of markers in desired order, ex: ["marker01","marker02","marker03"]
							group	= 	groups name, ex: (group enemy1)	OR BlueGroup17
							group array, ex: [(group player), (group blue2)]
							["PATROL",center position,radius] = uses patrol-vD.sqf, ex: ["PATROL",(getPos player),150]										
cycle 		= 	true or false (if true and target is array of markers, unit will cycle these markers) 				DEFAULT: false
skills 		= 	"default" 	(default AI skills) 																	DEFAULT: "default"
				or	number	=	0-1.0 = this value will be set to all AI skills, ex: 0.8
				or	array	=	all AI skills invidiually in array, values 0-1.0, order:
						[aimingAccuracy, aimingShake, aimingSpeed, spotDistance, spotTime, courage, commanding, general, endurance, reloadSpeed] 
						ex: 	[0.75,0.5,0.6,0.85,0.9,1,1,0.75,1,1] 
group 		= 	group name OR nil (if you want units in existing group, set it here. if this is left empty, new group is made) 	DEFAULT: nil
custom init = 	"init commands" (if you want something in init field of units, put it here) 									DEFAULT: nil
				NOTE: Keep it inside quotes, and if you need quotes in init commands, you MUST use ' or "" instead of ",
					ex: "hint 'this is hint';"
ID 			= 	number (if you want to delete units this script creates, you'll need ID number for them)						DEFAULT: nil
MP			= 	true/false	true = 'drop spot' will automatically be one of alive non-captive players							DEFAULT: false
Precision	=	Range from landing spot that heli will target for drop.  Use to have troops come from further away to patrol	DEFAULT: 100
						 
EXAMPLE: 	nul = [player, 2, false, true, 1000, "random", true, 500, 200, 6, 1, 50, true, false, true, true, player, false, 0.75, nil, nil, 1,false,100] execVM "addons\AI_Spawn\heliParadrop.sqf";
*/
if (!isServer)exitWith{};
private ["_mp","_grp","_heliType","_men","_grp2","_center","_man1","_man2","_landingSpot","_side","_flyHeight","_openHeight","_jumpDelay","_jumperAmount","_heliDistance","_heliDirection","_flyBy","_allowDamage","_BLUmen","_OPFmen","_INDmen","_BLUchopper","_OPFchopper","_INDchopper","_landingSpotPos","_spos","_heli","_crew","_dir","_flySpot","_jumpDistanceFromTarget","_captive","_smokes","_flares","_chems","_skls","_cPosition","_cRadius","_patrol","_target","_cycle","_skills","_customInit","_grpId","_wp0","_wp1","_doorHandling","_jumpPOS","_precision"];

//Extra settings:
_doorHandling = true;
//

_landingSpot = 		if (count _this > 0) then {_this select 0};
_side = 			if (count _this > 1) then {_this select 1}else{2};
_allowDamage = 		if (count _this > 2) then {_this select 2}else{true};
_captive = 			if (count _this > 3) then {_this select 3}else{false};
_heliDistance = 	if (count _this > 4) then {_this select 4}else{1500};
_heliDirection = 	if (count _this > 5) then {_this select 5}else{"random"};
_flyBy = 			if (count _this > 6) then {_this select 6}else{true};
_flyHeight = 		if (count _this > 7) then {_this select 7}else{200};
_jumpDistanceFromTarget = if (count _this > 8) then {_this select 8}else{150};
_jumperAmount = 	if (count _this > 9) then {_this select 9}else{8};
_jumpDelay =		if (count _this > 10) then {_this select 10}else{0.5};
_openHeight = 		if (count _this > 11) then {_this select 11}else{50};
_smokes = 			if (count _this > 12) then {_this select 12}else{false};
_flares = 			if (count _this > 13) then {_this select 13}else{false};
_chems = 			if (count _this > 14) then {_this select 14}else{false};
_patrol = 			if (count _this > 15) then {_this select 15; }else{true;};
_target = 			if (count _this > 16) then {_this select 16; }else{player;};
_cycle = 			if (count _this > 17) then {_this select 17; }else{false;};
_skills = 			if (count _this > 18) then {_this select 18; }else{"default";};
_grp2 = 			if (count _this > 19) then {_this select 19; }else{nil;};
_customInit = 		if (count _this > 20) then {_this select 20; }else{nil;};
_grpId = 			if (count _this > 21) then { _this select 21;} else {nil};
_mp = 				if (count _this > 22) then { _this select 22;} else {false};
_precision =		if (count _this > 23) then { _this select 23;} else {100};

//Prepare functions:
if(isNil("LV_ACskills"))then{LV_ACskills = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_ACskills.sqf";};
if(isNil("LV_vehicleInit"))then{LV_vehicleInit = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_vehicleInit.sqf";};
if(_mp)then{if(isNil("LV_GetPlayers"))then{LV_GetPlayers = compile preprocessFile "addons\AI_Spawn\LV_functions\LV_fnc_getPlayers.sqf";};};
if(isNil("createParatrooper"))then{createParatrooper = compile preprocessFile "addons\AI_Spawn\LV_functions\createParatrooper.sqf";};

//Classnames:
_BLUmen = ["B_Soldier_A_F","B_soldier_AR_F","B_medic_F","B_engineer_F","B_soldier_exp_F","B_Soldier_GL_F","B_soldier_M_F","B_soldier_AA_F","B_soldier_AT_F","B_officer_F","B_soldier_repair_F","B_Soldier_F","B_soldier_LAT_F","B_Soldier_lite_F","B_Soldier_SL_F","B_Soldier_TL_F","B_recon_exp_F","B_recon_JTAC_F","B_recon_M_F","B_recon_medic_F","B_recon_F","B_recon_LAT_F","B_recon_TL_F","B_soldier_AAR_F","B_soldier_AAA_F","B_soldier_AAT_F"];
_OPFmen = ["O_Soldier_A_F","O_soldier_AR_F","O_medic_F","O_engineer_F","O_soldier_exp_F","O_Soldier_GL_F","O_soldier_M_F","O_soldier_AA_F","O_soldier_AT_F","O_officer_F","O_soldier_repair_F","O_Soldier_F","O_soldier_LAT_F","O_Soldier_lite_F","O_Soldier_SL_F","O_Soldier_TL_F","O_recon_exp_F","O_recon_JTAC_F","O_recon_M_F","O_recon_medic_F","O_recon_F","O_recon_LAT_F","O_recon_TL_F","O_soldier_AAR_F","O_soldier_AAA_F","O_soldier_AAT_F"];
_INDmen = ["I_Soldier_A_F","I_soldier_AR_F","I_medic_F","I_engineer_F","I_soldier_exp_F","I_Soldier_GL_F","I_soldier_M_F","I_soldier_AA_F","I_soldier_AT_F","I_officer_F","I_soldier_repair_F","I_Soldier_F","I_soldier_LAT_F","I_Soldier_lite_F","I_Soldier_SL_F","I_Soldier_TL_F","I_soldier_AAR_F","I_soldier_AAA_F","I_soldier_AAT_F"];
_BLUchopper = "B_Heli_Transport_01_F";
_OPFchopper = "O_Heli_Light_02_unarmed_F";
_INDchopper = "I_Heli_Transport_02_F";

//Side related group creation:
switch(_side)do{
	case 1:{
		_center = createCenter west;
		_grp = createGroup west;
		if(isNil("_grp2"))then{_grp2 = createGroup west;}else{_grp2 = _grp2;};
		_men = _BLUmen;
		_heliType = _BLUchopper;
	};
	case 2:{
		_center = createCenter east;
		_grp = createGroup east;
		if(isNil("_grp2"))then{_grp2 = createGroup east;}else{_grp2 = _grp2;};
		_men = _OPFmen;
		_heliType = _OPFchopper;
	};
	case 3:{
		_center = createCenter resistance;
		_grp = createGroup resistance;
		if(isNil("_grp2"))then{_grp2 = createGroup resistance;}else{_grp2 = _grp2;};
		_men = _INDmen;
		_heliType = _INDchopper;
	};
	case 4:{
		_center = createCenter civilian;
		_grp = createGroup civilian;
		if(isNil("_grp2"))then{_grp2 = createGroup civilian;}else{_grp2 = _grp2;};
		_men = _INDmen;
		_heliType = _INDchopper;
	};	
};
if(typeName _heliDirection == "STRING")then{_heliDirection = random 360;};

if(_mp)then{
	_landingSpot = call LV_GetPlayers;
	_landingSpotPos = getPos(_landingSpot call BIS_fnc_selectRandom);
	_landingSpot = _landingSpotPos;
}else{
	//Check if target is marker/object/position
	if(_landingSpot in allMapMarkers)then{
		_landingSpotPos = getMarkerPos _landingSpot;
		_landingSpotPos = [(_landingSpotPos select 0) + (sin _heliDirection) * _precision, (_landingSpotPos select 1) + (cos _heliDirection) * _precision, 0];  //Drops troops preset radius from marker
	}else{
		if (typeName _landingSpot == "ARRAY") then{
			_landingSpotPos = _landingSpot;
		}else{
			_landingSpotPos = getPos _landingSpot;
			_landingSpotPos = [(_landingSpotPos select 0)+ floor(random 250), (_landingSpotPos select 1)+ floor(random 250), 0]; //Randomization of drop point
		};
	};
};

//Spawn chopper

_spos = [(_landingSpotPos select 0) + (sin _heliDirection) * _heliDistance, (_landingSpotPos select 1) + (cos _heliDirection) * _heliDistance, _flyHeight];
_heli = createVehicle [_heliType, _spos, [], 0, "FLY"];
_heli allowDamage _allowDamage;
_heli setVariable ["R3F_LOG_disabled", true, true];
[_heli] call vehicleSetup;

_crew = [_grp, _spos] call createRandomSoldierC;
_crew moveInDriver _heli;


if(_captive)then{
	_heli setCaptive true;
	{ _x setCaptive true; } forEach units _grp;
};
//NOTE! This next line should make sure AI does fly where it's set to fly, BUT in recent stable release
//AI sometimes acts weirdly while CARELESS, they might skip waypoints or domoves. 
//_grp setBehaviour "CARELESS";

//Count angle between chopper and target, and end spot for chopper
_dir = ((_landingSpotPos select 0) - (_spos select 0)) atan2 ((_landingSpotPos select 1) - (_spos select 1));
_flySpot = [(_landingSpotPos select 0) + (sin _dir) * _heliDistance, (_landingSpotPos select 1) + (cos _dir) * _heliDistance, _flyHeight];

//Heli to go
if(_flyBy)then{
	_wp0 = _grp addWaypoint [_landingSpotPos, 0, 1];
	[_grp,0] setWaypointBehaviour "CARELESS";
	[_grp,0] setWaypointCompletionRadius 60;
	_wp1 = _grp addWaypoint [_flySpot, 0, 2];
	[_grp,1] setWaypointBehaviour "CARELESS";
	[_grp,1] setWaypointCompletionRadius 60;
}else{
	_wp0 = _grp addWaypoint [_landingSpotPos, 0, 1];
	[_grp,0] setWaypointBehaviour "CARELESS";
	[_grp,0] setWaypointCompletionRadius 60;
};
_heli flyInHeight _flyHeight;

//Make heli & crew dissapear if something goes wrong or if heli is at its end spot
[_heli,_grp,_flySpot,_landingSpotPos,_heliDistance] spawn {
	private ["_heli","_grp","_flySpot","_landingSpotPos","_heliDistance"];
	_heli = _this select 0;
	_grp = _this select 1;
	_flySpot = _this select 2;
	_landingSpotPos = _this select 3;
	_heliDistance = _this select 4;
	while{([_heli, _flySpot] call BIS_fnc_distance2D)>200}do{
		if(!alive _heli || !canMove _heli)exitWith{};
		sleep 5;
	};
	waitUntil{([_heli, _landingSpotPos] call BIS_fnc_distance2D)>(_heliDistance * .5)};
	{ deleteVehicle _x; } forEach units _grp;
	deleteVehicle _heli;
};

//Wait till it's close enough
waitUntil{([_heli, _landingSpotPos] call BIS_fnc_distance2D)<_jumpDistanceFromTarget};

//Create para group
for "_i" from 1 to _jumperAmount step 1 do{
	
	_jumpPOS = [(getPos _heli) select 0,(getPos _heli) select 1, ((getPos _heli) select 2) - 3];
	_man2 = [_i,_grp2, _jumpPOS] call createParatrooper;
	_man2 setPos [(getPos _heli) select 0,(getPos _heli) select 1, ((getPos _heli) select 2) - 3];

	[_man2,_heli,_openHeight,_smokes,_flares,_chems] spawn{
		private ["_man2","_heli","_openHeight","_para","_smokes","_flares","_chems","_smoke","_flare","_chem"];
		_man2 = _this select 0;
		_heli = _this select 1;
		_openHeight = _this select 2;
		_smokes = _this select 3;
		_flares = _this select 4;
		_chems = _this select 5;
		waitUntil{((getPos _man2)select 2)<_openHeight};
		_para = createVehicle ["NonSteerable_Parachute_F", position _man2, [], ((direction _heli)-25+(random 50)), 'NONE'];
		_para setPos (getPos _man2);
		_man2 moveInDriver _para;
		
		if(_smokes)then{
			waitUntil{((getPos _man2)select 2)<10};
			_smoke = "SmokeShell" createVehicle (getPos _man2);
		};
		if(_flares)then{
			waitUntil{((getPos _man2)select 2)<30};
			_flare = "F_40mm_Red" createVehicle [(getPos _man2) select 0,(getPos _man2) select 1,0]; //Chemlight_red
		};
		if(_chems)then{
			waitUntil{((getPos _man2)select 2)<30};
			_chem = "Chemlight_red" createVehicle (getPos _man2);
		};
	};
	_man2 allowFleeing 0;
	sleep _jumpDelay;
};

if(!isNil("_grpId"))then{
	call compile format ["LVgroup%1 = _grp2",_grpId];
};

//If it wasnt flyby, send heli to its end spot
if(!_flyBy)then{ 
	_wp1 = _grp addWaypoint [_flySpot, 0, 2];
	[_grp,1] setWaypointBehaviour "CARELESS";
	[_grp,1] setWaypointCompletionRadius 60;
};

//Patrol stuff for para group (same as in reinforcementHeli, works but needs 'a bit' rework)
if(_patrol)then{
	if(typeName _target == "ARRAY")then{ //TARGET is array
		if((!((_target select 0) in allMapMarkers))&&(!((_target select 0) in allGroups)))then{
			if((typeName (_target select 0)) == "STRING")then{
				if((_target select 0) == "PATROL")then{ ////USE patrol-vD.sqf
					{
						_cPosition = _target select 1;
						_cRadius = _target select 2;
						nul = [_x,_cPosition,_cRadius,_doorHandling] execVM "addons\AI_Spawn\patrol-vD.sqf";
					}forEach units _grp2;
				};
			};
		}else{ //TARGET is array of Markers or Groups
			{ 
				_x setVariable ["target0",_target,false];
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
		if(_target in allMapMarkers)then{ /////TARGET is single Marker
			//{ _x doMove getMarkerPos _target; } forEach units _grp2;
			_cPosition = getMarkerPos _target;
			_cRadius = 50;
			{
			nul = [_x,_cPosition,_cRadius,_doorHandling] execVM "addons\AI_Spawn\patrol-vD.sqf";
			}forEach units _grp2;
		}else{
				{ ////TARGET is single Unit/Object
					_x setVariable ["target0",_target,false];
					_x setVariable ["mDis0", 1000, false];
					nul = [_x] execVM "addons\AI_Spawn\LV_functions\LV_fnc_follow.sqf";
				}forEach units _grp2;
		};
	};
}else{
	//If patrol is set to false, units will idle. Additionally you can set custom actions here:
	
};

