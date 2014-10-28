//  @file Version: 0.1
//  @file Name: oFunctions.sqf
//  @file Author: micovery
//  @file Description: Object loading

diag_log "oFunctions.sqf loading ...";

#include "macro.h";

o_strToSide = {
  def(_result);
  _result = switch (toUpper _this) do {
    case "WEST":  { BLUFOR };
    case "EAST":  { OPFOR };
    case "GUER":  { INDEPENDENT };
    case "CIV":   { CIVILIAN };
    case "LOGIC": { sideLogic };
    default       { sideUnknown };
  };
  (_result)
};

o_isBaseSavingOn = {
  (["A3W_baseSaving"] call isConfigOn)
};

o_isStaticWeapon = {
  ARGVX4(0,_obj,objNull,false);
  init(_class,typeOf _obj);
  (_class isKindOf "StaticWeapon")
};

o_isStaticWeaponSavingOn = {
  (["A3W_staticWeaponSaving"] call isConfigOn)
};

o_isBeacon = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["a3w_spawnBeacon", false])
};

o_isBeaconSavingOn = {
  (["A3W_spawnBeaconSaving"] call isConfigOn)
};

o_isBox = {
  ARGVX4(0,_obj,objNull,false);
  init(_class,typeOf _obj);
  (_class isKindOf "ReammoBox_F")
};

o_isBoxSavingOn = {
  (["A3W_boxSaving"] call isConfigOn)
};

o_isWarchest = {
  ARGVX4(0,_obj,objNull,false);
  (
    _obj getVariable ["a3w_warchest", false] && {
    (_obj getVariable ["side", sideUnknown]) in [WEST,EAST]}
  )
};

o_isWarchestSavingOn = {
  (["A3W_warchestSaving"] call isConfigOn)
};

o_isWarchestMoneySavingOn = {
  (["A3W_warchestMoneySaving"] call isConfigOn)
};

o_hasInventory = {
  ARGVX2(0,_arg);
  
  def(_class);
  if (isOBJECT(_arg)) then {
    _class = typeOf _arg;
  };
  
  if (isSTRING(_arg)) then {
    _class = _obj;
  };
  
  if (!isSTRING(_class) || {_class == ""}) exitWith {false};
  
  def(_config);
  _config = (configFile >> "CfgVehicles" >> _class);

  (isClass _config && {
   getNumber (_config >> "transportMaxWeapons") > 0 ||
   getNumber (_config >> "transportMaxMagazines") > 0 ||
   getNumber (_config >> "transportMaxBackpacks") > 0})
};
         
o_isSaveable = {
  //diag_log format["%1 call o_isSaveable", _this];
  ARGVX4(0,_obj,objNull,false);

  init(_class, typeOf _obj);

  if (!(alive _obj)) exitWith {false};
  if ([_obj] call o_isVehicle) exitWith {false};
  if ([_obj] call o_isInSaveList) exitWith {true};


  init(_boxSavingOn, call o_isBoxSavingOn);

  if ([_obj] call o_isBeacon) exitWith {
    //diag_log format["box5(%1): o_isBeaconSavingOn = %2", _obj, (call o_isBeaconSavingOn)];
    (call o_isBeaconSavingOn)
  };
  
  if ([_obj] call o_isWarchest) exitWith {
    //diag_log format["box4(%1): o_isWarchestSavingOn = %2", _obj, (call o_isWarchestSavingOn)];
    (call o_isWarchestSavingOn)
  };
  
  if ([_obj] call o_isStaticWeapon) exitWith {
    //diag_log format["box3(%1): o_isStaticWeaponSavingOn = %2", _obj, (call o_isStaticWeaponSavingOn)];
    (call o_isStaticWeaponSavingOn)
  };

  def(_locked);
  _locked = _obj getVariable ["objectLocked", false];

  if ([_obj] call o_isBox) exitWith {
    //diag_log format["box2(%1): _boxSavingOn = %2, _locked = %3", _obj, _boxSavingOn, _locked];
    (_boxSavingOn && {_locked})
  };

  //diag_log format["box1(%1): _boxSavingOn = %2, _locked = %3",_obj, _boxSavingOn, _locked];
  (_boxSavingOn && {_locked})
};

