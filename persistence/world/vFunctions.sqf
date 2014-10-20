diag_log "vFunctions.sqf loading ...";

#include "macro.h";

/**
 * List of class names of locked objects.
 */
VLOAD_LOCKED =
[
	"StaticWeapon",
	"MRAP_01_base_F",
	"MRAP_02_base_F",
	"MRAP_03_base_F",
	"O_Truck_03_device_F",
	"Wheeled_APC_F",
	"Tank_F",
	"O_Heli_Light_02_unarmed_F",
	"I_Heli_light_03_unarmed_F",
	"I_Heli_Transport_02_F",
	"B_Heli_Transport_01_F",
	"B_Heli_Transport_01_camo_F",
	"B_Heli_Light_01_armed_F",
	"O_Heli_Light_02_F",
	"I_Heli_light_03_F",
	"B_Heli_Attack_01_F",
	"O_Heli_Attack_02_F",
	"O_Heli_Attack_02_black_F",
	"Plane"
];


v_isWarchest = { 
  _this getVariable ["a3w_warchest", false] && {(_this getVariable ["side", sideUnknown]) in [WEST,EAST]} 
};

v_isBeacon = {
  _this getVariable ["a3w_spawnBeacon", false] 
};

v_strToSide = {
  def(_result);
	_result = switch (toUpper _this) do
	{
		case "WEST":  { BLUFOR };
		case "EAST":  { OPFOR };
		case "GUER":  { INDEPENDENT };
		case "CIV":   { CIVILIAN };
		case "LOGIC": { sideLogic };
		default       { sideUnknown };
	};
  (_result)
};

v_isAlwaysUnlocked = {
  ARGVX4(0,_obj,objNull, false);
  
  def(_result);
	_result = switch (true) do {
    case (_obj call v_isWarchest): { true };
    case (_obj call v_isBeacon): {true};
		default { false };
	};
  
  (_result)
};


v_getVehicleTextureSelections = {
  ARGVX3(0,_veh,objNull);
  
  _selections = switch (true) do {
    case (_veh isKindOf "Van_01_base_F"):             { [0,1] };
    case (_veh isKindOf "MRAP_01_base_F"):            { [0,2] };
    case (_veh isKindOf "MRAP_02_base_F"):            { [0,2] };
    case (_veh isKindOf "MRAP_03_base_F"):            { [0,1] };

    case (_veh isKindOf "Truck_01_base_F"):           { [0,1,2] };
    case (_veh isKindOf "Truck_02_base_F"):           { [0,1] };
    case (_veh isKindOf "Truck_03_base_F"):           { [0,1] };

    case (_veh isKindOf "APC_Wheeled_01_base_F"):     { [0,2] };
    case (_veh isKindOf "APC_Wheeled_02_base_F"):     { [0,2] };
    case (_veh isKindOf "APC_Wheeled_03_base_F"):     { [0,2,3] };

    case (_veh isKindOf "APC_Tracked_01_base_F"):     { [0,1,2,3] };
    case (_veh isKindOf "APC_Tracked_02_base_F"):     { [0,1,2] };
    case (_veh isKindOf "APC_Tracked_03_base_F"):     { [0,1] };

    case (_veh isKindOf "MBT_01_base_F"):             { [0,1,2] };
    case (_veh isKindOf "MBT_02_base_F"):             { [0,1,2,3] };
    case (_veh isKindOf "MBT_03_base_F"):             { [0,1,2] };

    case (_veh isKindOf "Heli_Transport_01_base_F"):  { [0,1] };
    case (_veh isKindOf "Heli_Transport_02_base_F"):  { [0,1,2] };
    case (_veh isKindOf "Heli_Attack_02_base_F"):     { [0,1] };

    case (_veh isKindOf "Plane_Base_F"):              { [0,1] };

    default                                           { [0] };
  };
  
  (_selections)
};


v_isVehicle = {
  ARGVX4(0,_obj,objNull,false);
  
  init(_result, false);
  {
    if (_obj isKindOf _x) exitWith {
      _result = true;
    };
  } forEach ["Helicopter", "Plane", "Boat_F", "Car", "Motorcycle", "Tank"];
  
  (_result)
};

