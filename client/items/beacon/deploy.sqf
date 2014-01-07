//@file Version: 1.0
//@file Name: deploy.sqf
//@file Author: MercyfulFate
//@file Created: 21/7/2013 16:00
//@file Description: Deploy a Spawn Beacon
//@file Argument: [player, player, _action, []] the standard "called by an action" values

#define ANIM "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_CANCELLED "Action Cancelled"
#define ERR_IN_VEHICLE "Action Failed! You can't do this in a vehicle"
private ["_hasFailed", "_success","_pos","_uid","_beacon"];
_hasFailed = {
    private ["_progress", "_failed", "_text"];
    _progress = _this select 0;
    _failed = true;
    switch (true) do {
        case not(alive player):{};
        case (doCancelAction) :{doCancelAction = false; _text = ERR_CANCELLED;};
        case not(vehicle player == player): {_text = ERR_IN_VEHICLE};
        default {
            _text = format["Spawn Beacon %1%2 Deployed", round(_progress*100), "%"];
            _failed = false;
        };
    };
    [_failed, _text];
};
_success = [MF_ITEMS_SPAWN_BEACON_DURATION, ANIM, _hasFailed, []] call a3w_actions_start;

if (_success) then {
    _uid = getPlayerUID player;
	_pos = getPosATL player;
    _dir = getdir player;
    // Spawn 4m in front of the player  
    _pos = [(_pos select 0)+4*sin(_dir),(_pos select 1)+4*cos(_dir),0];

	_beacon = MF_ITEMS_SPAWN_BEACON_DEPLOYED_TYPE createVehicle _pos;
	_beacon setPosATL _pos;
	_beacon allowDamage false;
    _beacon setVariable ["spawn-beacon", true, true];
	_beacon setVariable ["R3F_LOG_disabled", true];
	_beacon setVariable ['side', playerSide, true];
	_beacon setVariable ['ownerName', name player, true];
	_beacon setVariable ['ownerUID', _uid, true];
    _beacon setVariable ['packing', false, true];
    _beacon setVariable ['groupOnly', (playerSide == resistance), true];    
    {
        if (_x getVariable ["ownerUID",""] == _uid) exitWith {
            pvar_spawn_beacons set [_forEachIndex, "removeMe"];
        };
    } forEach pvar_spawn_beacons;
    pvar_spawn_beacons = pvar_spawn_beacons - ["removeMe"];
	pvar_spawn_beacons = pvar_spawn_beacons + [_beacon];
    publicVariable "pvar_spawn_beacons";
	["You placed the Spawn Beacon successfully!", 5] call mf_notify_client;
};
_success;
