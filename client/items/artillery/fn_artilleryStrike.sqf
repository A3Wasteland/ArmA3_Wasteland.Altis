// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_artilleryStrike.sqf
//	@file Author: AgentRev

#include "artillery_defines.hpp"
#define SLEEP_REALTIME(SECS) if (hasInterface) then { sleep (SECS) } else { uiSleep (SECS) }

params [["_player",objNull,[objNull]], ["_pos",[],[[]]], ["_success",nil,[false]]];

if (!isRemoteExecuted || !alive _player) exitWith {};
if (isServer && !(remoteExecutedOwner in [owner _player, clientOwner])) exitWith
{
	["forged artilleryStrike", _this] call A3W_fnc_remoteExecIntruder;
};

if (isServer && isNil "_success") then // server process
{
	private _UID = getPlayerUID _player;
	private _artiUseVar = "A3W_artilleryLastUse_" + _UID;
	private _artiLastUse = if (_UID == "") then { [_player getVariable "A3W_artilleryLastUse"] param [0,nil,[0]] } else { missionNamespace getVariable _artiUseVar };
	private _cooldown = ["A3W_artilleryCooldown", 3600] call getPublicVar;
	_success = false;

	if (count _pos == 2) then { _pos set [2,0] };

	if (_pos isEqualTypeArray [0,0,0] && (isNil "_artiLastUse" || {diag_tickTime - _artiLastUse >= _cooldown})) then
	{
		diag_log format ["artilleryStrike - %1", [_UID, _player, name _player, side group _player, owner _player, remoteExecutedOwner, _pos, mapGridPosition _pos]];

		[
			_player,
			_pos,
			A3W_artilleryMenu_ammoClass,
			A3W_artilleryMenu_shellCount,
			A3W_artilleryMenu_strikeRadius
		]
		spawn
		{
			params ["_player", "_pos", "_ammo", "_count", "_radius"];
			for "_i" from 1 to _count do
			{
				_ipos = _pos vectorAdd ([[random _radius, 0, 7500], random 360] call BIS_fnc_rotateVector2D); // spawns at 7500m with -150m/s speed, about 30 seconds fall time
				_shell = createVehicle [_ammo, _ipos, [], 0, "NONE"];
				_shell setShotParents [_player, objNull];
				_shell setVelocity [0,0,-150];
				SLEEP_REALTIME(1 + random 2);
			};
		};

		_artiLastUse = diag_tickTime;

		if (_UID != "") then
		{
			missionNamespace setVariable [_artiUseVar, _artiLastUse];
			owner _player publicVariableClient _artiUseVar;
		};

		_player setVariable ["A3W_artilleryLastUse", _artiLastUse];
		_success = true;
	};

	[_player, _pos, _success] remoteExecCall ["A3W_fnc_artilleryStrike", _player];
}
else // client post-process
{
	if (_success) then
	{
		["Strike successfully initiated.", 5] call a3w_actions_notify;
	}
	else
	{
		["artillery", 1] call mf_inventory_add;
		["Error initiating strike.\n Please try again. ", 5] call a3w_actions_notify;
	};
};
