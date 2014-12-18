//	@file Version: 0.1
//	@file Name: pFunctions.sqf
//	@file Author: micovery
//	@file Description: Player loading

diag_log "pFunctions.sqf loading ...";

#include "macro.h"

//Some wrappers for logging
p_log_severe = {
  ["p_functions", _this] call log_severe;
};
p_log_info = {
  ["p_functions", _this] call log_info;
};
p_log_fine = {
  ["p_functions", _this] call log_fine;
};
p_log_finer = {
  ["p_functions", _this] call log_finer;
};
p_log_finest = {
  ["p_functions", _this] call log_finest;
};
p_log_set_level = {
  ["p_functions", _this] call log_set_level;
};
//Set default logging level for this component
LOG_INFO_LEVEL call p_log_set_level;
p_resetPlayerData = {
  removeAllWeapons player;
  removeAllAssignedItems player;
  removeUniform player;
  removeVest player;
  removeBackpack player;
  removeGoggles player;
  removeHeadgear player;
};

p_restoreBackpack = {
  ARGVX3(0,_value,"");
  removeBackpack player;

  if (_value == "") exitWith {};

  if (_value isKindOf "Weapon_Bag_Base") exitWith {
	player addBackpack "B_AssaultPack_rgr"; // NO SOUP FOR YOU
  };

  player addBackpack _value;
};

p_restoreBackpackWeapons = {
  ARGVX3(0,_value,[]);
 { (backpackContainer player) addWeaponCargoGlobal _x } forEach _value
};


p_restoreBackpackItems = {
  ARGVX3(0,_value, []);
  { (backpackContainer player) addItemCargoGlobal _x } forEach _value
};


p_restoreBackpackMagazines = {
  ARGVX3(0,_value,[]);
  { (backpackContainer player) addMagazineCargoGlobal _x } forEach _value
};


p_restorePrimaryWeapon = {
  ARGVX3(0,_value,"");
  player addWeapon _value; removeAllPrimaryWeaponItems player;
};


p_restoreSecondaryWeapon = {
  ARGVX3(0,_value,"");
  player addWeapon _value;
};


p_restoreHandgunWeapon = {
  //diag_log format["%1 call _restoreHandgunWeapon", _this];
  ARGVX3(0,_value,"");
  player addWeapon _value; removeAllHandgunItems player;
};

p_restoreLoadedMagazines = {
  ARGVX3(0,_value,[]);
 { player addMagazine _x } forEach _value;
};