o_isVehicle = {
  ARGVX4(0,_obj,objNull,false);
  
  init(_result, false);
  {
    if (_obj isKindOf _x) exitWith {
      _result = true;
    };
  } forEach ["Helicopter", "Plane", "Boat_F", "Car", "Motorcycle", "Tank", "StaticWeapon"];
  
  (_result)
};

o_isAlwaysUnlocked = {
  ARGVX4(0,_obj,objNull, false);
  
  def(_result);
  _result = switch (true) do {
    case ([_obj] call o_isWarchest): { true };
    case ([_obj] call o_isBeacon): {true};
    default { false };
  };
  
  (_result)
};

o_maxLifetime = ["A3W_objectLifetime", 0] call getPublicVar;

o_restoreObject = {_this spawn {
  //diag_log format["%1 call o_restoreObject", _this];
  ARGVX3(0,_data_pair,[]);
  
  _this = _data_pair;
  ARGVX3(0,_object_key,"");
  ARGVX2(1,_object_hash);
  
  if (!isCODE(_object_hash)) exitWith {};
  
  def(_object_data);
  _object_data =  call _object_hash;
  //diag_log _object_data;
  
  def(_hours_alive);
  def(_pos);
  def(_class);
  def(_dir);
  def(_damage);
  def(_allowDamage);
  def(_texture);
  def(_variables);
  def(_cargo_weapons);
  def(_cargo_magazines);
  def(_cargo_backpacks);
  def(_cargo_items);
  def(_cargo_ammo);
  def(_cargo_fuel);
  def(_cargo_repair);
  def(_turret_magazines);

  def(_key);
  def(_value);
  
  {
    _key = _x select 0;
    _value = _x select 1;
    switch (_key) do {
      case "Class": { _class = OR(_value,nil);};
      case "Position": { _pos = OR(_value,nil);};
      case "Direction": { _dir = OR(_value,nil);};
      case "Damage": { _damage = OR(_value,nil);};
      case "AllowDamage": { _allowDamage = OR(_value,nil);};
      case "Texture": { _texture = OR(_value,nil);};
      case "Weapons": { _cargo_weapons = OR(_value,nil);};
      case "Items": { _cargo_items = OR(_value,nil);};
      case "Magazines": { _cargo_magazines = OR(_value,nil);};
      case "Backpacks": { _cargo_backpacks = OR(_value,nil);};
      case "AmmoCargo": { _cargo_ammo = OR(_value,nil);};
      case "FuelCargo": { _cargo_fuel = OR(_value,nil);};
      case "RepairCargo": { _cargo_repair = OR(_value,nil);};
      case "HoursAlive": { _hours_alive = OR(_value,nil);};
      case "Variables": { _variables = OR(_value,nil);};
      case "TurretMagazines": { _turret_magazines = OR(_value,nil);};
    };
  } forEach _object_data;

  //if there is no class and position, there is no point to recreating the object
  if (not(isSTRING(_class)) || {not(isARRAY(_pos))}) exitWith {
    diag_log format["No class or position available for object: %1", _object_key];
  };
  
  diag_log format["%1(%2) is being restored.", _object_key, _class];

  if (o_maxLifetime <= 0 || {_hours_alive > o_maxLifetime}) exitWith {
    diag_log format["%1(%2) has exceeded max lifetime, skipping it", _object_key, _class];
  };
  
  def(_obj);
  _obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
  _obj allowDamage false; //set damage to false immediately to avoid taking fall damage
  if (!isOBJECT(_obj)) exitWith {
    diag_log format["%1(%2) could not be created.", _object_key, _class];
  };
  
  _obj setVariable ["object_key", _object_key, true];
  
  //restore the variables for the object
  if (isARRAY(_variables)) then {
    def(_name);
    def(_value);
    {
      _name = _x select 0;
      _value = _x select 1;
      
      if (!isNil "_value") then {
        switch (_name) do {
          case "R3F_Side": { _value = _value call o_strToSide};
          case "side": { _value = _value call o_strToSide};
        };  
      };

      _obj setVariable [_name, OR(_value,nil), true];
    } forEach _variables;
  };
  
  _obj setVariable ["objectLocked", true, true]; // force lock

  if (not([_obj] call o_isSaveable)) exitWith {
    diag_log format["%1(%2) has been deleted, it is not saveable", _object_key, _class];
    deleteVehicle _obj;
  };

  
  _obj setPosWorld ATLtoASL _pos;
  if (isARRAY(_dir)) then {
    _obj setVectorDirAndUp _dir;
  };
  
  _obj setVariable ["baseSaving_spawningTime", diag_tickTime];
  if (isSCALAR(_hours_alive)) then {
    _obj setVariable ["baseSaving_hoursAlive", _hours_alive];
  };
  

  if (isSCALAR(_damage)) then {
    _obj setDamage _damage;
  };
  
  _allowDamage = if(isSCALAR(_allowDamage) && {_allowDamage <= 0}) then { false } else { true };
  [_obj, _allowDamage] spawn {
    ARGVX3(0,_obj,objNull);
    ARGVX3(1,_allowDamage,false);
    //delay the allow damage to allow the box to settle
    sleep 5;
  _obj setVariable ["allowDamage", _allowDamage];
  _obj allowDamage _allowDamage;
  };

  //broadcast the spawn beacon
  if ([_obj] call o_isBeacon) then {
    pvar_spawn_beacons pushBack _obj;
    publicVariable "pvar_spawn_beacons";
  };
  
  //restore the stuff inside the object  
  clearWeaponCargoGlobal _obj;
  clearMagazineCargoGlobal _obj;
  clearItemCargoGlobal _obj;
  clearBackpackCargoGlobal _obj;
  _obj setVehicleAmmo 0;
          
  if (isARRAY(_cargo_weapons)) then {
    { _obj addWeaponCargoGlobal _x } forEach _cargo_weapons;
  };
  
  if (isARRAY(_cargo_backpacks)) then {
    { 
      if (isARRAY(_x) && {not((_x select 0) isKindOf "Weapon_Bag_Base")}) then {
        _obj addBackpackCargoGlobal _x 
      };
    } forEach _cargo_backpacks;
  };
  
  if (isARRAY(_cargo_items)) then {
    { _obj addItemCargoGlobal _x } forEach _cargo_items;
  };
  
  if (isARRAY(_cargo_magazines)) then {
    { _obj addMagazineCargoGlobal _x } forEach _cargo_magazines;
  };
  
  if (isARRAY(_turret_magazines)) then {
    { _obj addMagazine _x } forEach _turret_magazines;
  };
  
  if (isSCALAR(_cargo_ammo)) then {
    _obj setAmmoCargo _cargo_ammo;
  };
  
  if (isSCALAR(_cargo_fuel)) then {
    _obj setFuelCargo _cargo_fuel;
  };
  
  if (isSCALAR(_cargo_repair)) then {
    _obj setRepairCargo _cargo_repair;
  };
    
  //some objects need to be always unlocked
  def(_unlocked);
  _unlocked = [_obj] call o_isAlwaysUnlocked;
  if (_unlocked) then {
    _obj setVariable ["objectLocked", false, true];
  }
  else {
    (locked_objects_list pushBack _obj);
  };

};};



