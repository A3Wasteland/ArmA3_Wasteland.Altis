// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2018 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: takeFromCrate.sqf

// dropped item is handled in client\inventory\take.sqf

#include "mutex.sqf"

private "_crate";
private _error = if ("artillery" call mf_inventory_is_full) then { "You have reached the maximum number\n of Artillery Strikes you can carry. " } else mf_items_artillery_canTakeFromCrate;
if (_error != "") exitWith
{
	[_error, 5] call a3w_actions_notify;
	playSound "FD_CP_Not_Clear_F";
};

MUTEX_LOCK_OR_FAIL;
player playActionNow "PutDown";
sleep 0.25;
[player, _crate] remoteExecCall ["A3W_fnc_takeArtilleryStrike", 2];
sleep 0.75;
MUTEX_UNLOCK;
