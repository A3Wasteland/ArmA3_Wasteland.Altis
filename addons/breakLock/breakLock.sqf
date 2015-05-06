//@file Version: 1.2
//@file Name: breakLock.sqf
//@file Author: Cael817, based on stuff i found and a lot of help


private ["_vehicle","_nearvehicle", "_break", "_type", "_price"];
_nearvehicle = nearestObjects [player, ["LandVehicle", "Ship", "Air"], 7];
_vehicle = _nearvehicle select 0;
_break = floor (random 100);
_type = typeOf _vehicle;
_price = 100;

{
if (_type == _x select 1) then
	{   
	_price = _x select 2;
	_price = round (_price / 1000) + 100;
	};
} forEach (call allVehStoreVehicles);

_break = floor (random 100);
//hint format ["Break is %1 and price is %2", _break, _price];

if (_break < _price / 4) exitWith {
	hint "Your ToolKit broke";
	player removeItem "ToolKit";
};

 for "_i" from _price to 0 step -1 do
 {
    hint str _i;
	player action ["lightOn", _vehicle];
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundToPlay = _soundPath + "addons\breakLock\sounds\carhorn.ogg";
	playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 1, 1, 0];
    sleep 0.5;
	player action ["lightOff", _vehicle];
	sleep 0.5;
	
	if (player distance _vehicle >5 ) then
	{
	hint "Attempt aborted. You need to stay close to the vehicle in order to break in.";
	breakOut "_i";
	};	
};
	
	if (local _vehicle) then
			{
				_vehicle lock 1;
				//hint "local";
			}
			else
			{
				[[netId _vehicle, 1], "A3W_fnc_setLockState", _vehicle] call A3W_fnc_MP; // Unlock
				//hint "not local";
			};

	_vehicle setVariable ["objectLocked", false, true]; 
	_vehicle setVariable ["R3F_LOG_disabled",false,true];		
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundToPlay = _soundPath + "addons\breakLock\sounds\carlock.ogg";
	playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 1, 1, 15];
	player action ["lightOn", _vehicle];
	_vehicle engineOn true;
	//sleep 0.5;
	//player action ["lightOff", _vehicle];
	titleText ["You broke in to the vehicle!","PLAIN DOWN"]; titleFadeOut 2;