//pre-define a list of objects that can be saved
o_saveList = [];
{if (true) then {

  if (not(call o_isBaseSavingOn)) exitWith {};
  def(_obj);
  _obj = _x select 1;
  
  if (!isOBJECT(_obj)) exitWith {};
  if (_obj isKindOf "ReammoBox_F") exitWith {};
  if ((o_saveList find _obj) >= 0) exitWith {};
  
  o_saveList pushBack _obj;
};} forEach [objectList, call genObjectsArray];


o_isInSaveList = {
  ARGVX4(0,_obj,objNull,false);
  ((o_saveList find _obj) >= 0)
};

o_fillVariables = {
  ARGVX3(0,_obj,objNull);
  ARGVX3(1,_variables,[]);
  
  if (_obj isKindOf "Land_Sacks_goods_F") then {
    _variables pushBack ["food", _obj getVariable ["food", 20]];
  };
  
  if (_obj isKindOf "Land_BarrelWater_F") then {
    _variables pushBack ["water", _obj getVariable ["water", 20]];
  };
  
  def(_ownerUID);
  _ownerUID = _obj getVariable "ownerUID";
  if (isSTRING(_ownerUID)) then {
    _variables pushBack ["ownerUID", _ownerUID];
  };

  def(_ownerN);
  _ownerN = _obj getVariable "ownerN";
  if (isSTRING(_ownerN)) then {
    _variables pushBack ["ownerN", _ownerN];
  };
  
  if ([_obj] call o_isBox) then {
    _variables pushBack ["cmoney", _obj getVariable ["cmoney", 0]];
  };
  
  if ([_obj] call o_isWarchest) then {
    _variables pushBack ["a3w_warchest", true];
    _variables pushBack ["R3F_LOG_disabled", true];
    _variables pushBack ["side", str (_obj getVariable ["side", sideUnknown])];
  };
  
  if ([_obj] call o_isBeacon) then {
    _variables pushBack ["a3w_spawnBeacon", true];
    _variables pushBack ["R3F_LOG_disabled", true];
    _variables pushBack ["side", str(_obj getVariable ["side", sideUnknown])];
    _variables pushBack ["packing", false];
    _variables pushBack ["groupOnly", _obj getVariable ["groupOnly", false]];
    _variables pushBack ["ownerName", _obj getVariable ["ownerName", "[Beacon]"]];
  };

  def(_r3fSide);
  _r3fSide = _obj getVariable "R3F_Side";
  if (!isNil "_r3fSide" && {typeName _r3fSide == typeName sideUnknown}) then {
    _variables pushBack ["R3F_Side", str _r3fSide];
  };  
};

