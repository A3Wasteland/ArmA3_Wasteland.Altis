//	Lootspawner setup and control script
//	Author: Na_Palm (BIS forums)
//	credit to: Ed! (404Forums) and [GoT] JoSchaap (GoT2DayZ.nl) for initial script
//-------------------------------------------------------------------------------------
if (!isServer) exitwith {};
private["_buildingname","_chfullfuel","_chperSpot","_class","_dbgloopTime","_dbgloopTimeplU","_dbgTime","_dbgTurns","_dbgTurnsplU","_endloop","_genZadjust","_hndl","_item","_nearLootdist","_pos","_posAdjustZ","_posAdjustZlist","_poscount","_posIdxlist","_posnew","_posOrg","_posViable","_randomweapontestint","_spawnradius","_spInterval","_testpos","_tmpBuild","_tmpPoslist","_tmpTstPlace","_z"];
//-------------------------------------------------------------------------------------
//Switch
swDebugLS = false;					//Debug messages on/off
swSpZadjust = false;				//needed for ArmA 2 and older Maps/Buildings -> true

//-------------------------------------------------------------------------------------
//Variables
//local
#define LOOT_SPAWN_INTERVAL 30*60	//Time (in sec.) to pass before an building spawns new loot (must also change in LSclientScan.sqf)
#define CHANCES_FULL_FUEL_CAN 35	//Chance (in %) of a spawned fuelcan to be full instead of empty
#define LOOT_Z_ADJUST -0.1			//High adjustment thats generally added to every spawnpoint
#define CHANCES_LOOT_PER_SPOT 50	//Chance (in %) if a spot gets loot. Will be considered before 'spawnClassChance_list'

_tmpTstPlace = [14730, 16276, 0];	//Coord's, in [x,y,z] of a preferably flat and unocupied piece of land

//"spawnClassChance_list" array of [%weapon, %magazine, %ICV, %backpack, %object]
//									%weapon 	: chance weight to spawn a weapon on spot
//									%magazine 	: chance weight to spawn magazines on spot
//									%ICV	   	: chance weight to spawn item/cloth/vests on spot
//									%backpack 	: chance weight to spawn a backpack on spot
//									%object 	: chance weight to spawn an world object on spot
//-------------- A VALUE OF '0' RESULTS IN NO LOOT FOR THIS CLASS AND TYPE ----------------
spawnClassChance_list = [
[1.0, 1.5, 2.0, 0.25, 5.0],	// civil
[1.5, 2.0, 1.5, 0.5, 1.5],	// military
[0.5, 1.0, 3.0, 0.25, 5.0],	// industrial
[1.0, 1.5, 3.0, 0, 0]	// research
];

//"exclcontainer_list" single array of container classnames to NOT to delete if filled
exclcontainer_list = ["ReammoBox_F"];

//-------------------------------------------------------------------------------------
//DONT change these, will be filled in MAIN -------------------------------------------
spawnBuilding_list = [];
Buildingpositions_list = [];
LSusedclass_list = ["GroundWeaponHolder"];
//DONT change these, will be filled in MAIN -------------------------------------------
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//Buildings that can spawn loot go in this list
#include "LSlootBuildings.sqf"
//Loot goes in these lists
#include "LSlootLists.sqf"

//-------------------------------------------------------------------------------------
//function only runs once on beginning of mission, not really needs a compile 
//fill spawnBuilding_list with buildingnames only
getListBuildingnames = {
	{
		spawnBuilding_list set [count spawnBuilding_list, (_x select 0)];
		//diag_log format["-- LOOTSPAWNER DEBUG add to spawnBuilding_list: %1 ", (_x select 0)];
	}forEach Buildingstoloot_list;
};

//-------------------------------------------------------------------------------------
//function only runs once on beginning of mission, not really needs a compile 
//get list of all Lootspawner generatable 'Worldobjects'
getUsedclasses = {
	for "_class" from 0 to ((count lootworldObject_list) - 1) do {
		for "_item" from 0 to ((count ((lootworldObject_list select _class) select 1)) - 1) do {
			if !((((lootworldObject_list select _class) select 1) select _item) in LSusedclass_list) then {
				LSusedclass_list set [count LSusedclass_list, (((lootworldObject_list select _class) select 1) select _item)];
			};
			sleep 0.001;
		};
		sleep 0.001;
	};
};

