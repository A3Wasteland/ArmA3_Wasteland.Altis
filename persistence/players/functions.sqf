//	@file Version: 1.2
//	@file Name: oLoad.sqf
//	@file Author: micovery
//	@file Description: Utility functions for player stats

#include "macro.h"

def(_resetPlayerData);
_resetPlayerData = {
  removeAllWeapons player;
  removeAllAssignedItems player;
  removeUniform player;
  removeVest player;
  removeBackpack player;
  removeGoggles player;
  removeHeadgear player;
};

def(_restoreBackpack);
_restoreBackpack = {
  ARGVX3(0,_value,"");
  removeBackpack player;

  if (_value == "") exitWith {};
  
  if (_value isKindOf "Weapon_Bag_Base") exitWith {
	player addBackpack "B_AssaultPack_rgr"; // NO SOUP FOR YOU
  };
  
  player addBackpack _value;
};


def(_restoreBackpackWeapons);
_restoreBackpackWeapons = {
  ARGVX3(0,_value,[]);
 { (backpackContainer player) addWeaponCargoGlobal _x } forEach _value 
};

def(_restoreBackpackItems);
_restoreBackpackItems = {
  ARGVX3(0,_value, []);
  { (backpackContainer player) addItemCargoGlobal _x } forEach _value
};

def(_restoreBackpackMagazines);
_restoreBackpackMagazines = {
  ARGVX3(0,_value,[]);
  { (backpackContainer player) addMagazineCargoGlobal _x } forEach _value
};

def(_restorePrimaryWeapon);
_restorePrimaryWeapon = {
  ARGVX3(0,_value,"");
  player addWeapon _value; removeAllPrimaryWeaponItems player;
};

def(_restoreSecondaryWeapon);
_restoreSecondaryWeapon = {
  ARGVX3(0,_value,"");
  player addWeapon _value;
};

def(_restoreHandgunWeapon);
_restoreHandgunWeapon = {
  //diag_log format["%1 call _restoreHandgunWeapon", _this];
  ARGVX3(0,_value,"");
  player addWeapon _value; removeAllHandgunItems player;
};

def(_restoreLoadedMagazines);
_restoreLoadedMagazines = {
  ARGVX3(0,_value,[]);
 { player addMagazine _x } forEach _value;		
};

def(_restoreUniform);
_restoreUniform = {
  ARGV3(0,_value,"");
  if (_value == "") exitWith {};
   
  if (player isUniformAllowed _value) exitWith {
	player addUniform _value;
  };
  
  // If uniform cannot be worn by player due to different team, try to convert it, else give default instead
  def(_newUniform);
  _newUniform = [player, _value] call uniformConverter;

  if (player isUniformAllowed _newUniform) exitWith {
    player addUniform _newUniform;
  };
  
  player addUniform ([player, "uniform"] call getDefaultClothing);
};

def(_restoreVest);
_restoreVest = {
  ARGVX3(0,_value,"");
  if (_value == "") exitWith {};
  player addVest _value;
};