o_addSaveObject = {
  ARGVX3(0,_list,[]);
  ARGVX3(1,_obj,objNull);
  

  if (not([_obj] call o_isSaveable)) exitWith {};

  //diag_log format["will save %1", _obj];
  def(_class);
  def(_netId);
  def(_pos);
  def(_dir);
  def(_damage);
  def(_allowDamage);

  _class = typeOf _obj;
   _netId = netId _obj;
  _pos = ASLtoATL getPosWorld _obj;
  _dir = [vectorDir _obj, vectorUp _obj];
  _damage = damage _obj;
  _allowDamage = if (_obj getVariable ["allowDamage", false]) then { 1 } else { 0 };
 
 
  def(_spawnTime);
  def(_hoursAlive);
  _spawnTime = _obj getVariable "baseSaving_spawningTime";
  _hoursAlive = _obj getVariable "baseSaving_hoursAlive";
  
  if (isNil "_spawnTime") then {
    _spawnTime = diag_tickTime;
    _obj setVariable ["baseSaving_spawningTime", _spawnTime, true];
  };
  
  if (isNil "_hoursAlive") then {
    _hoursAlive = 0;
    _obj setVariable ["baseSaving_hoursAlive", _hoursAlive, true];  
  };
  
  def(_totalHours);
  _totalHours = _hoursAlive + (diag_tickTime - _spawnTime) / 3600;
 
  
  init(_variables,[]);
  [_obj,_variables] call o_fillVariables;
 
 
  init(_weapons,[]);
  init(_magazines,[]);
  init(_items,[]);
  init(_backpacks,[]);
  
  if ([_obj] call o_hasInventory) then {
    // Save weapons & ammo
    _weapons = (getWeaponCargo _obj) call cargoToPairs;
    _magazines = (getMagazineCargo _obj) call cargoToPairs;
    _items = (getItemCargo _obj) call cargoToPairs;
    _backpacks = (getBackpackCargo _obj) call cargoToPairs;
  };
  
  init(_turretMags,[]);
  if ((call o_isStaticWeaponSavingOn) && {[_obj] call o_isStaticWeapon}) then {
    _turretMags = magazinesAmmo _obj;
  };

  init(_ammoCargo,getAmmoCargo _obj);
  init(_fuelCargo,getFuelCargo _obj);
  init(_repairCargo,getRepairCargo _obj);
  
  
  def(_objName);
  _objName = _obj getVariable "object_key";

  if (!isSTRING(_objName) || {_objName == ""}) then {
    _objName = format["obj_%1_%2",ceil(time), ceil(random 10000)];
    _obj setVariable ["object_key", _objName, true];
  };

  _list pushBack [_objName, ([
    ["Class", _class],
    ["Position", _pos],
    ["Direction", _dir],
    ["HoursAlive", _totalHours],
    ["Damage", _damage],
    ["AllowDamage", _allowDamage],
    ["Variables", _variables],
    ["Texture", _texture],
    ["Weapons", _weapons],
    ["Magazines", _magazines],
    ["Items", _items],
    ["Backpacks", _backpacks],
    ["TurretMagazines", _turretMags],
    ["AmmoCargo", _ammoCargo],
    ["FuelCargo", _fuelCargo],
    ["RepairCargo", _repairCargo]
  ] call sock_hash)];

  true
};