def(_maxLifetime);
v_maxLifetime = ["A3W_vehicleLifetime", 0] call getPublicVar;

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
  def(_pos);
  def(_class);
  def(_dir);
  def(_damage);
  def(_allow_damage);
  def(_texture);
  def(_variables);
  def(_cargo_weapons);
  def(_cargo_magazines);
  def(_cargo_backpacks);
  def(_cargo_items);
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
      case "AllowDamage": { _allow_damage = OR(_value,nil);};
      case "Texture": { _texture = OR(_value,nil);};
      case "Weapons": { _cargo_weapons = OR(_value,nil);};
      case "Items": { _cargo_items = OR(_value,nil);};
      case "Magazines": { _cargo_magazines = OR(_value,nil);};
      case "Backpacks": { _cargo_backpacks = OR(_value,nil);};
      case "HoursAlive": { _hours_alive = OR(_value,nil);};
      case "Variables": { _variables = OR(_value,nil);};

    };
  } forEach _vehicle_data;

  //if there is no class and position, there is no point to recreating the vehicle
  if (not(isSTRING(_class)) || {not(isARRAY(_pos))}) exitWith {
    diag_log format["No class or position available for vehicle: %1", _vehicle_key];
  };
  
  def(_obj);
  _obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
  if (!isOBJECT(_obj)) exitWith {
    diag_log format["Could not create vehicle of class: %1", _class];
  };
  
  _obj setVariable ["vehicle_key", _vehicle_key, true];
  
  _obj setPosWorld ATLtoASL _pos;
  if (isARRAY(_dir)) then {
    _obj setVectorDirAndUp _dir;
  };
  
  _obj setVariable ["baseSaving_spawningTime", diag_tickTime];
  if (isSCALAR(_hours_alive)) then {
    _obj setVariable ["baseSaving_hoursAlive", _hours_alive];
  };
  
  // disables thermal equipment on loaded vehicles, comment out if you want thermal
  _obj disableTIEquipment true; 
  
  //lock vehicles form this list
  if ({_obj isKindOf _x} count VLOAD_LOCKED > 0) then {
    _obj lock 2;
    _obj setVariable ["locked", 2, true];
    _obj setVariable ["objectLocked", true, true];
    _obj setVariable ["R3F_LOG_disabled",true,true];
	};


  if (isSTRING(_texture) && {_texture != ""}) then {  
    def(_selections);
    _selections = [_obj] call v_getVehicleTextureSelections;
    if (!isARRAY(_selections)) exitWith {};
    
    _obj setVariable ["A3W_objectTexture", _texture, true];		
		_obj setVariable ["BIS_enableRandomization", false, true];

    { 
      _obj setObjectTextureGlobal [_x, _texture] 
    } forEach _selections;
  };
  
  
  if (isSCALAR(_damage)) then {
    _obj setDamage _damage;
  };
   
  _allowDamage = if(isSCALAR(_allowDamage) && {_allowDamage > 0}) then { true } else { false};
  _obj setVariable ["allowDamage", _allowDamage];
  _obj allowDamage _allowDamage;

  //restore vehicle variables
  if (isARRAY(_variables)) then {
    def(_name);
    def(_value);
    {
      _name = _x select 0;
      _value = _x select 1;
      
      if (!isNil "_value") then {
        switch (_name) do {
          case "side": { _value = _value call v_strToSide};
        };
      };
      
      _obj setVariable [_name, OR(_value,nil), true];
    } forEach _variables;
  };
  
  //restore the stuff inside the vehicle  
  clearWeaponCargoGlobal _obj;
  clearMagazineCargoGlobal _obj;
  clearItemCargoGlobal _obj;
  clearBackpackCargoGlobal _obj;
          
  if (isARRAY(_cargo_weapons)) then {
    { _obj addWeaponCargoGlobal _x } forEach _cargo_weapons;
  };
  
  if (isARRAY(_cargo_backpacks)) then {
    { _obj addBackpackCargoGlobal _x } forEach _cargo_backpacks;
  };
  
  if (isARRAY(_cargo_items)) then {
    { _obj addItemCargoGlobal _x } forEach _cargo_items;
  };
  
  if (isARRAY(_cargo_magazines)) then {
    { _obj addMagazineCargoGlobal _x } forEach _cargo_magazines;
  };
  
  //some vehicles need to be always unlocked
  def(_unlocked);
  _unlocked = [_obj] call v_isAlwaysUnlocked;
  if (_unlocked) then {
    _obj setVariable ["objectLocked", false, true];
	};
  
  
};};

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

