// Cargo drop script.
// Created by MarKeR - Helo and assistance from F2k Sel. Much obliged.
// For Use - Anyone, just leave these lines in here please. Thanks

// Cargo drop script used by 404Games with permission from [OCUK] MarKeR.
// Modifications made by [404] Costlyy
#include "mainMissionDefines.sqf";

if(!isServer) exitwith {};

private [];

_result = 0;
_missionType = "C130 Supply Drop";
_missionMarkerName = "SupplyDrop_Marker";
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

//Start Mission
_vehicleClass = "C130J_US_EP1";

//Vehicle Class, Posistion, Fuel, Ammo, Damage, State
_vehicle = [_vehicleClass,getMarkerPos "plane2",1,1,0,"FLY"] call createMissionVehicle;
_vehicle flyInHeight 300;
_vehicle setspeedmode "normal";
_vehicle forceSpeed 220;

sleep 0.5;
_grp = creategroup civilian;

_pilot = _grp createunit ["Pilot_EP1",getmarkerpos "spawn2",[],0,"FORM"];
_pilot moveindriver _vehicle;
_pilot assignAsDriver _vehicle;
_pilot addMagazine "6Rnd_45ACP";
_pilot addMagazine "6Rnd_45ACP";
_pilot addMagazine "6Rnd_45ACP";
_pilot addWeapon "revolver_gold_EP1";
group _pilot Move _randomPos;
                                    
_picture = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "picture");
_vehicleName = getText (configFile >> "cfgVehicles" >> typeOf _vehicle >> "displayName");
_hint = parseText format ["<t align='center' color='%4' shadow='2' size='1.75'>UN Supply Drop</t><br/><t align='center' color='%4'>------------------------------</t><br/><t align='center' color='%5' size='1.25'>%1</t><br/><t align='center'><img size='5' image='%2'/></t><br/><t align='center' color='%5'>A<t color='%4'> %3</t>, has been designated to fly in supplies.</t>", _missionType, _picture, _vehicleName, mainMissionColor, subTextColor];
[_hint] call hintBroadcast;

[_vehicle,_randomPos,_picture,_vehicleName,_missionType] call createSupplyDrop;

//End Mission
deletevehicle _vehicle;
deletevehicle _pilot;

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