o_saveInfo = {
  ARGVX3(0,_scope,"");
  
  init(_fundsWest,0);
  init(_fundsEast,0);
  
  init(_request,[_scope]);
  
  if (call o_isWarchestMoneySavingOn) then {
    _fundsWest = ["pvar_warchest_funds_west", 0] call getPublicVar;
    _fundsEast = ["pvar_warchest_funds_east", 0] call getPublicVar;
  };
  
  init(_objName, "Info");
  _request pushBack [ _objName + "." + "WarchestMoneyBLUFOR", _fundsWest];
  _request pushBack [ _objName + "." + "WarchestMoneyOPFOR", _fundsEast];
  
  _request call stats_set;  
};  


o_saveAllObjects = {
  ARGVX3(0,_scope,"");
  init(_count,0);
  init(_request,[_scope]);
  
  [_scope] call stats_wipe;
  init(_bulk_size,100);
  init(_start_time, diag_tickTime);
  init(_last_save, diag_tickTime);


  {
    if (!isNil{[_request, _x] call o_addSaveObject}) then {
      _count = _count + 1;
    };
    
    //save objects in bulks
    if ((_count % _bulk_size) == 0 && {count(_request) > 1}) then {
      init(_save_start, diag_tickTime);
      _request call stats_set;
      init(_save_end, diag_tickTime);
      _request = [_scope];
      diag_log format["o_saveLoop: %1 objects saved in %2 ticks, save call took %3 ticks", (_bulk_size), (diag_tickTime - _start_time), (_save_end - _save_start)];
      _last_save = _save_end;
    };
  } forEach (locked_objects_list);
  
  if (count(_request) > 1) then {
    init(_save_start, diag_tickTime);
    _request call stats_set;
    init(_save_end, diag_tickTime);
    diag_log format["o_saveLoop: %1 objects saved in %2 ticks, save call took %3 ticks", (count(_request) -1), (_save_end - _last_save), (_save_end - _save_start)];
  };

  diag_log format["o_saveLoop: total of %1 objects saved in %2 ticks", (_count), (diag_tickTime - _start_time)];

  call o_lockedObjectsListCleanup;
};

