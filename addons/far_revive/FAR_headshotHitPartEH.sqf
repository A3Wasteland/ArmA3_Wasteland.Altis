// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_headshotHitPartEH.sqf
//	@file Author: AgentRev

#include "FAR_defines.sqf"

params [["_vals",0]];

if !(_vals isEqualType []) exitWith {}; // is sometimes object

_vals params ["_target", "_shooter", "", "", "", "_selections", "_hit", "", "", "", "_direct"];

if (!(_selections arrayIntersect ["head","face_hub"] isEqualTo []) && _direct) then
{
	if (!alive _target) exitWith
	{
		_targetEH = _target getVariable "FAR_headshotHitPartEH";
		if (!isNil "_targetEH") then { _target removeEventHandler ["HitPart", _targetEH] };
	};

	if (local _target) then
	{
		_hit params ["_directDmg", "", "", "", ["_ammo",""]];

		// "_directDmg" is not the actual damage inflicted by the bullet, but rather the default damage value it would inflict without armor

		if ((isPlayer _target || FAR_Debugging) && _directDmg >= 1 &&
		   {_ammo select [0,2] == "B_" && (!([_shooter, _target] call A3W_fnc_isFriendly) || FAR_Debugging) && !(_target getVariable ["FAR_headshotHitTimeout", false])}) then
		{
			if (UNCONSCIOUS(_target)) then
			{
				private "_killerVehicle";
				_killerVehicle = _target getVariable "FAR_killerVehicle";

				if (isNil "_killerVehicle") then
				{
					[_target, _shooter, _ammo] call FAR_setKillerInfo;
					_killerVehicle = _target getVariable ["FAR_killerVehicle", objNull];
				};

				if (_killerVehicle isEqualTo _shooter && _target getVariable ["FAR_killerAmmo", ""] == _ammo) then
				{
					_primeSuspect = _target getVariable ["FAR_killerPrimeSuspect", objNull];

					if (isNull _primeSuspect) then
					{
						_primeSuspect = _target call FAR_findKiller;
						_target setVariable ["FAR_killerPrimeSuspect", _primeSuspect];
					};

					// DING DING DING
					if (isPlayer _primeSuspect && _primeSuspect isKindOf "Man") then
					{
						_target setHitPointDamage ["HitHead", 1];
						diag_log format ["HEADSHOT by [%1] with [%2]", _primeSuspect, _ammo];
					};
				};
			}
			else // queue for processing by incoming HandleDamage
			{
				_target setVariable ["FAR_headshotHitPartEH_queued", [time, _this]];
			};
		};
	}
	else
	{
		_this remoteExecCall ["FAR_fnc_headshotHitPartEH", _target];
	};
};
