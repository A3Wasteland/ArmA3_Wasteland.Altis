//	@file Name: unlock.sqf
//	@file Author: Cael817, based on stuff i found and a lot of help


private ["_vehicle","_nearvehicle"];
_nearvehicle = nearestObjects [player, ["LandVehicle", "Ship", "Air"], 7];
_vehicle = _nearvehicle select 0;

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
		
	_vehicle say3D "carlock";
	player action ["lightOn", _vehicle];
	sleep 0.5;
	player action ["lightOff", _vehicle];
	titleText ["Vehicle Unlocked!","PLAIN DOWN"]; titleFadeOut 2;
	

