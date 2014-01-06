//	@file Version: 1.1
//	@file Name: spawnOnBeacons.sqf
//	@file Author: [404] Costlyy, [GoT] JoSchaap, MercyfulFate
//	@file Created: 08/12/2012 18:30
//	@file Args: 

private "_buttonText";
_buttonText = _this select 0;

{
	if (_buttonText == _x getVariable ["ownerName", ""]) exitWith
	{
        player setPos ([getPos _x,1,25,1,0,0,0] call findSafePos);
    };
} forEach pvar_spawn_beacons;

respawnDialogActive = false;
closeDialog 0;
[format ["You have spawned on %1's beacon", _buttonText], 5] call mf_notify_client;

sleep 5;

_hour = date select 3;
_mins = date select 4;
["Wasteland", "Spawn Beacon", format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
