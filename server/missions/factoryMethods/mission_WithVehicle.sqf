//	@file Version: 1.0
//	@file Name: mission_LightTank.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 15:19
//	@file Args:[_noSquads, _missionMarkerName, _missionType, _vehicleClass,_randomPos]

if(!isServer) exitwith {};
#include "mainMissionDefines.sqf"
private ["_result","_missionMarkerName","_missionType","_startTime","_returnData","_randomPos1","_randomIndex","_vehicleClass","_hintVehClass","_vehicle","_vehAmmo","_vehDeterminer","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_squads","_CivGrpM1","_CivGrpM2","_randomPos2","_CivGrpM3","_randomPos3","_CivGrpM4","_randomPos4","_CivGrpM5","_randomPos5","_randomPos"];

//Mission Initialization.
_result = 0;
_noSquads = _this select 0;
_missionMarkerName = _this select 1;
_missionType = _this select 2;
_vehicleClass = _this select 3;
_randomPos1 = _this select 4;

_startTime = floor(time);
diag_log format["WASTELAND SERVER - Main Mission Started: %1",_missionType];



_randomPos2 = [(_randomPos1 select 0) + 15, (_randomPos1 select 1) + 15, 0];
_randomPos3 = [(_randomPos1 select 0) + 25, (_randomPos1 select 1) + 25, 0];
_randomPos4 = [(_randomPos1 select 0) + 35, (_randomPos1 select 1) + 35, 0];
_randomPos5 = [(_randomPos1 select 0) + 45, (_randomPos1 select 1) + 45, 0];


switch (_missionType) do
{
    case "Infantry Fighting Vehicle":   { _hintVehClass = "IFV" };
	case "Armored Personnel Carrier":   { _hintVehClass = "APC" };
    default                             { _hintVehClass = _missionType };
};

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
[A3W_mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos1,_missionType] call createClientMarker;

switch (true) do
{
	case (_vehicleClass isKindOf "Heli_Light_01_base_F"):        { _vehAmmo = 0.5 };
	case (_vehicleClass isKindOf "Heli_Transport_01_base_F"):    { _vehAmmo = 0.5 };
	case (_vehicleClass isKindOf "Heli_Attack_01_base_F"):       { _vehAmmo = 0.2 };
	case (_vehicleClass isKindOf "Heli_Light_02_base_F"):        { _vehAmmo = 1 };
	case (_vehicleClass isKindOf "Heli_Attack_02_base_F"):       { _vehAmmo = 0.8 };
    case (_vehicleClass isKindOf "B_APC_Wheeled_01_cannon_F");   { _vehAmmo = 0.5 };
    case (_vehicleClass isKindOf "O_APC_Tracked_02_cannon_F");   { _vehAmmo = 0.5 };
    case (["_GMG_", _vehicleClass] call fn_findString != -1);    { _vehAmmo = 0.5 };
    case (_vehicleClass isKindOf "B_MBT_01_cannon_F"):           { _vehAmmo = 0.5 };
    case (_vehicleClass isKindOf "O_MBT_02_cannon_F"):           { _vehAmmo = 0.5 };
    default { _vehAmmo = 1 };
};

//Vehicle Class, Posistion, Fuel, Ammo, Damage, State
_vehicle = [_vehicleClass,_randomPos1,0,_vehAmmo,0.75,"NONE"] call createMissionVehicle;

