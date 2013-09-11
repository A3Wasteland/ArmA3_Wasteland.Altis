//	@file Version: 1.0
//	@file Name: mission_ArmedHeli.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 15:19
//	@file Args:

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_result", "_missionMarkerName", "_missionType", "_startTime", "_returnData", "_randomPos", "_randomIndex", "_vehicleClass", "_vehicle", "_picture", "_vehicleName", "_vehDeterminer", "_hint", "_currTime", "_playerPresent", "_unitsAlive"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "ArmedHeli_Marker";
_missionType = "Armed Helicopter";
_startTime = floor(time);

diag_log format["WASTELAND SERVER - Main Mission Started: %1",_missionType];

//Get Mission Location
_returnData = call createMissionLocation;
_randomPos = _returnData select 0;
_randomIndex = _returnData select 1;

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_vehicleClass = ["B_Heli_Light_01_armed_F", "B_Heli_Transport_01_F", "B_Heli_Attack_01_F", "O_Heli_Light_02_F", "O_Heli_Attack_02_F"] call BIS_fnc_selectRandom;

// Vehicle spawning: Name, Position, Fuel, Ammo, Damage, "NONE"

private "_vehAmmo";
_vehAmmo = 1;

switch (true) do
{
	case (_vehicleClass isKindOf "Heli_Light_01_base_F"):        { _vehAmmo = 0.5 };
	case (_vehicleClass isKindOf "Heli_Transport_01_base_F"):    { _vehAmmo = 0.5 };
	case (_vehicleClass isKindOf "Heli_Attack_01_base_F"):       { _vehAmmo = 0.2 };
	case (_vehicleClass isKindOf "Heli_Light_02_base_F"):        { _vehAmmo = 1 };
	case (_vehicleClass isKindOf "Heli_Attack_02_base_F"):       { _vehAmmo = 0.8 };
};

_vehicle = [_vehicleClass,_randomPos,1,_vehAmmo,0,"NONE"] call createMissionVehicle;

if ("CMFlareLauncher" in getArray (configFile >> "CfgVehicles" >> _vehicleClass >> "weapons")) then
{
	{
		if (_x isKindOf "60Rnd_CMFlare_Chaff_Magazine") then
		{
			_vehicle removeMagazinesTurret [_x, [-1]];
		};
	} forEach (_vehicle magazinesTurret [-1]);
	
	_vehicle addMagazineTurret ["120Rnd_CMFlare_Chaff_Magazine", [-1]];
};

switch (true) do
{
	case (_vehicle isKindOf "Heli_Attack_01_base_F"):
	{
		_vehicle removeMagazinesTurret ["24Rnd_PG_missiles", [0]];
		_vehicle removeMagazinesTurret ["4Rnd_AAA_missiles", [0]];
		_vehicle addMagazineTurret ["24Rnd_PG_missiles", [0]];
		_vehicle addMagazineTurret ["2Rnd_AAA_missiles", [0]];
	};
	case (_vehicle isKindOf "Heli_Attack_02_base_F"):
	{
		_vehicle removeMagazinesTurret ["250Rnd_30mm_APDS_shells", [0]];
		_vehicle removeMagazinesTurret ["38Rnd_80mm_rockets", [0]];
		_vehicle removeMagazinesTurret ["8Rnd_LG_scalpel", [0]];
		_vehicle addMagazineTurret ["14Rnd_80mm_rockets", [0]];
		_vehicle addMagazineTurret ["2Rnd_LG_scalpel", [0]];
	};
};

reload _vehicle;

_picture = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");

if (((toArray _vehicleName) select 0) in (toArray "AEIMO")) then
{
	_vehDeterminer = "An";
}
else
{
	_vehDeterminer = "A";
};

_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>%6 <t color='%4'>%3</t> has been immobilized, go get it for your team.</t>", _missionType, _picture, _vehicleName, mainMissionColor, subTextColor, _vehDeterminer];
[_hint] call hintBroadcast;

_CivGrpM = createGroup civilian;
[_CivGrpM,_randomPos] spawn createMidGroup;

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);

waitUntil
{
    sleep 1; 
	_playerPresent = false;
    _currTime = floor(time);
	
    if(_currTime - _startTime >= mainMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _vehicle <= missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = ({alive _x} count units _CivGrpM);
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1)) OR ((damage _vehicle) == 1)
};

_vehicle setVehicleLock "UNLOCKED";
_vehicle setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
    if (!isNil "_vehicle") then { deleteVehicle _vehicle };
    { deleteVehicle _x } forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>Objective failed, better luck next time.</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The armed helicopter has been captured, brace yourselves.</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
