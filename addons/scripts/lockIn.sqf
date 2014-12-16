private ["_vehicle","_nearvehicle"];
_nearvehicle = nearestObjects [player, ["LandVehicle", "Ship", "Air"], 5];
_vehicle = _nearvehicle select 0;

if (isNil "_vehicle") exitWith {};

if (!isDedicated) then 
	{
	[[netId _vehicle, 2], "A3W_fnc_setLockState", _vehicle] call A3W_fnc_MP; // Lock
	_vehicle setVariable ["objectLocked", true, true];
	_vehicle setVariable ["R3F_LOG_disabled",true,true];
		
	_vehicle say3D "carlock";
	sleep 0.5;
	titleText ["Locked!","PLAIN DOWN"]; titleFadeOut 5;
	
};