switch (_vehicleClass) do
{
	case "B_APC_Wheeled_01_cannon_F":
	{
		_vehicle removeMagazinesTurret ["2000Rnd_65x39_belt", [0]];
		_vehicle addMagazineTurret ["1000Rnd_65x39_belt_Tracer_Red", [0]];
	};
	case "O_APC_Tracked_02_cannon_F":
	{
		_vehicle removeMagazinesTurret ["1000Rnd_65x39_belt", [0]];
		_vehicle addMagazineTurret ["1000Rnd_65x39_belt_Tracer_Red", [0]];
	};
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
	case (_vehicle isKindOf "O_APC_Tracked_02_cannon_F"):
	{
		_vehicle removeMagazinesTurret ["1000Rnd_65x39_belt", [0]];
		_vehicle addMagazineTurret ["1000Rnd_65x39_belt_Tracer_Red", [0]];
	};
	case (_vehicle isKindOf "B_APC_Wheeled_01_cannon_F"):
	{
		_vehicle removeMagazinesTurret ["2000Rnd_65x39_belt", [0]];
		_vehicle addMagazineTurret ["1000Rnd_65x39_belt_Tracer_Red", [0]];
	};
	case (_vehicle isKindOf "B_MBT_01_cannon_F"):
	{
		_vehicle removeMagazinesTurret ["16Rnd_120mm_HE_shells_Tracer_Red", [0]];
		_vehicle removeMagazinesTurret ["2000Rnd_65x39_belt", [0]];
		_vehicle addMagazineTurret ["2000Rnd_65x39_belt", [0]];
		_vehicle addMagazineTurret ["16Rnd_120mm_HE_shells_Tracer_Red", [0]];
	};
	case (_vehicle isKindOf "O_MBT_02_cannon_F"):
	{
		_vehicle removeMagazinesTurret ["16Rnd_120mm_HE_shells_Tracer_Green", [0]];
		_vehicle removeMagazinesTurret ["450Rnd_127x108_Ball", [0,0]];
		_vehicle removeMagazinesTurret ["SmokeLauncherMag", [0,0]];
		_vehicle addMagazineTurret ["16Rnd_120mm_HE_shells_Tracer_Red", [0]];
		_vehicle addMagazineTurret ["450Rnd_127x108_Ball", [0,0]];
		_vehicle addMagazineTurret ["SmokeLauncherMag", [0,0]];
	};
    
    
};

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
_hint = parseText format 
[
	"<t align='center' color='%4' shadow='2' size='1.75'>Main Objective</t><br/>" +
	"<t align='center' color='%4'>------------------------------</t><br/>" +
	"<t align='center' color='%5' size='1.25'>%1</t><br/>" +
	"<t align='center'><img size='5' image='%2'/></t><br/>" +
	"<t align='center' color='%5'>%6 <t color='%4'>%3</t> has been immobilized, go get it for your team.</t>",
	_missionType, _picture, _vehicleName, mainMissionColor, subTextColor, _vehDeterminer
];
[_hint] call hintBroadcast;

if ( _noSquads < 1 ) then {_noSquads = 1;};
if ( _noSquads > 5 ) then {_noSquads = 5;};

_squads = [];

for [{_i = 1},{_i < (_noSquads + 1)},{_i = _i + 1}] do
{

    call compile format ["_CivGrpM%1 = createGroup civilian", _i];
    call compile format ["[_CivGrpM%1,_randomPos%1] spawn createSmallGroup",_i];
    call compile format ["_squads set [count _squads, _CivGrpM%1]", _i];
};
diag_log format["WASTELAND SERVER - Squads array is %1", _squads];

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];
sleep 10;
_unitsAlive = 0;
for [{_i=0}, {_i < count _squads}, {_i=_i+1}] do
{
    _unitsAlive = _unitsAlive + ({alive _x} count units (_squads select _i));
};
diag_log format["WASTELAND SERVER - Main Mission has %1 AI",_unitsAlive];
_startTime = floor(time);
waitUntil
{
    sleep 1; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= A3W_mainMissionTimeout) then {_result = 1;};
    {if((isPlayer _x) AND (_x distance _vehicle <= A3W_missionRadiusTrigger)) then {_playerPresent = true};}forEach playableUnits;
    _unitsAlive = 0;
    for [{_i=0}, {_i < count _squads}, {_i=_i+1}] do
    {
        _unitsAlive = _unitsAlive + ({alive _x} count units (_squads select _i));
    };
    
    if ((damage _vehicle) == 1) then {_result = 1;};
    (_result == 1) OR ((_playerPresent) AND (_unitsAlive < 1))
};

_vehicle setVehicleLock "UNLOCKED";
_vehicle disableTIEquipment true;
_vehicle setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
    if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
    for [{_i=0}, {_i < count _squads}, {_i=_i+1}] do
    {
        {deleteVehicle _x;} forEach units (_squads select _i);
        deleteGroup (_squads select _i);
    };
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>Objective failed, better luck next time.</t>", _missionType, _picture, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
	//Reset the mission spawn bool
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1 - %2 enemy alive - Player present - %3",_missionType, _unitsAlive, _playerPresent];
} else {
	//Mission Complete.

    for [{_i=0}, {_i < count _squads}, {_i=_i+1}] do
    {
        {deleteVehicle _x;}forEach units (_squads select _i);
        deleteGroup (_squads select _i);
    };
    _hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>The %6 has been captured, brace yourselves.</t>", _missionType, _picture, _vehicleName, successMissionColor, subTextColor, _hintVehClass];
	[_hint] call hintBroadcast;

    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};