p_restoreUniform = {
  ARGV4(0,_value,"","");

  if (_value == "") exitWith {
    player addUniform ([player, "uniform"] call getDefaultClothing);
  };

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

p_restoreVest = {
  ARGVX3(0,_value,"");
  if (_value == "") exitWith {};
  player addVest _value;
};


p_copy_pairs = {
  ARGVX3(0,_target,[]);
  ARGVX3(1,_source,[]);
  {
    _target pushBack _x;
  } forEach _source;
};

p_restorePosition = {
  ARGV3(0,_position,[]);

  if (isPOS(_position)) exitWith {
    player setPosATL _position;
  };

  diag_log format["WARNING: No position available. Putting player at a random safe location."];
  player groupChat format["WARNING: No position available. Putting you at a random safe location."];
  [nil,false] spawn spawnRandom;
};



fn_applyPlayerData = {
  ARGVX3(0,_data,[]);
  format["%1 call fn_applyPlayerData;", _this] call p_log_finest;

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
  def(_vehicle_key);
  def(_position);

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
      case "InVehicle": { _vehicle_key = _value};
      case "Position": {if (isPOS(_value)) then {_position = _value;}};
    };
  } forEach _data;


  //Restore the weapons, backpack, uniform, and vest in correct order
  player addBackpack "B_Carryall_Base"; // add a temporary backpack for holding loaded weapon magazines
  [OR(_loaded_magazines,nil)] call p_restoreLoadedMagazines;
  [OR(_primary_weapon,nil)] call p_restorePrimaryWeapon;
  [OR(_secondary_weapon,nil)] call p_restoreSecondaryWeapon;
  [OR(_handgun_weapon,nil)] call p_restoreHandgunWeapon;
  removeBackpack player;  //remove the temporary backpack

  //Restore backpack, and stuff inside
  if (isSTRING(_backpack_class) && {_backpack_class != ""}) then {
    //diag_log format["Restoring backpack: %1", _backpack_class];
    [_backpack_class] call p_restoreBackpack;

    //restore the stuff inside the backpack
    [OR(_backpack_weapons,nil)] call p_restoreBackpackWeapons;
    [OR(_backpack_magazines,nil)] call p_restoreBackpackMagazines;
    [OR(_backpack_items,nil)] call p_restoreBackpackItems;
  };

  [OR(_uniform_class,nil)] call p_restoreUniform;
  [OR(_vest_class,nil)] call p_restoreVest;

  [OR(_position,nil)] call p_restorePosition;

  //restore other stuff that is not order-dependent
  def(_name);
  def(_value);
  {
    _name = _x select 0;
    _value = _x select 1;

    switch (_name) do {
      case "Damage": { if (isSCALAR(_value)) then {player setDamage _value;};};
      case "HitPoints": { { player setHitPointDamage _x } forEach (OR(_value,[])) };
      case "Hunger": { hungerLevel = OR(_value,nil); };
      case "Thirst": { thirstLevel = OR(_value,nil); };
      case "Money": { player setVariable ["cmoney", OR(_value,0), true] };
      case "Direction": { if (defined(_value)) then {player setDir _value} };
      case "Goggles": { if (isSTRING(_value) && {_value != ""}) then { player addGoggles _value } };
      case "Headgear": {
        // If wearing one of the default headgears, give the one belonging to actual team instead
        if (isSTRING(_value) && {_value != ""}) then {
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
          else {
            player addHeadgear _value;
          };
        };
      };
      case "PrimaryWeaponItems": { { if (_x != "") then { player addPrimaryWeaponItem _x } } forEach (OR(_value,[])) };
      case "SecondaryWeaponItems": { { if (_x != "") then { player addSecondaryWeaponItem _x } } forEach (OR(_value,[])) };
      case "HandgunItems": { { if (_x != "") then { player addHandgunItem _x } } forEach (OR(_value,[])) };
      case "AssignedItems": {
        {
          if ([player, _x] call isAssignableBinocular) then {
            player addWeapon _x;
          }
          else {
            player linkItem _x;
          };
        } forEach (OR(_value,[]));
      };
      case "CurrentWeapon": { player selectWeapon OR(_value,"") };
      case "Animation": { if (isSTRING(_value) && {_value != ""}) then {[player, _value] call switchMoveGlobal};};
      case "UniformWeapons": { { (uniformContainer player) addWeaponCargoGlobal _x } forEach (OR(_value,[])) };
      case "UniformItems": { { (uniformContainer player) addItemCargoGlobal _x } forEach (OR(_value,[])) };
      case "UniformMagazines": { { (uniformContainer player) addMagazineCargoGlobal _x } forEach (OR(_value,[])) };
      case "VestWeapons": { { (vestContainer player) addWeaponCargoGlobal _x } forEach (OR(_value,[])) };
      case "VestItems": { { (vestContainer player) addItemCargoGlobal _x } forEach (OR(_value,[])) };
      case "VestMagazines": { { (vestContainer player) addMagazineCargoGlobal _x } forEach (OR(_value,[])) };
      case "PartialMagazines": { { player addMagazine _x } forEach _value };
      case "WastelandItems": { { [_x select 0, _x select 1, true] call mf_inventory_add } forEach (OR(_value,[])) };
    };
  } forEach _data;
};

fn_savePlayerData = {
  trackMyVitals =
  [
    player,
    [
      ["thirstLevel", thirstLevel],
      ["hungerLevel", hungerLevel]
    ]
  ];

  publicVariableServer "trackMyVitals";
};


fn_deletePlayerData = {
	deletePlayerData = player;
	publicVariableServer "deletePlayerData";
	playerData_gear = "";
};


fn_applyPlayerInfo = {
  diag_log format["%1 call fn_applyPlayerInfo;",_this];
  init(_data,_this);
  def(_name);
  def(_value);

  _data = _this;

  {
    _name = _x select 0;
    _value = _x select 1;

    switch (_name) do
    {
      case "Donator": { player setVariable ["isDonator", _value > 0] };
      case "BankMoney": { player setVariable ["bmoney", OR(_value,0), true] };
    };
  } forEach _data;
};


p_restoreInfo = {
  ARGVX2(0,_hash);
  if (!isCODE(_hash)) exitWith {};
  format["%1 call p_restoreInfo;", _this] call p_log_finest;
  def(_data);
  _data = call _hash;

  _data call fn_applyPlayerInfo;
};

