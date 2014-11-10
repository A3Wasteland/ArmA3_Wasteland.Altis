diag_log "vFunctions.sqf loading ...";

#include "macro.h"

call compile preProcessFileLineNumbers "persistence\lib\shFunctions.sqf";



v_restoreVehicle = {_this spawn {
  //diag_log format["%1 call v_restoreVehicle", _this];
  ARGVX3(0,_data_pair,[]);

  _this = _data_pair;
  ARGVX3(0,_vehicle_key,"");
  ARGVX2(1,_vehicle_hash);

  if (!isCODE(_vehicle_hash)) exitWith {};

  def(_vehicle_data);
  _vehicle_data =  call _vehicle_hash;
  //diag_log _vehicle_data;


  def(_hours_alive);
  def(_hours_abandoned);
  def(_pos);
  def(_class);
  def(_dir);
  def(_damage);
  def(_texture);
  def(_variables);
  def(_cargo_weapons);
  def(_cargo_magazines);
  def(_cargo_backpacks);
  def(_cargo_items);
  def(_turret_magazines);
  def(_cargo_ammo);
  def(_cargo_fuel);
  def(_cargo_repair);
  def(_fuel);
  def(_hitPoints);



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
      case "Weapons": { _cargo_weapons = OR(_value,nil);};
      case "Items": { _cargo_items = OR(_value,nil);};
      case "Magazines": { _cargo_magazines = OR(_value,nil);};
      case "Backpacks": { _cargo_backpacks = OR(_value,nil);};
      case "HoursAlive": { _hours_alive = OR(_value,nil);};
      case "HoursAbandoned": { _hours_abandoned = OR(_value,nil);};
      case "Variables": { _variables = OR(_value,nil);};
      case "AmmoCargo": { _cargo_ammo = OR(_value,nil);};
      case "FuelCargo": { _cargo_fuel = OR(_value,nil);};
      case "RepairCargo": { _cargo_repair = OR(_value,nil);};
      //case "TurretMagazines": { _turret_magazines = OR(_value,nil);};
      case "Fuel": { _fuel = OR(_value,nil);};
      case "Hitpoints": { _hitPoints = OR(_value,nil);};
    };
  } forEach _vehicle_data;

  //if there is no class and position, there is no point to recreating the vehicle
  if (not(isSTRING(_class)) || {not(isARRAY(_pos))}) exitWith {
    diag_log format["No class or position available for vehicle: %1", _vehicle_key];
  };

  //AgentRev changed how position is saved, put this fail-safe to handle position with values as strings
  { if (isSTRING(_x)) then { _pos set [_forEachIndex, parseNumber _x] } } forEach _pos;

  diag_log format["%1(%2) is being restored.", _vehicle_key, _class];


  if (isSCALAR(_hours_alive) && {A3W_vehicleLifetime > 0 && {_hours_alive > A3W_vehicleLifetime}}) exitWith {
    diag_log format["vehicle %1(%2) has been alive for %3 (max=%4), skipping it", _vehicle_key, _class, _hours_alive, A3W_vehicleLifetime];
  };

  if (isSCALAR(_hours_abandoned) && {A3W_vehicleMaxUnusedTime > 0 && {_hours_abandoned > A3W_vehicleMaxUnusedTime}}) exitWith {
    diag_log format["vehicle %1(%2) has been abandoned for %3 hours, (max=%4), skipping it", _vehicle_key, _class, _hours_abandoned, A3W_vehicleMaxUnusedTime];
  };


  def(_obj);
  _obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
  if (!isOBJECT(_obj)) exitWith {
    diag_log format["Could not create vehicle of class: %1", _class];
  };

  [_obj, false] call vehicleSetup;

  _obj setVariable ["vehicle_key", _vehicle_key, true];
  missionNamespace setVariable [_vehicle_key, _obj];

  _obj setPosWorld ATLtoASL _pos;
  if (isARRAY(_dir)) then {
    _obj setVectorDirAndUp _dir;
  };

  _obj setVariable ["baseSaving_spawningTime", diag_tickTime];
  if (isSCALAR(_hours_alive)) then {
    _obj setVariable ["baseSaving_hoursAlive", _hours_alive];
  };

  _obj setVariable ["vehicle_abandoned_time", diag_tickTime];  //the moment the vehicle is restored, consider it abandoned
  if (isSCALAR(_hours_abandoned)) then {
    _obj setVariable ["vehicle_abandoned_hours", _hours_abandoned];
  };

  // disables thermal equipment on loaded vehicles, comment out if you want thermal
  _obj disableTIEquipment true;

  //lock vehicles form this list
  if ({_obj isKindOf _x} count A3W_locked_vehicles_list > 0) then {
    _obj lock 2;
    _obj setVariable ["locked", 2, true];
    _obj setVariable ["objectLocked", true, true];
    _obj setVariable ["R3F_LOG_disabled",true,true];
  };

  if (isSCALAR(_damage)) then {
    _obj setDamage _damage;
  };

  if (isSCALAR(_fuel)) then {
    _obj setFuel _fuel;
  };

  if (isARRAY(_hitPoints)) then {
    { _obj setHitPointDamage _x } forEach _hitPoints;
  };

  [_obj,_variables] call sh_restoreVariables;


  def(_textures);
  _textures = _obj getVariable ["A3W_objectTextures",[]];
  if (isARRAY(_textures)) then {
    _obj setVariable ["BIS_enableRandomization", false, true];
    {
      _obj setObjectTextureGlobal _x;
    } forEach _textures;
  };

  //AddAi to vehicle
  if ([_obj] call sh_isUAV) then {
    createVehicleCrew _obj;
  };

  //restore the stuff inside the vehicle
  clearWeaponCargoGlobal _obj;
  clearMagazineCargoGlobal _obj;
  clearItemCargoGlobal _obj;
  clearBackpackCargoGlobal _obj;
  //_obj setVehicleAmmo 0;

  if (isARRAY(_cargo_weapons)) then {
    { _obj addWeaponCargoGlobal _x } forEach _cargo_weapons;
  };

  if (isARRAY(_cargo_backpacks)) then {
    {
      if (not((_x select 0) isKindOf "Weapon_Bag_Base")) then {
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


  tracked_vehicles_list pushBack _obj;

}};;


tracked_vehicles_list = [];

v_getTrackedVehicleIndex = {
  ARGVX4(0,_obj,objNull,-1);
  if (isNull _obj) exitWith {-1};

  (tracked_vehicles_list find _obj)
};

v_trackVehicle = {
  private["_index","_object"];
  _object = _this select 0;
  _index = [OR(_object,nil)] call v_getTrackedVehicleIndex;
  if (_index >= 0) exitWith {};

  //diag_log format["%1 is being added to the tracked list", _object];
  tracked_vehicles_list pushBack _object;
};

v_untrackVehicle = {
  private["_index","_object"];
  _object = _this select 0;
  _index = [OR(_object,nil)] call v_getTrackedVehicleIndex;
  if (_index < 0) exitWith {};

  //diag_log format["%1 is being removed from the tracked list", _object];
  tracked_vehicles_list deleteAt _index;
};

v_trackedVehiclesListCleanup = {
  //post cleanup the array
  init(_cleanup_start, diag_tickTime);
  init(_nulls,[]);
  init(_index,-1);
  init(_start_size,count(tracked_vehicles_list));
  while {true} do {
    _index = tracked_vehicles_list find objNull;
    if (_index < 0) exitWith {};
    tracked_vehicles_list deleteAt _index;
  };
  init(_end_size,count(tracked_vehicles_list));
  init(_cleanup_end, diag_tickTime);
  diag_log format["v_saveLoop: count(tracked_vehicles_list) = %1, %2 nulls deleted in %3 ticks", count(tracked_vehicles_list), (_start_size - _end_size), (_cleanup_end - _cleanup_start)];
};


//build list of object that should not be saved
v_skipList = [];
def(_obj);
{
  _obj = _x select 1;
  if (isOBJECT(_obj)) then {
    v_skipList pushBack _obj;
  };
  v_skipList pushBack _obj;
} forEach [civilianVehicles, call allVehStoreVehicles];


v_isSaveable = {
  ARGVX4(0,_obj,objNull,false);

  //it's a wreck, don't save it
  if (not(alive _obj)) exitWith {false};

  //not a vehicle, don't save it
  if (not([_obj] call sh_isSaveableVehicle)) exitWith {false};

  def(_purchasedVehicle);
  def(_missionVehicle);
  def(_usedVehicle);
  def(_townVehicle);
  def(_usedOnce);


  _purchasedVehicle = ([_obj] call sh_isAPurchasedVehicle);
  _missionVehicle = ([_obj] call sh_isAMissionVehicle);
  _staticWeapon = [_obj] call sh_isStaticWeapon;
  _townVehicle = not(_missionVehicle || {_purchasedVehicle || {_staticWeapon}});
  _usedOnce = not([_obj] call v_isVehicleVirgin);

  //diag_log format["%1, _purchasedVehicle = %2, _missionVehicle = %3, _usedOnce = %4, _townVehicle = %5, _staticWeapon = %6",_obj, _purchasedVehicle,_missionVehicle,_usedOnce,_townVehicle, _staticWeapon];

  //it's a purchased vehicle, and saving purchased vehicles has been enabled, save it
  if (_purchasedVehicle && {cfg_purchasedVehicleSaving_on}) exitWith {true};

  //it's a mission spawned vehicle, and saving mission vehicles has been enabled, save it
  if (_missionVehicle && {cfg_missionVehicleSaving_on}) exitWith {true};

  //if it's a static weapon, and saving static weapons has been enabled, save it
  if (_staticWeapon && {cfg_staticWeaponSaving_on}) exitWith {true};

  //if it's a town vehicle that has been used at least once, save it
  if (_townVehicle && {_usedOnce && {cfg_townVehicleSaving_on}}) exitWith {true};

  false
};


v_trackVehicleHoursAlive = {
  ARGVX3(0,_obj,objNull);

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

  (_totalHours)
};

v_trackVehicleHoursAbandoned = {
  ARGVX3(0,_obj,objNull);

  //if the vehicle is not empty, it can't possibly be abandoned
  if (not([_obj] call v_isVehicleEmpty)) exitWith {0};

  //if the vehicle has never been used, it's not technically abandoned, just un-used
  if (isNil{_obj getVariable "vehicle_first_user"}) exitWith {0};

  /*
   * past this point, we know for sure that the vehicle is in 'abandoned' state
   * which means that it has been used at least once, and left empty somewhere
   * by a player
   */

  def(_hoursAbandoned);
  def(_abandonedTime);

  _abandonedTime = _obj getVariable "vehicle_abandoned_time";
  _hoursAbandoned = _obj getVariable "vehicle_abandoned_hours";

  if (!isSCALAR(_abandonedTime)) then {
    _abandonedTime = diag_tickTime;
    _obj setVariable ["vehicle_abandoned_time", _abandonedTime];
  };

  if (!isSCALAR(_hoursAbandoned)) then {
    _hoursAbandoned = 0;
    _obj setVariable ["vehicle_abandoned_hours", _hoursAbandoned];
  };


  def(_totalHours);
  _totalHours = _hoursAbandoned + (diag_tickTime - _abandonedTime) / 3600;

  (_totalHours)
};

v_setupVehicleSavedVariables = {
  ARGVX3(0,_obj,objNull);
  ARGVX3(1,_variables,[]);

  def(_ownerUID);
  _ownerUID = _obj getVariable ["ownerUID", nil];
  if (isSTRING(_ownerUID) && {_ownerUID != ""}) then {
    _variables pushBack ["ownerUID", _ownerUID];;
  };

  def(_ownerN);
  _ownerN = _obj getVariable ["ownerN", nil];
  if (isSTRING(_ownerN) && {_ownerN != ""}) then {
    _variables pushBack ["ownerN", _ownerN];
  };

  def(_firstUser);
  _firstUser = _obj getVariable ["vehicle_first_user", nil];
  if (isSTRING(_firstUser) && {_firstUser != ""}) then {
    _variables pushBack ["vehicle_first_user", _firstUser];
  };

  _variables pushBack ["vehicle_abandoned_by", (_obj getVariable "vehicle_abandoned_by")];
  _variables pushBack ["A3W_purchasedVehicle", (_obj getVariable ["A3W_purchasedVehicle",false])];
  _variables pushBack ["A3W_missionVehicle", (_obj getVariable ["A3W_missionVehicle",false])];



  def(_r3fSide);
  _r3fSide = _obj getVariable "R3F_Side";
  if (isSIDE(_r3fSide)) then {
    _variables pushBack ["R3F_Side", str _r3fSide];
  };

  _variables pushBack ["A3W_objectTextures", (_obj getVariable ["A3W_objectTextures",[]])];

};

v_addSaveVehicle = {
  ARGVX3(0,_list,[]);
  ARGVX3(1,_obj,objNull);

  if (not([_obj] call v_isSaveable)) exitWith {};

  def(_class);
  def(_netId);
  def(_pos);
  def(_dir);
  def(_damage);
  def(_hoursAlive);
  def(_hoursAbandoned);

  _class = typeOf _obj;
  _netId = netId _obj;
  _dir = [vectorDir _obj, vectorUp _obj];
  _damage = damage _obj;

  _hoursAlive = [_obj] call v_trackVehicleHoursAlive;
  _hoursAbandoned = [_obj] call v_trackVehicleHoursAbandoned;

  //diag_log format["%1: _hoursAlive = %2", _obj,_hoursAlive];
  //diag_log format["%1: _hoursAbandoned = %2", _obj,_hoursAbandoned];

  def(_variables);
  _variables = [];
  [_obj,_variables] call v_setupVehicleSavedVariables;


  init(_weapons,[]);
  init(_magazines,[]);
  init(_items,[]);
  init(_backpacks,[]);

  // Save weapons & ammo
  _weapons = (getWeaponCargo _obj) call cargoToPairs;
  _magazines = (getMagazineCargo _obj) call cargoToPairs;
  _items = (getItemCargo _obj) call cargoToPairs;
  _backpacks = (getBackpackCargo _obj) call cargoToPairs;

  init(_turretMags,[]);
  if (cfg_staticWeaponSaving_on && {[_obj] call sh_isStaticWeapon}) then {
    _turretMags = magazinesAmmo _obj;
  };

  init(_hitPoints,[]);
  {
    _hitPoint = configName _x;
    _hitPoints pushBack [_hitPoint, _obj getHitPointDamage _hitPoint];
  } forEach (_obj call getHitPoints);

  init(_ammoCargo,getAmmoCargo _obj);
  init(_fuelCargo,getFuelCargo _obj);
  init(_repairCargo,getRepairCargo _obj);
  init(_fuel, fuel _obj);

  def(_objName);
  _objName = _obj getVariable ["vehicle_key", nil];

  if (isNil "_objName") then {
    _objName = format["veh_%1_%2",ceil(time), ceil(random 10000)];
    _obj setVariable ["vehicle_key", _objName, true];
  };

  _pos = ASLtoATL getPosWorld _obj;
  _pos set [2, ((_pos select 2) + 0.3)];
  //force the Z-axis if the vehicle is high above ground, or deep underwater (bring it to the surface)
  if (!(isTouchingGround _obj || {(getPos _obj) select 2 < 0.5 || (getPosASL _obj) select 2 < 0.5})) then {
    _pos set [2, 0];
    if (surfaceIsWater _pos) then {
      _pos = ASLToATL (_pos);
    };
  };

  _list pushBack [_objName, ([
    ["Class", _class],
    ["Position", _pos],
    ["Direction", _dir],
    ["HoursAlive", _hoursAlive],
    ["HoursAbandoned", _hoursAbandoned],
    ["Damage", _damage],
    ["Fuel", _fuel],
    ["Variables", _variables],
    ["Weapons", _weapons],
    ["Magazines", _magazines],
    ["Items", _items],
    ["Backpacks", _backpacks],
    ["TurretMagazines", _turretMags],
    ["AmmoCargo", _ammoCargo],
    ["FuelCargo", _fuelCargo],
    ["RepairCargo", _repairCargo],
    ["Hitpoints", _hitPoints]
  ] call sock_hash)];


  true
};

v_isVehicleEmpty = {
  ARGVX4(0,_obj,objNull,false);
  not({isPlayer _x} count crew _obj > 0 || isPlayer ((uavControl _obj) select 0))
};

//a virgin vehicle is one that no-one has ever used
v_isVehicleVirgin = {
  ARGVX4(0,_obj,objNull,false);
  (isNil {_obj getVariable "vehicle_first_user"})
};

v_GetIn_handler = {
  //diag_log format["%1 call v_GetIn_handler", _this];
  ARGVX3(0,_obj,objNull);
  ARGVX3(2,_player,objNull);

  //only track players
  if (!(isPlayer _player)) exitWith {};
  init(_uid,getPlayerUID _player);

  if ([_obj] call v_isVehicleVirgin) then {
    _obj setVariable ["vehicle_first_user", _uid];
  };

  //diag_log format["%1 entered vehicle by %2", _obj, _player];
  _obj setVariable ["vehicle_abandoned_by", nil];
  _obj setVariable ["vehicle_abandoned_time", nil];
  _obj setVariable ["vehicle_abandoned_hours", nil];

  [_obj] call v_trackVehicle;
};

v_GetOut_handler = {
  //diag_log format["%1 call v_GetOut_handler", _this];
  ARGVX3(0,_obj,objNull);
  ARGVX3(2,_player,objNull);

  //only track players
  if (!(isPlayer _player)) exitWith {};
  init(_uid,getPlayerUID _player);

  //in case the player was already inside the vehicle ... (the get-in handler did not catch it)
  if ([_obj] call v_isVehicleVirgin) then {
    _obj setVariable ["vehicle_first_user", _uid];
  };

  if ([_obj] call v_isVehicleEmpty) then {
    //diag_log format["%1 left abandoned by %2", _obj, _player];
    _obj setVariable ["vehicle_abandoned_by", _uid];
    _obj setVariable ["vehicle_abandoned_time", diag_tickTime];
    _obj setVariable ["vehicle_abandoned_hours", nil]; //start counting the hours form 0 again

  };
};

v_saveAllVechiles = {
  ARGVX3(0,_scope,"");
  init(_count,0);
  init(_request,[_scope]);

  [_scope] call stats_wipe;
  init(_bulk_size,100);
  init(_start_time, diag_tickTime);
  init(_last_save, diag_tickTime);


  {
    if (!isNil{[_request, _x] call v_addSaveVehicle}) then {
      _count = _count + 1;
    };

    //save vehicles in bulks
    if ((_count % _bulk_size) == 0 && {count(_request) > 1}) then {
      init(_save_start, diag_tickTime);
      _request call stats_set;
      init(_save_end, diag_tickTime);
      _request = [_scope];
      diag_log format["v_saveLoop: %1 vehicles saved in %2 ticks, save call took %3 ticks", (_bulk_size), (diag_tickTime - _start_time), (_save_end - _save_start)];
      _last_save = _save_end;
    };
  } forEach (tracked_vehicles_list);

  if (count(_request) > 1) then {
    init(_save_start, diag_tickTime);
    _request call stats_set;
    init(_save_end, diag_tickTime);
    diag_log format["v_saveLoop: %1 vehicles saved in %2 ticks, save call took %3 ticks", (count(_request) -1), (_save_end - _last_save), (_save_end - _save_start)];
  };

  diag_log format["v_saveLoop: total of %1 vehicles saved in %2 ticks", (_count), (diag_tickTime - _start_time)];

  call v_trackedVehiclesListCleanup;
};


v_saveLoop = {
  ARGVX3(0,_scope,"");
  while {true} do {
    sleep A3W_vehicle_saveInterval;
    if (not(isBOOLEAN(v_saveLoopActive) && {!v_saveLoopActive})) then {
      [_scope] call v_saveAllVechiles;
    };
  };
};

v_loadVehicles = {
  ARGVX3(0,_scope,"");

  def(_vehicles);
  _vehicles = [_scope] call stats_get;

  //nothing to load
  if (!isARRAY(_vehicles)) exitWith {};

  diag_log format["A3Wasteland - will restore %1 vehicles", count(_vehicles)];
  {
    [_x] call v_restoreVehicle;
  } forEach _vehicles;

  v_loadVehicles_complete = true;
};

diag_log "vFunctions.sqf loading complete";