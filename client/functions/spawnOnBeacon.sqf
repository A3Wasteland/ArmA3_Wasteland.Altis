//	@file Version: 1.1
//	@file Name: spawnOnBeacons.sqf
//	@file Author: [404] Costlyy, [GoT] JoSchaap, MercyfulFate
//	@file Created: 08/12/2012 18:30
//	@file Args: [int(0 = button 0 etc)]

#define respawn_Town_Button0 3403
#define respawn_Town_Button1 3404
#define respawn_Town_Button2 3405
#define respawn_Town_Button3 3406
#define respawn_Town_Button4 3407
disableSerialization;

private ["_display", "_beaconName"];

_display = uiNamespace getVariable "RespawnSelectionDialog";
_beaconName = ctrlText (_display displayCtrl (respawn_Town_Button0 + (_this select 0)));

{
	if (_name == _x getVariable ["ownerName", ""]) exitWith
	{
        player setPos ([getPos _x,1,25,1,0,0,0] call findSafePos);
    };
} forEach pvar_spawn_beacons;

respawnDialogActive = false;
closeDialog 0;
[format ["You have spawned on %1's beacon", _name], 5] call mf_notify_client;

sleep 5;

_mins = floor(60 * (daytime - floor(daytime)));
[
"Wasteland","Spawn Beacon",
format ["%1:%3%2", floor(daytime), _mins, if(_mins < 10) then {"0"} else {""}]
] spawn BIS_fnc_infoText;