p_restoreScore = {
  ARGVX2(0,_hash);
  if (!isCODE(_hash)) exitWith {};
  diag_log format["%1 call p_restoreScore;",_this];
  def(_data);
  _data = call _hash;

  def(_key);
  def(_value);

  {if (true) then {
    if (!isARRAY(_x)) exitWith {};

    _key = _x select 0;
    _value = _x select 1;
    if (!isSCALAR(_value)) exitWith {};

    diag_log format["Restoring %1 = %2", _key, _value];

    [player, _key, _value] call fn_setScore;
  };} forEach _data;

};

p_preloadEnabled = {
  (profileNamespace getVariable ["A3W_preloadSpawn", true])
};

p_preloadPosition = {
  ARGV3(0,_pos,[]);

  if (!(call p_preloadEnabled || {undefined(_pos)})) exitWith {
    player groupChat "Loading previous location...";
  };

  _pos set [2,OR(_pos select 2,0)];
   player groupChat "Preloading previous location...";
   waitUntil {sleep 0.1; preloadCamera _pos};
};

p_firstSpawn = {
  player enableSimulation true;
  player allowDamage true;
  player setVelocity [0,0,0];
  format["%1 call p_firstSpawn;", _this] call p_log_finest;

  execVM "client\functions\firstSpawn.sqf";
};

p_restoreData = {
  diag_log format["%1 call p_restoreData",_this];
  ARGV2(0,_data);
  format["%1 call p_restoreData;", _this] call p_log_finest;

  def(_exit);
  _exit = {
    player allowDamage true;
    call p_firstSpawn;
    playerData_loaded = true;
  };

  def(_dataValid);
  _dataValid = (isARRAY(_data) && {count(_data) > 0});

  if (!_dataValid) exitWith {
    format["saved data for %1 is not valid;", player] call p_log_finest;
    playerData_resetPos = true;
    call _exit;
  };

   playerData_alive = true;
   [_data] call fn_applyPlayerData;
   call _exit;
};

p_getScope = {
  ARGVX3(0,_id,"");
  format["%1 call p_getScope;", _this] call p_log_finest;
  waitUntil {not(isNil "PDB_PlayerFileID")};
  (format["%1%2",PDB_PlayerFileID,_id])
};

fn_requestPlayerData = {[] spawn {
  init(_player,player);
  init(_uid,getPlayerUID player);
  init(_scope,[_uid] call p_getScope);
  format["%1 call fn_requestPlayerData;", _this] call p_log_finest;


  playerData_alive = nil;
  playerData_loaded = nil;
  playerData_resetPos = nil;
  init(_genericDataKey, "PlayerSave");
  init(_infoKey, "PlayerInfo");
  init(_scoreKey, "PlayerScore");

  def(_worldDataKey);
  _worldDataKey = format["%1_%2", _genericDataKey, worldName];

  def(_pData);
  _pData = [_scope, [_genericDataKey, nil], [_worldDataKey, nil], [_infoKey, nil], [_scoreKey, nil]] call stats_get;
  if (not(isARRAY(_pData))) exitWith {
    //player data did not load, force him back to lobby
    endMission "LOSER";
  };

  def(_worldData);
  def(_genericData);

  def(_key);
  {
    _key = xGet(_x,0);
    switch(_key) do {
      case _genericDataKey: {
        _genericData = xGet(_x,1);
      };
      case _worldDataKey: {
        _worldData = xGet(_x,1);
      };
      case _infoKey: {
        [xGet(_x,1)] call p_restoreInfo;
      };
      case _scoreKey: {
        [xGet(_x,1)] call p_restoreScore;
      };
    };
  } forEach _pData;

  //merge the world specific data, with the generic data
  _genericData = OR(call _genericData,[]);
  _worldData = OR(call _worldData,[]);

  diag_log ("_genericData = " + str(_genericData));
  diag_log ("_worldData = " + str(_worldData));

  /**
   * If the world is Stratis, ignore the legacy generic "Position".
   * The legacy "Position" field should only be used for "Altis"
   */
  if (worldName == "Stratis") then {
    [_genericData, "Position", nil] call hash_set_key;
  };

  def(_allData);
  _allData = [_genericData, _worldData] call hash_set_all;
  diag_log ("_allData = " + str(_allData));
  [_allData] call p_restoreData;

};};



p_handle_mprespawn = {
  	ARGV3(0,_unit,objNull);
  	ARGV3(1,_corpse,objNull);
    //diag_log format["%1 call p_handle_mprespawn;", _this];

    if (not(local _unit)) exitWith {};
    trackMe = [_unit];
    publicVariableServer "trackMe";
};


player addMPEventHandler ["MPRespawn",{ _this call p_handle_mprespawn }];



diag_log "pFunctions.sqf loading complete";
