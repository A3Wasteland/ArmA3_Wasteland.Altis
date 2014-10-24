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
  [OR(_loaded_magazines,nil)] call p_restoreLoadedMagazines;
  [OR(_primary_weapon,nil)] call p_restorePrimaryWeapon;
  [OR(_secondary_weapon,nil)] call p_restoreSecondaryWeapon;
  [OR(_handgun_weapon,nil)] call p_restoreHandgunWeapon;
  removeBackpack player;  //remove the temporary backpack

  //Restore backpack, and stuff inside
  if (isSTRING(_backpack_class) && {_backpack_class != ""}) then {
    diag_log format["Resting backpack: %1", _backpack_class];
    [_backpack_class] call p_restoreBackpack;

    //restore the stuff inside the backpack
    [OR(_backpack_weapons,nil)] call p_restoreBackpackWeapons;
    [OR(_backpack_magazines,nil)] call p_restoreBackpackMagazines;
    [OR(_backpack_items,nil)] call p_restoreBackpackItems;
  };

  [OR(_uniform_class,nil)] call p_restoreUniform;
  [OR(_vest_class,nil)] call p_restoreVest;

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
          else {
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
};

fn_savePlayerData = {
  if (isDedicated) exitWith {};
  if (isCODE(savePlayerHandle) && {!scriptDone savePlayerHandle}) exitWith {};

  ARGV4(0,_manual_save,false,false);


  savePlayerHandle = ["savePlayerData"] spawn p_savePlayerData;

  if (isCODE(savePlayerHandle)) then {
    _savePlayerHandle = savePlayerHandle;
    waitUntil {scriptDone _savePlayerHandle};
    savePlayerHandle = nil;
  };

  if (_manual_save) then {
    cutText ["\nPlayer saved!", "PLAIN DOWN", 0.2];
  };
};

p_isPlayerSaveable = {
   (
     alive player &&
     {!isNil "isConfigOn" && {["A3W_playerSaving"] call isConfigOn}} &&
     {!isNil "playerSetupComplete" && {playerSetupComplete}} &&
     {!isNil "respawnDialogActive" && {!respawnDialogActive}} &&
     {player getVariable ["FAR_isUnconscious", 0] == 0}
   )
};

