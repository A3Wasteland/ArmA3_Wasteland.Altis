//Client Function for Airdrop Assistance (not really a function, as it is called via ExecVM from command menu)
//This takes values from command menu, and some passed variables, and interacts with client and sends commands to server
//Author: Apoc
//Credits: Some methods taken from Cre4mpie's airdrop scripts, props for the idea!
//Starts off much the same as the client start.  This is to find information from config arrays


private ["_type","_selection","_player","_heliDirection"]; //Variables coming from command menu and client side APOC_cli_startAirdrop
_type = _this select 0;
_selectionNumber = _this select 1;
_player = _this select 2;
_heliDirection = _this select 3;

diag_log format ["SERVER - Apoc's Airdrop Assistance - Player: %1, Drop Type: %2, Selection #: %3",name _player,_type,_selectionNumber];
//hint format ["Well we've made it this far! %1, %2, %3,",_player,_type,_selectionNumber];
_selectionArray = [];

switch (_type) do {
	case "vehicle": {_selectionArray = APOC_AA_VehOptions};
	case "supply": 	{_selectionArray = APOC_AA_SupOptions};
	case "picnic":	{_selectionArray = APOC_AA_SupOptions};
	default 		{_selectionArray = APOC_AA_VehOptions; diag_log "AAA - Default Array Selected - Something broke";};
};

_selectionName 	= (_selectionArray select _selectionNumber) select 0;
_selectionClass = (_selectionArray select _selectionNumber) select 1;
_price 			= (_selectionArray select _selectionNumber) select 2;
// Moved money removal until after the drop point.

//OK, now the real fun

/////// Let's spawn us  an AI helo to carry the cargo /////////////////////////////////////////////////

 _heliType = "B_Heli_Transport_03_unarmed_F";
 _center = createCenter civilian;
_grp = createGroup civilian;
if(isNil("_grp2"))then{_grp2 = createGroup civilian;}else{_grp2 = _grp2;};
_flyHeight = 350;
_dropSpot = [(position _player select 0),(position _player select 1),_flyHeight];
_flyHeight = 200;  //Distance from ground that heli will fly at
_heliStartDistance = 2000;
_spos=[(_dropSpot select 0) - (sin _heliDirection) * _heliStartDistance, (_dropSpot select 1) - (cos _heliDirection) * _heliStartDistance, (_flyHeight+200)];

diag_log format ["AAA - Heli Spawned at %1", _spos];
_heli = createVehicle [_heliType, _spos, [], 0, "FLY"];
_heli allowDamage false;
_heli setVariable ["R3F_LOG_disabled", true, true];
[_heli] call vehicleSetup;

_crew = [_grp, _spos] call createRandomSoldierC;
_crew moveInDriver _heli;
_crew allowDamage false;

_heli setCaptive true;

_heliDistance = 2000;
_dir = ((_dropSpot select 0) - (_spos select 0)) atan2 ((_dropSpot select 1) - (_spos select 1));
_flySpot = [(_dropSpot select 0) + (sin _dir) * _heliDistance, (_dropSpot select 1) + (cos _dir) * _heliDistance, _flyHeight];

_grp setCombatMode "BLUE";
_grp setBehaviour "CARELESS";

{_x disableAI "AUTOTARGET"; _x disableAI "TARGET";} forEach units _grp;

_wp0 = _grp addWaypoint [_dropSpot, 0, 1];
[_grp,1] setWaypointBehaviour "CARELESS";
[_grp,1] setWaypointCombatMode "BLUE";
[_grp,1] setWaypointCompletionRadius 20;
_wp1 = _grp addWaypoint [_flySpot, 0, 2];
[_grp,2] setWaypointBehaviour "CARELESS";
[_grp,2] setWaypointCombatMode "BLUE";
[_grp,2] setWaypointCompletionRadius 20;
_heli flyInHeight _flyHeight;