//-------------------------------------------------------------------------------------
//function only runs once on beginning of mission, not really needs a compile 
//fill Buildingpositions_list with [_buildingname, [_posIdxlist], [_posAdjustZlist]] 
getListBuildingPositionjunction = {
	_tmpTstPlace = _this select 0;
	_randomweapontestint = 0.01;	//Sets the highintervals in which weaponpositions are tested. (Lower = slower, but more accurate. Higher = faster, but less accurate.)
	_nearLootdist = 0.5;
	{
		_buildingname = _x;
		_tmpBuild = _buildingname createVehicleLocal _tmpTstPlace;
		//check if the creation was successful
		if (isNil {_tmpBuild}) then {
			diag_log format["--!!ERROR!! LOOTSPAWNER in Buildingstoloot_list: %1 no viable object !!ERROR!!--", _buildingname];
		} else {
			//get spawnpositions from building
			_poscount = 0;
			_posAdjustZlist = [];
			_posIdxlist = [];
			_tmpPoslist = [];
			_endloop = false;
			while {!_endloop} do {
				if((((_tmpBuild buildingPos _poscount) select 0) != 0) && (((_tmpBuild buildingPos _poscount) select 1) != 0)) then {
					//counter loot piling
					_pos = _tmpBuild buildingPos _poscount;
					_posOrg = _pos;
					_posViable = false;
					if (_poscount != 0) then {
						{
							if ((_pos distance _x) > _nearLootdist) exitWith {
								_posViable = true;
							};
						}forEach _tmpPoslist;
					} else {
						_posViable = true;
					};
					_tmpPoslist set [count _tmpPoslist, _pos];
					//get Z adjustment for position
					if (_posViable) then {
						_posIdxlist set [count _posIdxlist, _poscount];
						_posAdjustZ = 0;
						if (swSpZadjust) then {
							if(_pos select 2 < 0) then {
								_pos = [_pos select 0, _pos select 1, 1];
							};
							_z = 0;
							_posnew = _pos;
							_testpos = true;
							while {_testpos} do 
							{
								if((!lineIntersects[ATLtoASL(_pos), ATLtoASL([_pos select 0, _pos select 1, (_pos select 2) - (_randomweapontestint * _z)])]) && (!terrainIntersect[(_pos), ([_pos select 0, _pos select 1, (_pos select 2) - (_randomweapontestint * _z)])]) && (_pos select 2 > 0)) then {
									_posnew = [_pos select 0, _pos select 1, (_pos select 2) - (_randomweapontestint * _z)];
									_z = _z + 1;
								} else {
									_testpos = false;
								};
							};
							_posnew = [_posnew select 0, _posnew select 1, (_posnew select 2) + 0.05];
							_posAdjustZ = (_posOrg select 2) - (_posnew select 2);
//							diag_log format["-- LOOTSPAWNER DEBUG adjusted %1 times", _z];
							_posAdjustZlist set [count _posAdjustZlist, _posAdjustZ];
						} else {
							_posAdjustZlist set [count _posAdjustZlist, _posAdjustZ];
						};
					};
					_poscount = _poscount + 1;
				} else {
					_endloop = true;
				};
			};
			//save final position Index & adjustments to list
			if (_poscount != 0) then {
				//diag_log format["-- LOOTSPAWNER DEBUG add to Buildingpositions_list: v%1v v%2v v%3v added", _buildingname, _posIdxlist, _posAdjustZlist];
				Buildingpositions_list set [count Buildingpositions_list, [_buildingname, _posIdxlist, _posAdjustZlist]];
			} else {
				diag_log format["-- !!LOOTSPAWNER WARNING!! in Buildingstoloot_list: %1 has no building positions --", _buildingname];
				Buildingpositions_list set [count Buildingpositions_list, [_buildingname, [0], [0]]];
			};
		};
		deleteVehicle _tmpBuild;
	}forEach spawnBuilding_list;
};

