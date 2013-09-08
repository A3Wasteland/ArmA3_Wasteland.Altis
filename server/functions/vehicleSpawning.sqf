//	@file Version: 2
//	@file Name: vehicleSpawning.sqf
//	@file Author: JoSchaap
//  new one, no longer requires Spawn_ markers but uses the town's radius in config.sqf to pick the ammount of vehicles


if(!X_Server) exitWith {};

private ["_counter","_townname","_tradius","_pos","_vehammount","_minrad","_maxrad","_lcounter"];
_tradius = 0;
_townname = "debug";
_counter = 1;
_vehammount = 0;
_minrad = 0;
_maxrad = 0;
_lcounter = 0;

{
	_pos = getMarkerPos (_x select 0);
	_tradius = (_x select 1);
	_townname = (_x select 2);
	_vehammount = (round (((_tradius / 30) *2) -2));  // spawns 2 vehicles for every 25 mtr radius the townmarker has, this might need tweaking! 
	_minrad = 30;
	_maxrad = 45;
	while {(_lcounter < _vehammount)} do {
		_pos = [_pos,_minrad,_maxrad,1,0,0,0,[],[_pos]] call BIS_fnc_findSafePos;
		[_pos] call vehicleCreation;
		_minrad = (_minrad + 15);
		_maxrad = (_maxrad + 15);
		_counter = (_counter + 1);
		_lcounter = (_lcounter + 1);
		_pos = [_pos,_minrad,_maxrad,1,0,0,0,[],[_pos]] call BIS_fnc_findSafePos;
		[_pos] call vehicleCreation;
		_counter = (_counter + 1);
		_lcounter = (_lcounter + 1);
		_minrad = (_minrad + 15);
		_maxrad = (_maxrad + 15);
	};	
	//diag_log format["WASTELAND DEBUG - spawned %1 Vehicles in: %2",_lcounter,_townname];
	_lcounter = 0;
}forEach (call citylist);

diag_log format["WASTELAND - Vehicle spawning completed - %1 Vehicles Spawned on Altis",_counter];