//////// Create Purchased Object //////////////////////////////////////////////
_object = switch (_type) do {
	case "vehicle":
	{
		_objectSpawnPos = [(_spos select 0), (_spos select 1), (_spos select 2) - 5];
		_object = createVehicle [_selectionClass, _objectSpawnPos, [], 0, "None"];
		diag_log format ["Apoc's Airdrop Assistance - Object Spawned at %1", position _object];
		_object setVariable ["A3W_purchasedStoreObject", true];
		_object setVariable ["A3W_purchasedVehicle", true, true];
		_object setVariable ["ownerUID", getPlayerUID _player, true];
		_object setVariable ["R3F_LOG_Disabled", false, true];
		[_object, false] call vehicleSetup;
		if (_object getVariable ["A3W_purchasedVehicle", false] && !isNil "fn_manualVehicleSave") then
		{
			_object call fn_manualVehicleSave;
		};
		_object attachTo [_heli, [0,0,-5]]; //Attach Object to the heli
		_object
	};
	case "supply":
	{
		_objectSpawnPos = [(_spos select 0), (_spos select 1), (_spos select 2) - 5];
		_object = createVehicle ["B_supplyCrate_F", _objectSpawnPos, [], 0, "None"];
		_object setVariable ["A3W_purchasedStoreObject", true];
		_object setVariable ["R3F_LOG_Disabled", false, true];
		[_object, _selectionClass] call fn_refillbox;
		_object setVariable ["A3W_inventoryLockR3F", false, true];
		_object attachTo [_heli, [0,0,-5]]; //Attach Object to the heli
		_object
	};
	case "picnic":  //Beware of Bears!
	{
		_objectSpawnPos = [(_spos select 0), (_spos select 1), (_spos select 2) - 5];
		_object = createVehicle ["B_supplyCrate_F", _objectSpawnPos, [], 0, "None"];
		diag_log format ["Apoc's Airdrop Assistance - Object Spawned at %1", position _object];
		_object setVariable ["A3W_purchasedStoreObject", true];
		_object setVariable ["R3F_LOG_Disabled", false, true];
		_object attachTo [_heli, [0,0,-5]]; //Attach Object to the heli
		_object
	};
	default {
		_objectSpawnPos = [(_spos select 0), (_spos select 1), (_spos select 2) - 5];
		_object = createVehicle ["B_supplyCrate_F", _objectSpawnPos, [], 0, "None"];
		_object setVariable ["A3W_purchasedStoreObject", true];
		_object setVariable ["R3F_LOG_Disabled", false, true];
		[_object, "mission_USSpecial"] call fn_refillbox;
		_object setVariable ["A3W_inventoryLockR3F", false, true];
		_object attachTo [_heli, [0,0,-5]]; //Attach Object to the heli
		_object
		};
};
_object allowDamage false; //Let's not let these things get destroyed on the way there, shall we?

diag_log format ["Apoc's Airdrop Assistance - Object at %1", position _object];  //A little log love to confirm the location of this new creature

//Wait until the heli completes the drop waypoint, then move on to dropping the cargo and all of that jazz

While {true} do {
	sleep 0.1;
	if (currentWaypoint _grp >= 2) exitWith {};  //Completed Drop Waypoint
};
// Let's handle the money after this tricky spot - This way players won't be charged for non-delivered goods!
_playerMoney = _player getVariable ["bmoney", 0];
		if (_price > _playerMoney) exitWith{
			{ _x setDamage 1; } forEach units _grp;
			_heli setDamage 1;
			_object setDamage 1;
			diag_log format ["Apoc's Airdrop Assistance - Player Account Too Low, Drop Aborted. %1. Bank:$%2. Cost: $%3", _player, _playerMoney, _price];  //A little log love to mark the Scallywag who tried to cheat the valiant pilot
			};  //Thought you'd be tricky and not pay, eh?

//Server Style Money handling
_balance = _player getVariable ["bmoney", 0];
_newBalance = _balance - _price;
_player setVariable ["bmoney", _newBalance, true];
[getPlayerUID _player, [["BankMoney", _newBalance]], []] call fn_saveAccount;