//-------------------------------------------------------------------------------------
// MAIN
//-------------------------------------------------------------------------------------
diag_log format["-- LOOTSPAWNER initialise ------------------------"];
if ((count Buildingstoloot_list) == 0) then {
	diag_log format["--!!ERROR!! LOOTSPAWNER Buildingstoloot_list in lootBuildings.sqf MUST have one entry at least !!ERROR!!--"];
	diag_log format["-- LOOTSPAWNER disabled --"];
} else {
	_dbgTime = diag_tickTime;
	call getListBuildingnames;
	
	diag_log format["-- LOOTSPAWNER spawnBuilding_list ready, d: %1s", (diag_tickTime - _dbgTime)];
	
	_dbgTime = diag_tickTime;
	[_tmpTstPlace] call getListBuildingPositionjunction;
	
	diag_log format["-- LOOTSPAWNER Buildingpositions_list ready, d: %1s", (diag_tickTime - _dbgTime)];
	
	_dbgTime = diag_tickTime;
	call getUsedclasses;
	
	diag_log format["-- LOOTSPAWNER LSusedclass_list ready, d: %1s", (diag_tickTime - _dbgTime)];
	
	//run loot deleter continously
	LOOT_SPAWN_INTERVAL spawn LSdeleter;
	diag_log format["-- LOOTSPAWNER LSDer started..."];
	
	if (swDebugLS) then {
		dbgTime = diag_tickTime;
		dbgTurns = 0;
		dbgTurnsplU = 0;
		dbgloopTime = 0;
		dbgloopTimeplU	= 0;
	};
	
	"pvar_spawnLootBuildings" addPublicVariableEventHandler
	{
		_buildings = [];
		
		{
			_class = [_x, 0, "", [""]] call BIS_fnc_param;
			_pos = [_x, 1, [], [[]]] call BIS_fnc_param;
			
			if (_class != "" && {count _pos == 3}) then
			{
				_nearBuilds = nearestObjects [_pos, [_class], 0.1];
				_building = [_nearBuilds, 0, objNull, [objNull]] call BIS_fnc_param;
				
				if (!isNull _building) then
				{
					[_buildings, _building] call BIS_fnc_arrayPush;
				};
			};
		} forEach (_this select 1);
		
		if (count _buildings > 0) then
		{
			[_buildings, LOOT_SPAWN_INTERVAL, CHANCES_FULL_FUEL_CAN, LOOT_Z_ADJUST, CHANCES_LOOT_PER_SPOT] spawn fn_getBuildingstospawnLoot;
		};
	};
	
	/*
	diag_log format["-- LOOTSPAWNER ready and waiting for players -----"];
	//go into mainloop till mission ends
	while {true} do {
		_playersalive = false;
		{
			if (swDebugLS) then {
				dbgTimeplU = diag_tickTime;
			};
			//is Player online and alive?
			if ((isPlayer _x) && (alive _x)) then {
				_playersalive = true;
				//jogging has 4.16..., sprinting has 5.5... so if player velocity is < 6 spawn loot
				//works for players in vehicles too
				if (((velocity _x) distance [0,0,0]) < 6) then {
				//if ((vehicle _x isKindOf "Land") || (vehicle _x isKindOf "Ship")) then {
					_posPlayer = getPos _x;
					//get list of viable buildings around player
					_BaP_list = nearestObjects [_posPlayer, spawnBuilding_list, _spawnradius];
					if ((count _BaP_list) > 0) then {
						//give to spawn function
						_hndl = [_BaP_list, LOOT_SPAWN_INTERVAL, CHANCES_FULL_FUEL_CAN, LOOT_Z_ADJUST, CHANCES_LOOT_PER_SPOT] spawn fn_getBuildingstospawnLoot;
						waitUntil{scriptDone _hndl};
					};
				};
			};
			sleep 0.001;
			if (swDebugLS) then {
				dbgloopTimeplU = dbgloopTimeplU + (diag_tickTime - dbgTimeplU);
				dbgTurnsplU = dbgTurnsplU + 1;
			};
		}forEach playableUnits;
		if (swDebugLS) then {
			dbgloopTime = dbgloopTime + dbgloopTimeplU;
			dbgloopTimeplU	= 0;
			dbgTurns = dbgTurns + 1;
			//every 30 sec. give stats out
			if ((diag_tickTime - dbgTime) > 30) then {
				if (dbgTurnsplU > 0) then {
					diag_log format["-- DEBUG LOOTSPAWNER MAIN turns (spawned): %1(%2), duration: %3sec, average: %4sec.",dbgTurns ,dbgTurnsplU , dbgloopTime, (dbgloopTime / dbgTurnsplU)];
				} else {
					diag_log format["-- DEBUG LOOTSPAWNER MAIN waiting for players"];
				};
				dbgTime = diag_tickTime;
				dbgTurns = 0;
				dbgTurnsplU = 0;
				dbgloopTime = 0;
			};
		};
		//if no players online wait a bit
		if (!_playersalive) then {
			sleep 2;
		};
	};
	*/
};