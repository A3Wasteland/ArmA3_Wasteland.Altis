//	@file Version: 1.0
//	@file Name: randomWeapon.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args: Element 0 = Vehicle.

if (!isServer) exitWith {};

private ["_car","_mags","_rnd","_weapon","_mag"];

//Grabs carname from array in execVM
_car = _this select 0;
_additionArray = vehicleAddition;
if (random 1 < 0.45) then { _car addWeaponCargoGlobal ["Binocular", 1]};
// if (random 1 < 0.15) then { _car addItemCargoGlobal ["NVGoggles", 1]};

//Get Random Gun From randomWeapons Array.
_weapon = vehicleWeapons call BIS_fnc_selectRandom;
_mag = ((getArray (configFile >> "Cfgweapons" >> _weapon >> "magazines")) select 0) call getBallMagazine;

_additionOne = _additionArray call BIS_fnc_selectRandom;
_additionArray = _additionArray - [_additionOne];
_additionTwo = _additionArray call BIS_fnc_selectRandom;
_additionArray = _additionArray - [_additionTwo];
_additionThree = vehicleAddition2 call BIS_fnc_selectRandom;

//Add guns and magazines, note the Global at the end
//add a probability of 50% of a vehicle getting a gun or some more additional loot instead
if (random 1 < 0.5) then {
	_car addWeaponCargoGlobal [_weapon,1];
	_car addMagazineCargoGlobal [_mag,(2 + floor(random 3))];  //incase a weapon spawns it will have a random amount of mags
} else {
	_car addItemCargoGlobal [_additionTwo,1];
	_car addMagazineCargoGlobal [_additionThree,1];
};
_car addItemCargoGlobal [_additionOne,1];