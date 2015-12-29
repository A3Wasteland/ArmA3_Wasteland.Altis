// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: vPin_openvPin.sqf
//	@file Author: LouD
//	@file Description: unlocks the vehicle

private ["_vPins"];
_vPins = cursorTarget;

if (!isNil "_vPins") then
{
	if (cursorTarget getVariable "R3F_LOG_disabled") then
	{
		if (local _vPins) then 
		{
			_vPins lock 1;
		}
		else
		{
			[[netId _vPins, 1], "A3W_fnc_setLockState", _vPins] call A3W_fnc_MP; // Unlock
		};

		_vPins setVariable ["objectLocked", false, true]; 
		_vPins setVariable ["R3F_LOG_disabled",false,true];	
		playSound3d ["a3\sounds_f\air\Heli_Attack_01\close.wss", player, true];
		["The vehicle is unlocked", 5] call mf_notify_client;
	}
	else
	{
		["The vehicle was already unlocked", 5] call mf_notify_client;
	};
} 
else 
{
	["No locked vehicle found", 5] call mf_notify_client;
};