o_lockedObjectsListCleanup = {

  //post cleanup the array
  init(_cleanup_start, diag_tickTime);
  init(_nulls,[]);
  init(_index,-1);
  init(_start_size,count(locked_objects_list));
  while {true} do {
    _index = locked_objects_list find objNull;
    if (_index < 0) exitWith {};
    locked_objects_list deleteAt _index;
  };
  init(_end_size,count(locked_objects_list));
  init(_cleanup_end, diag_tickTime);
  diag_log format["o_saveLoop: count(locked_objects_list) = %1, %2 nulls deleted in %3 ticks", count(locked_objects_list), (_start_size - _end_size), (_cleanup_end - _cleanup_start)];
};


locked_objects_list = [];

o_getLockedObjectIndex = {
  ARGVX4(0,_obj,objNull,-1);
  if (isNull _obj) exitWith {-1};

  (locked_objects_list find _obj)
};

//event handlers for object locking and unlocking
"objectLocked" addPublicVariableEventHandler {
  private["_index","_object"];
  _object = _this select 1;
  _index = [OR(_object,nil)] call o_getLockedObjectIndex;
  if (_index >= 0) exitWith {};

  //diag_log format["%1 is being added to the lock list", _object];
  locked_objects_list pushBack _object;
};


"objectUnlocked" addPublicVariableEventHandler {
  private["_index","_object"];
  _object = _this select 1;
  _index = [OR(_object,nil)] call o_getLockedObjectIndex;
  if (_index < 0) exitWith {};

  //diag_log format["%1 is being removed from the lock list", _object];
  locked_objects_list deleteAt _index;
};



o_saveLoop_interval = OR(A3W_object_saveInterval,60);
diag_log format["config: A3W_object_saveInterval = %1", o_saveLoop_interval];

o_saveLoop = {
  ARGVX3(0,_scope,"");
  while {true} do {
    sleep o_saveLoop_interval;
    if (not(isBOOLEAN(o_saveLoopActive) && {!o_saveLoopActive})) then {
      diag_log format["saving all objects"];
      [_scope] call o_saveInfo;
      [_scope] call o_saveAllObjects;
    };
  };
};

o_loadInfoPair = {
  ARGVX3(0,_name,"");
  ARGV2(1,_value);
  
  init(_warchestSavingOn, call o_isWarchestMoneySavingOn);
  
  if (_warchestSavingOn && _name == "WarchestMoneyBLUFOR" && {isSCALAR(_value)}) exitWith {
    pvar_warchest_funds_west = _value;
    publicVariable "pvar_warchest_funds_west";
  };
  
  if (_warchestSavingOn && _name == "WarchestMoneyOPFOR" && {isSCALAR(_value)}) exitWith {
    pvar_warchest_funds_east = _value;
    publicVariable "pvar_warchest_funds_east";
  };
};

o_loadInfo = {
  ARGVX3(0,_scope,"");
  
  def(_info);
  _info = [_scope, "Info"] call stats_get;
  
  def(_info_pairs);
  _info_pairs = [OR(_info,nil)] call stats_hash_pairs;
  
  diag_log "_info_pairs";
  diag_log _info_pairs;
  
  def(_name);
  def(_value);
  {
    _name = _x select 0;
    _value = _x select 1;
    [_name,OR(_value,nil)] call o_loadInfoPair;
 
  } forEach _info_pairs;
};

o_loadObjects = {
  ARGVX3(0,_scope,"");
  
  def(_objects);
  _objects = [_scope] call stats_get;
  
  //nothing to load
  if (!isARRAY(_objects)) exitWith {};

  diag_log format["A3Wasteland - will restore %1 objects", count(_objects)];
  { 
    [_x] call o_restoreObject;
  } forEach _objects;
};

diag_log "oFunctions.sqf loading complete";