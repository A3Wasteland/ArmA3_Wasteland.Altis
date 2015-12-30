// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: vPin_closevPin.sqf
//	@file Author: LouD
//	@file Description: locks the vehicle

private ["_vPins"];
_vPins = cursorTarget;

if (!isNil "_vPins") then
{
	if !(cursorTarget getVariable "R3F_LOG_disabled") then
	{
		if (local _vPins) then
		{
			_vPins lock 2;
		}
		else
		{
			[[netId _vPins, 2], "A3W_fnc_setLockState", _vPins] call A3W_fnc_MP; // Unlock
		};

		_vPins setVariable ["objectLocked", true, true]; 
		_vPins setVariable ["R3F_LOG_disabled",true,true];	
		playSound3d ["a3\sounds_f\air\Heli_Attack_02\Mixxx_door.wss", player, true];
		["The vehicle is locked", 5] call mf_notify_client;
	}
	else
	{
		["The vehicle was already locked", 5] call mf_notify_client;
	};
} 
else 
{
	["No unlocked vehicle found", 5] call mf_notify_client;
};