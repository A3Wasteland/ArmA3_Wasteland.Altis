// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: addVehicleRespawn.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

#define PARAM(IDX,DEF) if (count _this > IDX) then { _this select IDX } else { DEF }

private ["_vehicle", "_wheels", "_hitPoint", "_respawnPos", "_respawnTimer", "_desertedTimer", "_proxyTimer", "_proxyDistance", "_minDistance", "_settings"];
_vehicle = _this select 0;

if (!alive _vehicle) exitWith {};

_wheels = [];
{
	_hitPoint = configName _x;
	if ([["Wheel","Track"], _hitPoint] call fn_findString != -1) then
	{
		_wheels pushBack _hitPoint;
	};
} forEach (_vehicle call getHitPoints);

_vehicle setVariable ["vehicleRespawn_wheelHitPoints", _wheels];

if (!isNil {_vehicle getVariable "vehicleRespawn_settingsArray"}) exitWith {};

_respawnPos =     PARAM(1, []);     // Respawn position (ATL) for the vehicle; if unspecified, respawns at the despawning location
_respawnTimer =   PARAM(2, 15*60);  // Default respawn timer when vehicle is broken (0 = respawn immediatly (not recommended))
_desertedTimer =  PARAM(3, 30*60);  // Default respawn timer when vehicle is deserted but not broken
_proxyTimer =     PARAM(4, 45*60);  // Respawn timer when the last vehicle owner is within the defined proximity distance
_proxyDistance =  PARAM(5, 1000);   // Distance from the vehicle within which the last owner triggers the proximity timer
_minDistance =    PARAM(6, 10);     // Minimum displacement distance from original location before the respawn timer is auto-activated (0 = only respawn when broken or looted)

if (isNil "A3W_respawningVehicles") then { A3W_respawningVehicles = [] };

_settings = createHashMapFromArray
[
	["_veh", _vehicle],
	["_vehClass", typeOf _vehicle],
	["_startPos", getPosWorld _vehicle],
	["_lastSeenAlive", diag_tickTime],
	["_respawnPos", _respawnPos],
	["_respawnTimer", _respawnTimer],
	["_minDistance", _minDistance],
	["_desertedTimer", _desertedTimer],
	["_proxyTimer", _proxyTimer],
	["_proxyDistance", _proxyDistance],
	["_desertedTimeout", 0],
	["_brokenTimeout", 0]
];

A3W_respawningVehicles pushBack _settings;

_vehicle setVariable ["vehicleRespawn_settingsArray", _settings];
