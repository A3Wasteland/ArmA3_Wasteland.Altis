private ["_vehicle","_nearvehicle"];
_nearvehicle = nearestObjects [player, ["LandVehicle", "Ship", "Air"], 5];
_vehicle = _nearvehicle select 0;

if (isNil "_vehicle") exitWith {};

if (!isDedicated) then 
	{
	[[netId _vehicle, 1], "A3W_fnc_setLockState", _vehicle] call A3W_fnc_MP; // Unlock
	_vehicle setVariable ["objectLocked", false, true]; 
	_vehicle setVariable ["R3F_LOG_disabled",false,true];
		
	_vehicle say3D "carlock";
	sleep 0.5;
	titleText ["Unlocked!","PLAIN DOWN"]; titleFadeOut 5;
	
};