//  Now on to the fun stuff:

diag_log format ["Apoc's Airdrop Assistance - Object at %1, Detach Up Next", position _object];  //A little log love to confirm the location of this new creature
playSound3D ["a3\sounds_f\air\sfx\SL_rope_break.wss",_heli,false,getPosASL _heli,3,1,500];
detach _object;  //WHEEEEEEEEEEEEE
_objectPosDrop = position _object;
_heli fire "CMFlareLauncher";
_heli fire "CMFlareLauncher";

sleep 2;
playSound3D ["a3\sounds_f\sfx\radio\ambient_radio22.wss",_player,false,getPosASL _player,3,1,25];

//Delete heli once it has proceeded to end point
	[_heli,_grp,_flySpot,_dropSpot,_heliDistance] spawn {
		private ["_heli","_grp","_flySpot","_dropSpot","_heliDistance"];
		_heli = _this select 0;
		_grp = _this select 1;
		_flySpot = _this select 2;
		_dropSpot = _this select 3;
		_heliDistance = _this select 4;
		while{([_heli, _flySpot] call BIS_fnc_distance2D)>200}do{
			if(!alive _heli || !canMove _heli)exitWith{};
			sleep 5;
		};
		waitUntil{([_heli, _dropSpot] call BIS_fnc_distance2D)>(_heliDistance * .5)};
		{ deleteVehicle _x; } forEach units _grp;
		deleteVehicle _heli;
	};

//Time based deletion of the heli, in case it gets distracted
	[_heli,_grp] spawn {
		private ["_heli","_grp"];
		_heli = _this select 0;
		_grp = _this select 1;
		sleep 30;
		if (alive _heli) then
		{
			{ deleteVehicle _x; } forEach units _grp;
			deleteVehicle _heli;
			diag_log "AIRDROP SYSTEM - Deleted Heli after Drop";
		};
	};

WaitUntil {(((position _object) select 2) < (_flyHeight-20))};
		_heli fire "CMFlareLauncher";
		_objectPosDrop = position _object;
		_para = createVehicle ["B_Parachute_02_F", _objectPosDrop, [], 0, ""];
		_object attachTo [_para,[0,0,-1.5]];

		_smoke1= "SmokeShellGreen" createVehicle getPos _object;
		_smoke1 attachto [_object,[0,0,-0.5]];
		_flare1= "F_40mm_Green" createVehicle getPos _object;
		_flare1 attachto [_object,[0,0,-0.5]];

		if (_type == "vehicle") then {_object allowDamage true;}; //Turn on damage for vehicles once they're in the 'chute.  Could move this until they hit the ground.  Admins choice.

WaitUntil {((((position _object) select 2) < 1) || (isNil "_para"))};
		detach _object;
		_smoke2= "SmokeShellGreen" createVehicle getPos _object;
		//_smoke2 attachto [_object,[0,0,-0.5]];
		_flare2= "F_40mm_Green" createVehicle getPos _object;
		//_flare2 attachto [_object,[0,0,-0.5]];
		sleep 2;
		if (_type == "picnic") then {  //So let's go ahead and delete that ugly ammo pallet and create a wonderful picnic basket/barrel
			_objectLandPos = position _object;
			deleteVehicle _object;
			_object2 = switch (_selectionClass) do {
				case "Land_Sacks_goods_F": {
					_object2 = createVehicle [_selectionClass, _objectLandPos, [], 0, "None"];
					_object2 setVariable ["food", 50, true];
					_object2 setVariable ["R3F_LOG_Disabled", false, true];
					_object2
				}; //A very big picnic, no?
				case "Land_BarrelWater_F": {
					_object2 = createVehicle [_selectionClass, _objectLandPos, [], 0, "None"];
					_object2 setVariable ["water",50, true];
					_object2 setVariable ["R3F_LOG_Disabled", false, true];
					_object2
				};
			};
		};