p_savePlayerData = {
    ARGVX3(0,_reply_variable,"");
    if (not(call p_isPlayerSaveable)) exitWith {};

    def(_UID);
    _UID = getPlayerUID player;

    _info =
    [
      ["UID", _UID],
      ["Name", name player],
      ["LastGroupSide", str side group player],
      ["LastPlayerSide", str playerSide],
      ["BankMoney", player getVariable ["bmoney", 0]]
    ];

    _hitPoints = [];
    {
      _hitPoint = configName _x;
      _hitPoints pushBack [_hitPoint, player getHitPointDamage _hitPoint];
    } forEach (player call getHitPoints);

    _data =
    [
      ["Damage", damage player],
      ["HitPoints", _hitPoints],
      ["Hunger", ["hungerLevel", 0] call getPublicVar],
      ["Thirst", ["thirstLevel", 0] call getPublicVar],
      ["Money", player getVariable ["cmoney", 0]] // Money is always saved, but only restored if A3W_moneySaving = 1
    ];

    // Only save those when on ground or underwater (you probably wouldn't want to spawn 500m in the air if you get logged off in flight)
    if (isTouchingGround vehicle player || {(getPos player) select 2 < 0.5 || (getPosASL player) select 2 < 0.5}) then {
      _data pushBack ["Position", getPosATL player];
      _data pushBack ["Direction", direction player];

      if (vehicle player == player) then {
        _data pushBack ["CurrentWeapon", format ["%1", currentMuzzle player]]; // currentMuzzle returns a number sometimes, hence the format
        _data pushBack ["Stance", [player, ["P"]] call getMoveParams];
      };
    };

    _gear =
    [
      ["Uniform", uniform player],
      ["Vest", vest player],
      ["Backpack", backpack player],
      ["Goggles", goggles player],
      ["Headgear", headgear player],

      ["PrimaryWeapon", primaryWeapon player],
      ["SecondaryWeapon", secondaryWeapon player],
      ["HandgunWeapon", handgunWeapon player],

      ["PrimaryWeaponItems", primaryWeaponItems player],
      ["SecondaryWeaponItems", secondaryWeaponItems player],
      ["HandgunItems", handgunItems player],

      ["AssignedItems", assignedItems player]
    ];


    _uMags = [];
    _vMags = [];
    _bMags = [];
    _partialMags = [];

    {
      _magArr = _x select 0;

      {
        _mag = _x select 0;
        _ammo = _x select 1;

        if (_ammo == getNumber (configFile >> "CfgMagazines" >> _mag >> "count")) then {
          [_magArr, _mag, 1] call fn_addToPairs;
        }
        else {
          if (_ammo > 0) then {
            _partialMags pushBack [_mag, _ammo];
          };
        };
      } forEach magazinesAmmoCargo (_x select 1);
    }
    forEach
    [
      [_uMags, uniformContainer player],
      [_vMags, vestContainer player],
      [_bMags, backpackContainer player]
    ];

    _loadedMags = [];

    {
      _mag = _x select 0;
      _ammo = _x select 1;
      _loaded = _x select 2;
      _type = _x select 3;

      // if loaded in weapon, not empty, and not hand grenade
      if (_loaded && _ammo > 0 && _type != 0) then
      {
        _loadedMags pushBack [_mag, _ammo];
      };
    } forEach magazinesAmmoFull player;

    _data pushBack ["UniformWeapons", (getWeaponCargo uniformContainer player) call cargoToPairs];
    _data pushBack ["UniformItems", (getItemCargo uniformContainer player) call cargoToPairs];
    _data pushBack ["UniformMagazines", _uMags];

    _data pushBack ["VestWeapons", (getWeaponCargo vestContainer player) call cargoToPairs];
    _data pushBack ["VestItems", (getItemCargo vestContainer player) call cargoToPairs];
    _data pushBack ["VestMagazines", _vMags];

    _data pushBack ["BackpackWeapons", (getWeaponCargo backpackContainer player) call cargoToPairs];
    _data pushBack ["BackpackItems", (getItemCargo backpackContainer player) call cargoToPairs];
    _data pushBack ["BackpackMagazines", _bMags];

    _gear pushBack ["PartialMagazines", _partialMags];
    _gear pushBack ["LoadedMagazines", _loadedMags];

    _wastelandItems = [];
    {
      if (_x select 1 > 0) then
      {
        _wastelandItems pushBack [_x select 0, _x select 1];
      };
    } forEach call mf_inventory_all;

    _gear pushBack ["WastelandItems", _wastelandItems];

    //FIXME: re-enable this optimization once stats_merge is implement
    /*
    _gearStr = str _gear;

    if (_gearStr != ["playerData_gear", ""] call getPublicVar) then
    {
      { _data pushBack _x } forEach _gear;
      playerData_gear = _gearStr;
    };
    */
    { _data pushBack _x } forEach _gear;

    if (alive player) then {
      missionNamespace setVariable [_reply_variable, [_UID, _info, _data, player]];
      publicVariableServer _reply_variable;
    };
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
      case "BankMoney": { player setVariable ["bmoney", _value max 0] };
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
  ARGV2(0,_hash);
  format["%1 call p_restoreData;", _this] call p_log_finest;

  def(_exit);
  _exit = {
    player allowDamage true;
    call p_firstSpawn;
    playerData_loaded = true;
  };

  def(_data);
  _data = getIf(isCODE(_hash),call _hash,nil);

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
  init(_dataKey, "PlayerSave");
  init(_infoKey, "PlayerInfo");

  def(_pData);
  _pData = [_scope, [_dataKey, nil], [_infoKey, nil]] call stats_get;

  def(_key);
  {
    _key = xGet(_x,0);
    switch(_key) do {
      case _dataKey: {
        [xGet(_x,1)] call p_restoreData;
      };
      case _infoKey: {
        [xGet(_x,1)] call p_restoreInfo;
      };
    };
  } forEach _pData;
};};


"reportStats" addPublicVariableEventHandler {
  diag_log format["reportStats: %1", _this];
  [_this select 1] spawn p_savePlayerData;
};



diag_log "pFunctions.sqf loading complete";
