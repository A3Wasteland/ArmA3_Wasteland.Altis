//	@file Name: c_applyPlayerData.sqf
//	@file Author: AgentRev

// This is where you load player status & inventory data which will be wiped upon death, for persistent variables use c_applyPlayerInfo.sqf instead

#include "macro.h"

if (isDedicated) exitWith {};

init(_data,_this);

#include "functions.sqf"

def(_loaded_magazines);
def(_backpack_class);
def(_backpack_weapons);
def(_backpack_items);
def(_backpack_magazines);
def(_partial_magazines);
def(_primary_weapon);
def(_secondary_weapon);
def(_handgun_weapon);
def(_uniform_class);
def(_vest_class);

//iterate through the data, and extract the hash variables into local variables
{
  init(_name,_x select 0);
  init(_value,_x select 1);

  switch (_name) do {
    case "Backpack": { _backpack_class = _value;};
    case "LoadedMagazines": { _loaded_magazines = _value; };
    case "BackpackWeapons": { _backpack_weapons = _value};
    case "BackpackItems": { _backpack_items = _value; };
    case "BackpackMagazines": { _backpack_magazines = _value };
    case "PrimaryWeapon": { _primary_weapon = _value };
    case "SecondaryWeapon": {_secondary_weapon = _value};
    case "HandgunWeapon": { _handgun_weapon = _value};
    case "Uniform":{ _uniform_class = _value};
    case "Vest": { _vest_class = _value};
  };
} forEach _data;

//Restore the weapons, backpack, uniform, and vest in correct order
player addBackpack "B_Carryall_Base"; // add a temporary backpack for holding loaded weapon magazines
[OR(_loaded_magazines,nil)] call _restoreLoadedMagazines;  
[OR(_primary_weapon,nil)] call _restorePrimaryWeapon;
[OR(_secondary_weapon,nil)] call _restoreSecondaryWeapon;
[OR(_handgun_weapon,nil)] call _restoreHandgunWeapon;
removeBackpack player;  //remove the temporary backpack

//Restore backpack, and stuff inside
if (isSTRING(_backpack_class) && {_backpack_class != ""}) then {
  diag_log format["Resting backpack: %1", _backpack_class];
  [_backpack_class] call _restoreBackpack;
  
  //restore the stuff inside the backpack
  [OR(_backpack_weapons,nil)] call _restoreBackpackWeapons;
  [OR(_backpack_magazines,nil)] call _restoreBackpackMagazines;
  [OR(_backpack_items,nil)] call _restoreBackpackItems;
};

[OR(_uniform_class,nil)] call _restoreUniform;
[OR(_vest_class,nil)] call _restoreVest;

//restore other stuff that is not order-dependent
def(_name);
def(_value);
{
  _name = _x select 0;
  _value = _x select 1;
	
  switch (_name) do {
    case "Damage": { player setDamage _value };
    case "HitPoints": { { player setHitPointDamage _x } forEach _value };
    case "Hunger": { hungerLevel = _value };
    case "Thirst": { thirstLevel = _value };
    case "Money": { player setVariable ["cmoney", _value, true] };
    case "Position": { if (count _value == 3) then { player setPosATL _value } };
    case "Direction": { player setDir _value };
    case "Goggles": { if (_value != "") then { player addGoggles _value } };
    case "Headgear": {
      // If wearing one of the default headgears, give the one belonging to actual team instead
      if (_value != "") then {
        _defHeadgear = [player, "headgear"] call getDefaultClothing;
	    _defHeadgears =
        [
          [typeOf player, "headgear", BLUFOR] call getDefaultClothing,
  		  [typeOf player, "headgear", OPFOR] call getDefaultClothing,
          [typeOf player, "headgear", INDEPENDENT] call getDefaultClothing
        ];

        if (_value != _defHeadgear && {_defHeadgear != ""} && {{_value == _x} count _defHeadgears > 0}) then {
          player addHeadgear _defHeadgear;
        }
        else
        {
          player addHeadgear _value;
        };
      };
    };
    case "PrimaryWeaponItems": { { if (_x != "") then { player addPrimaryWeaponItem _x } } forEach _value };
    case "SecondaryWeaponItems": { { if (_x != "") then { player addSecondaryWeaponItem _x } } forEach _value };
    case "HandgunItems": { { if (_x != "") then { player addHandgunItem _x } } forEach _value };
    case "AssignedItems": {
      {
        if ([player, _x] call isAssignableBinocular) then {
          player addWeapon _x;
        }
        else {
          player linkItem _x;
        };
      } forEach _value;
    };
    case "CurrentWeapon": { player selectWeapon _value };
    case "Stance": { [player, [player, _value] call getFullMove] call switchMoveGlobal };
    case "UniformWeapons": { { (uniformContainer player) addWeaponCargoGlobal _x } forEach _value };
    case "UniformItems": { { (uniformContainer player) addItemCargoGlobal _x } forEach _value };
    case "UniformMagazines": { { (uniformContainer player) addMagazineCargoGlobal _x } forEach _value };
    case "VestWeapons": { { (vestContainer player) addWeaponCargoGlobal _x } forEach _value };
    case "VestItems": { { (vestContainer player) addItemCargoGlobal _x } forEach _value };
    case "VestMagazines": { { (vestContainer player) addMagazineCargoGlobal _x } forEach _value };
    case "PartialMagazines": { { player addMagazine _x } forEach _value };
    case "WastelandItems": { { [_x select 0, _x select 1, true] call mf_inventory_add } forEach _value };
  };
} forEach _data;

