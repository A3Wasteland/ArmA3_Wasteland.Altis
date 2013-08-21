//	@file Version: 1.1
//	@file Name: boatCreation.sqf
//	@file Author: [GoT] JoSchaap
//	@file Created: 20/11/2012 05:19
//	@file Args: markerPos [, carType]

if(!X_Server) exitWith {};

private ["_markerPos","_pos","_type","_boattype","_boat"];

_markerPos = _this select 0;

_boattype = BoatList call BIS_fnc_selectRandom; 
_type = 3;
_pos = [_markerPos, 1, 15, 5, 2, 60 * (pi / 180), 0, [], [[], _markerPos]] call BIS_fnc_findSafePos;

//Car Initialization
_boat = createVehicle [_boattype,_pos, [], 0, "None"];
[_boat, 60, 190, 0, false, _markerPos, """R3F_LOG_disabled"",false"] execVM "server\functions\vehicle.sqf";

//Clear Cars Inventory
clearMagazineCargoGlobal _boat;
clearWeaponCargoGlobal _boat;

//Set Cars Attributes
_boat setFuel (0.80);
_boat setDamage (random 0.30);

_boat setDir (random 360);
_boat disableTIEquipment true;

//Set original posistion then add to vehicle array
_boat setVariable [call vChecksum, true, false]; 
_boat setPosASL [getpos _boat select 0,getpos _boat select 1,0];
_boat setVelocity [0,0,0];
