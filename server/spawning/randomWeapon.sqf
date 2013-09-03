//	@file Version: 1.0
//	@file Name: randomWeapon.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args: Element 0 = Vehicle.

if(!X_Server) exitWith {};

private ["_car","_mags","_rnd","_weapon","_mag"];

//Grabs carname from array in execVM
_car = _this select 0;
_additionArray = vehicleAddition;
if (random 1 < 0.75) then { _car addWeaponCargoGlobal ["Binocular", 1]};
//if (random 1 < 0.15) then { _car addItemCargoGlobal ["NVGoggles", 1]};

//Get Random Gun From randomWeapons Array.
_weapon = vehicleWeapons call BIS_fnc_selectRandom;
_mag = (getArray (configFile >> "Cfgweapons" >> _weapon >> "magazines")) select 0;

_additionOne = _additionArray call BIS_fnc_selectRandom;
_additionArray = _additionArray - [_additionOne];
_additionTwo = _additionArray call BIS_fnc_selectRandom;
_additionArray = _additionArray - [_additionTwo];
_additionThree = vehicleAddition2 call BIS_fnc_selectRandom;

//Add guns and magazines, note the Global at the end..
_car addMagazineCargoGlobal [_mag,1];
_car addMagazineCargoGlobal [_mag,3];
_car addWeaponCargoGlobal [_weapon,1];
_car addItemCargoGlobal [_additionOne,2];
_car addItemCargoGlobal [_additionTwo,2];
_car addMagazineCargoGlobal [_additionThree,2];