v_addSaveVehicle = {
  ARGVX3(0,_list,[]);
  ARGVX3(1,_obj,objNull);
    
  def(_class);
  def(_ownerUID);
  
  _class = typeOf _obj;
	_ownerUID = _obj getVariable "ownerUID";
  
  if (!isSTRING(_ownerUID) || {_ownerUID == ""}) exitWith {};
  if (not([_obj] call v_isVehicle)) exitWith {};
  if ((v_skipList find _obj) >= 0) exitWith {};
  
  def(_netId);
  def(_pos);
  def(_dir);
  def(_damage);
  def(_allowDamage);
  def(_texture);
  def(_spawnTime);
  def(_hoursAlive);
  def(_hoursSinceSpawn);  
  
  _netId = netId _obj;
  _pos = ASLtoATL getPosWorld _obj;
  _value = (_pos select 2) + 0.3;
  _pos set [2, ((_pos select 2) + 0.3)];
  _dir = [vectorDir _obj, vectorUp _obj];
  _damage = damage _obj;
  _allowDamage = 1;
  _texture = _obj getVariable ["A3W_objectTexture", ""];
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
  
  def(_variables);
  _variables = [];
  
  _variables pushBack ["ownerUID", _ownerUID];
 
  def(_ownerN);
  _ownerN = _obj getVariable ["ownerN", nil];
  if (isSTRING(_ownerN) && {_ownerN != ""}) then {
    _variables pushBack ["ownerN", _ownerN];
  };

  init(_weapons,[]);
  init(_magazines,[]);
  init(_items,[]);
  init(_backpacks,[]);
  
  // Save weapons & ammo
  _weapons = (getWeaponCargo _obj) call cargoToPairs;
  _magazines = (getMagazineCargo _obj) call cargoToPairs;
  _items = (getItemCargo _obj) call cargoToPairs;
  _backpacks = (getBackpackCargo _obj) call cargoToPairs;

  def(_objName);
  _objName = _obj getVariable ["vehicle_key", nil];

  if (isNil "_objName") then {
    _objName = format["veh_%1_%2",ceil(time), ceil(random 10000)];
    _obj setVariable ["vehicle_key", _objName, true];
  };
    
  _list pushBack [ _objName + "." + "Class", _class];
  _list pushBack [ _objName + "." + "Position", _pos];
  _list pushBack [ _objName + "." + "Direction", _dir];
  _list pushBack [ _objName + "." + "HoursAlive", _totalHours];
  _list pushBack [ _objName + "." + "Damage", _damage];
  _list pushBack [ _objName + "." + "AllowDamage", _allowDamage];
  _list pushBack [ _objName + "." + "Variables", _variables];
  _list pushBack [ _objName + "." + "Texture", _texture];
  _list pushBack [ _objName + "." + "Weapons", _weapons];
  _list pushBack [ _objName + "." + "Magazines", _magazines];
  _list pushBack [ _objName + "." + "Items", _items];
  _list pushBack [ _objName + "." + "Backpacks", _backpacks];
  
  true
};

v_saveAllVechiles = {_this spawn {
  ARGVX3(0,_scope,"");
  init(_count,0);
  init(_request,[_scope]);
  
  [_scope] call stats_wipe;
  init(_bulk_size,5);
  
  {
    if (!isNil{[_request, _x] call v_addSaveVehicle}) then {
      _count = _count + 1;
    };
    
    //save vehicles in bulks
    if ((_count % _bulk_size) == 0 && {count(_request) > 1}) then {
      _request call stats_set;
      _request = [_scope];
    };
  } forEach (allMissionObjects "All");
  
  if (count(_request) > 1) then {
    _request call stats_set;
  };
  
  diag_log format ["A3W - %1 vehicles have been saved", _count];
};};

v_saveLoop = {
  ARGVX3(0,_scope,"");
  while {true} do {
    sleep 60;
    [_scope] call v_saveAllVechiles;
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
};

diag_log "vFunctions.sqf loading complete";