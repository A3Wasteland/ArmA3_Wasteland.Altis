//  @file Version: 0.1
//  @file Name: sFunctions.sqf
//  @file Author: micovery
//  @file Description: server functions

diag_log "sFunctions.sqf loading ...";

#include "macro.h"

s_processRestartMessage = {
  ARGVX3(0,_scope,"");
  ARGVX3(1,_id,"");
  ARGVX3(2,_from,"");
  ARGVX3(3,_to,"");
  ARGVX3(4,_subject,"");
  ARGV2(5,_body);

  //halt all the save loops
  p_saveLoopActive = false;
  pl_saveLoopActive = false;
  v_saveLoopActive = false;
  o_saveLoopActive = false;

  diag_log format["Saving players all player stats"];
  //save all player stats
  call p_saveAllPlayers;

  diag_log format["Saving active players list"];
  //save all player stats
  init(_plScope, "PlayersList" call PDB_playersListFileName);
  [_plScope] call pl_savePlayersList;

  diag_log format["Saving all vehicles on the map"];
  //save all vehilce stats
  init(_vScope, "Vehicles" call PDB_objectFileName);
  [_vScope] call v_saveAllVechiles;

  diag_log format["Saving all objects on the map"];
  //save all object scopes
  init(_oScope, "Objects" call PDB_objectFileName);
  [_oScope] call o_saveAllObjects;
  [_oScope] call o_saveInfo;


  diag_log format["Sending restart message ack"];
  //send ack that the message has been processed
  def(_res);
  _res =
  [
    ["id", _id],
    ["from", "server"],
    ["to", _from],
    ["subject", "ack"],
    ["body", _id]
  ] call sock_hash;

  [_scope, format["%1.recv", _from], _res] call stats_push;

  //just to be safe, if the server is still up after 5 minutes, re-activate the saving loops
  [] spawn {
    sleep (5 * 60);
    diag_log format["WARNING: looks like server did not go down 5 minutes after a restart request"];
    v_saveLoopActive = true;
    o_saveLoopActive = true;
    p_saveLoopActive = true;
    pl_saveLoopActive = true;
  };

  true
};

s_processMessage = {
  ARGVX3(0,_scope,"");
  ARGV2(1,_message);
  if (isNil "_message" || not(isCODE(_message))) exitWith {};

  def(_data);
  _data = call _message;
  if (not(isARRAY(_data))) exitWith {};

  def(_id);
  def(_from);
  def(_to);
  def(_subject);
  def(_body);

  {
    switch (_x select 0) do {
      case "id": { _id = _x select 1;};
      case "from": { _from = _x select 1;};
      case "to": { _to = _x select 1;};
      case "subject": {_subject = _x select 1;};
      case "body": {_body = _x select 1;};
    };
  } forEach _data;

  if (isNil "_id") exitWith {};
  if (isNil "_from") exitWith {};
  if (isNil "_to") exitWith {};
  if (isNil "_subject") exitWith {};


  diag_log format["message queue: process(id:%1): {from: %2, to: %3, subject: %4}", str(_id), str(_from), str(_to), str(_subject)];
  if (_subject == "restart" && _to == "server" && _from != "server") exitWith {
    ([_scope,_id,_from,_to,_subject, OR(_body,nil)] call s_processRestartMessage)
  };
  diag_log format["message queue: process(id:%1): complete"];

  false
};

s_processMessages = {
  ARGVX3(0,_scope,"");

  //retrieve all the messages
  def(_messages);
  _messages = [_scope, "server.recv"] call stats_get;
  if (isNil "_messages") exitWith {
    diag_log format["message queue: no messages to process"];
  };

  if(typeName _messages != typeName []) exitWith {
    diag_log format["message queue: protocol error: recv typeName was %1, but was expecting typeName %2", typeName _messages, typeName []];
  };

  init(_count, count(_messages));
  diag_log format["message queue: %1 messages to process", _count];
  if (_count == 0) exitWith {};

  {
    [_scope, OR(_x,nil)] call s_processMessage;
  } forEach _messages;


  //clear the processed messages
  [_scope, "server.recv", []] call stats_set;

};


s_messageLoop = {
  diag_log format["%1 call s_messageLoop", _this];
  ARGVX3(0,_scope,"");

  //cleanup the message queue
  diag_log format["message queue: cleaning up old messages"];
  [_scope, "server.recv",[]] call stats_set;

  while {true} do {
    sleep 30;
    def(_script);
    _script = [_scope] spawn s_processMessages;
    waitUntil {scriptDone _script};
  };
};


p_getScoreInfo = {
  //diag_log format["%1 call p_getScoreInfo", _this];
  ARGVX3(0,_uid,"");

  def(_playerKills);
  def(_aiKills);
  def(_deathsCount);
  def(_reviveCount);
  def(_captureCount);

  _playerKills = [_uid, "playerKills"] call fn_getScore;
  _aiKills = [_uid, "aiKills"] call fn_getScore;
  _deathsCount = [_uid, "deathCount"] call fn_getScore;
  _reviveCount = [_uid, "reviveCount"] call fn_getScore;
  _captureCount = [_uid, "captureCount"] call fn_getScore;

  def(_scoreInfo);

  _scoreInfo = [
    ["playerKills", _playerKills],
    ["aiKills", _aiKills],
    ["deathCount", _deathsCount],
    ["reviveCount", _reviveCount],
    ["captureCount", _captureCount]
  ] call sock_hash;

  (_scoreInfo)
};

p_getPlayerInfo = {
  //diag_log format["%1 call p_getPlayerInfo", _this];
  ARGVX3(0,_player,objNull);

  def(_groupSide);
  _groupSide = str side group _player;

  def(_playerSide);
  _playerSide = if (alive _player) then {str (side _player)} else {_groupSide};

  def(_info);
  _info =
  [
    ["UID", _uid],
    ["Name", _name],
    ["LastGroupSide", OR(_groupSide,sideUnknown)],
    ["LastPlayerSide", OR(_playerSide,sideUnknown)],
    ["BankMoney", _player getVariable ["bmoney", 0]]
  ] call sock_hash;

  (_info)
};

p_addPlayerSave = {
  //diag_log format["%1 call p_addPlayerSave", _this];
  ARGVX3(0,_request,[]);
  ARGVX3(1,_player,objNull);
  ARGVX3(2,_uid,"");
  ARGVX3(3,_name,"");


  init(_alive, alive _player);
  diag_log format["p_addPlayerSave: Saving stats for %1(%2)", _name, _uid];

  def(_initComplete);
  _initComplete = _player getVariable ["initComplete", false];
  //diag_log format["_initComplete = %1", _initComplete];
  if (not(_initComplete)) exitWith {};

  def(_respawnDialogActive);
  _respawnDialogActive = _player getVariable ["respawnDialogActive", false];
  //diag_log format["_respawnDialogActive = %1", _respawnDialogActive];

  def(_FAR_isUnconscious);
  _FAR_isUnconscious = (_player getVariable ["FAR_isUnconscious", 0] != 0);
  //diag_log format["_FAR_isUnconscious = %1", _FAR_isUnconscious];

  def(_reset_save);
  _reset_save = (_respawnDialogActive || {_FAR_isUnconscious || {not(_alive)}}); //or not alive
  //diag_log format["_reset_save = %1", _reset_save];


  def(_playerInfo);
  _playerInfo = [_player] call p_getPlayerInfo;

  if (isARRAY(_playerInfo)) then {
    _request pushBack ["PlayerInfo", _playerInfo];
  };


  def(_scoreInfo);
  _scoreInfo = [_uid] call p_getScoreInfo;

  if (isARRAY(_scoreInfo)) then {
    _request pushBack ["PlayerScore",_scoreInfo];
  };

  diag_log format["Disconnected %1(%2):  unconscious = %3, respawning = %4, alive = %5", _name,_uid,_FAR_isUnconscious, _respawnDialogActive, _alive];
  if (_reset_save) exitWith {
     diag_log format["Resetting %1(%2) stats", _name, _uid];
     _request pushBack ["PlayerSave",nil];
     _request pushBack ["PlayerSave_Stratis",nil];
     _request pushBack ["PlayerSave_Altis",nil];
     true
  };

  _hitPoints = [];
  {
    _hitPoint = configName _x;
    _hitPoints pushBack [_hitPoint, _player getHitPointDamage _hitPoint];
  } forEach (_player call getHitPoints);


  def(_data);
  def(_world_data);

  _world_data = [];

  _data =
  [
    ["Damage", damage _player],
    ["HitPoints", _hitPoints],
    ["Hunger", _player getVariable ["hungerLevel", 100]],
    ["Thirst", _player getVariable ["thirstLevel", 100]],
    ["Money", _player getVariable ["cmoney", 0]] // Money is always saved, but only restored if A3W_moneySaving = 1
  ];

  def(_pos);
  _pos = ASLtoATL getPosWorld _player;
  //force the Z-axis if the player is high above ground, or deep underwater
  if (!(isTouchingGround vehicle _player || {(getPos _player) select 2 < 0.5 || (getPosASL _player) select 2 < 0.5})) then {
    _pos set [2, 0];
    if (surfaceIsWater _pos) then {
      _pos = ASLToATL (_pos);
    };
  };

  _world_data pushBack ["Position", _pos];
  _world_data pushBack ["Direction", direction _player];

  //only save animation, and current weapon if the player is not inside a vehicle
  if (vehicle _player == _player) then {
    _data pushBack ["CurrentWeapon", format ["%1", currentMuzzle _player]]; // currentMuzzle returns a number sometimes, hence the format
    _world_data pushBack ["Animation", (animationState _player)];
  };


  _gear =
  [
    ["Uniform", uniform _player],
    ["Vest", vest _player],
    ["Backpack", backpack _player],
    ["Goggles", goggles _player],
    ["Headgear", headgear _player],

    ["PrimaryWeapon", primaryWeapon _player],
    ["SecondaryWeapon", secondaryWeapon _player],
    ["HandgunWeapon", handgunWeapon _player],

    ["PrimaryWeaponItems", primaryWeaponItems _player],
    ["SecondaryWeaponItems", secondaryWeaponItems _player],
    ["HandgunItems", handgunItems _player],

    ["AssignedItems", assignedItems _player]
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
    [_uMags, uniformContainer _player],
    [_vMags, vestContainer _player],
    [_bMags, backpackContainer _player]
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
  } forEach magazinesAmmoFull _player;

  _data pushBack ["UniformWeapons", (getWeaponCargo uniformContainer _player) call cargoToPairs];
  _data pushBack ["UniformItems", (getItemCargo uniformContainer _player) call cargoToPairs];
  _data pushBack ["UniformMagazines", _uMags];

  _data pushBack ["VestWeapons", (getWeaponCargo vestContainer _player) call cargoToPairs];
  _data pushBack ["VestItems", (getItemCargo vestContainer _player) call cargoToPairs];
  _data pushBack ["VestMagazines", _vMags];

  _data pushBack ["BackpackWeapons", (getWeaponCargo backpackContainer _player) call cargoToPairs];
  _data pushBack ["BackpackItems", (getItemCargo backpackContainer _player) call cargoToPairs];
  _data pushBack ["BackpackMagazines", _bMags];

  _gear pushBack ["PartialMagazines", _partialMags];
  _gear pushBack ["LoadedMagazines", _loadedMags];

  _wastelandItems = [];
  {
    if (_x select 1 > 0) then
    {
      _wastelandItems pushBack [_x select 0, _x select 1];
    };
  } forEach (_player getVariable ["inventory",[]]);

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

  _request pushBack ["PlayerSave", (_data call sock_hash)];
  _request pushBack [format["PlayerSave_%1", worldName], (_world_data call sock_hash)];


  true
};

p_disconnectSave = {
  diag_log format["%1 call p_disconnectSave", _this];
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_uid,"");
  ARGVX3(2,_name,"");


  init(_scope,_uid call PDB_playerFileName);
  init(_request,[_scope]);

  if (isNil{[_request,_player,_uid,_name] call p_addPlayerSave}) exitWith {
    diag_log format["WARNING: No stats saved for %1(%2) on disconnect", _name, _uid];
  };

  _request call stats_set;
  [_scope] call stats_flush;
};


//event listener for server to track when the players inventory changes
"trackMyInventory" addPublicVariableEventHandler {
  //diag_log format["%1 call trackMyInventory", _this];
  ARGVX3(1,_this,[]);
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_inventory,[]);

  //note that this is not being set to broadcast on purpose
  _player setVariable ["inventory", _inventory];
};

"trackMyVitals" addPublicVariableEventHandler {_this spawn {
  //diag_log format["%1 call trackMyVitals", _this];
  ARGVX3(1,_this,[]);
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vitals,[]);

  {
    private["_key", "_value"];
    _key = _x select 0;
    _value = _x select 1;

    if (!isNil "_key" || {typeName _key == "STRING"}) then {
      _player setVariable [_key,OR(_value,nil)];
      //diag_log format["_key = %1, _value = %2", _key, OR(_value,nil)];
    };
  } forEach _vitals;
};};

fn_getPlayerFlag = {
  ARGVX3(0,_uid,"");

  def(_scope);
  _scope = "Hackers2" call PDB_hackerLogFileName;

  def(_key);
  _key = format["%1.records",_uid];


  def(_records);
  _records = [_scope, _key, nil] call stats_get;

  if (!isARRAY(_records)) exitWith {};

  private["_last"];
  _last = _records select (count(_records) -1);

  if (!isCODE(_last)) exitWith {};

  (call _last)
};

fn_kickPlayerIfFlagged = {
  ARGVX3(0,_UID,"");
  ARGVX3(1,_name,"");

  def(_flag);
  _flag = [_UID] call fn_getPlayerFlag;
  if (!isARRAY(_flag) || {count(_flag) == 0}) exitWith {};

  // Super mega awesome dodgy player kick method
  "Logic" createUnit [[1,1,1], createGroup sideLogic,
  ("
    this spawn {
      if (isServer) then {
        _grp = group _this;
        deleteVehicle _this;
        deleteGroup _grp;
      }
      else {
        waitUntil {!isNull player};
        if (getPlayerUID player == '" + _UID + "') then {
          preprocessFile 'client\functions\quit.sqf';
        };
      };
    }
  ")];

  //_oldName = _flag select 0; // always empty for extDB
  def(_hackType);
  def(_hackValue);

  _hackType = [_flag, "hackType", "unknown"] call fn_getFromPairs;
  _hackValue = [_flag, "hackValue", "unknown"] call fn_getFromPairs;

  diag_log format ["ANTI-HACK: %1 (%2) was kicked due to having been flagged for [%3, %4] in the past", _name, _UID, _hackType, _hackValue];

};

active_players_list = [];

p_getActivePlayerIndex = {
  ARGVX4(0,_player,objNull,-1);
  if (isNull _player) exitWith {-1};

  (active_players_list find _player)
};

p_trackPlayer = {
  ARGVX3(0,_player,objNull);

  def(_index);
  _index = [_player] call p_getActivePlayerIndex;
  if (_index >= 0) exitWith {};

  //diag_log format["%1 is being added to the active list", _player];
  active_players_list pushBack _player;
};

p_untrackPlayer = {
  ARGVX3(0,_player,objNull);

  def(_index);
  _index = [_player] call p_getActivePlayerIndex;
  if (_index < 0) exitWith {};

  //diag_log format["%1 is being removed from the active list", _player];
  active_players_list deleteAt _index;
};


p_ActivePlayersListCleanup = {

  //post cleanup the array
  init(_cleanup_start, diag_tickTime);
  init(_nulls,[]);
  init(_index,-1);
  init(_start_size,count(active_players_list));
  while {true} do {
    _index = active_players_list find objNull;
    if (_index < 0) exitWith {};
    active_players_list deleteAt _index;
  };
  init(_end_size,count(active_players_list));
  init(_cleanup_end, diag_tickTime);
  diag_log format["pl_saveLoop: count(active_players_list) = %1, %2 nulls deleted in %3 ticks", count(active_players_list), (_start_size - _end_size), (_cleanup_end - _cleanup_start)];
};


//event handlers for when player spawns
"trackMe" addPublicVariableEventHandler {
  //diag_log format["%1 call trackMe", _this];
  ARGVX3(1,_this,[]);
  [_this select 0] call p_trackPlayer;
};


p_saveAllPlayers = {
  init(_count,0);
  init(_start_time, diag_tickTime);

  def(_request);
  def(_scope);
  def(_player);
  def(_uid);
  def(_name);

  {if (true) then {
    _player = _x;
    if (isNil "_player" || {typeName _player != "OBJECT" || {isNull _player || {not(isPlayer _player) || { not(alive _player)}}}}) exitWith {
      active_players_list set [_forEachIndex, objNull];
    };

    _uid = getPlayerUID _player;
    _name = name _player;
    _scope = _uid call PDB_playerFileName;
    _request = [_scope];

    if (!isNil{[_request, _player, _uid, _name] call p_addPlayerSave}) then {
      _count = _count + 1;
    };

    init(_save_start, diag_tickTime);
    _request call stats_set;
    diag_log format["p_saveLoop: (%1 - %2) saved in %3 ticks, save call took %4 ticks", _name, _uid, (diag_tickTime - _start_time), (diag_tickTime - _save_start)];

  };} forEach (active_players_list);

  diag_log format["p_saveLoop: total of %1 players saved in %2 ticks", (_count), (diag_tickTime - _start_time)];
};





p_saveLoop = {
  while {true} do {
    sleep A3W_player_saveInterval;
    if (not(isBOOLEAN(p_saveLoopActive) && {!p_saveLoopActive})) then {
      diag_log format["saving all players"];
      call p_saveAllPlayers;
    };
  };
};



pl_addPlayerListSave = {
  ARGVX3(0,_request,[]);
  ARGVX3(1,_player,objNull);
  ARGVX3(2,_uid,"");
  ARGVX3(3,_name,"");

  init(_pdata,[]);

  def(_playerInfo);
  _playerInfo = [_player] call p_getPlayerInfo;
  if (isARRAY(_playerInfo)) then {
    _pdata pushBack ["PlayerInfo", _playerInfo];
  };

  def(_scoreInfo);
  _scoreInfo = [_uid] call p_getScoreInfo;
  if (isARRAY(_scoreInfo)) then {
    _pdata pushBack ["PlayerScore",_scoreInfo];
  };

  if (count _pdata == 0) exitWith {};

  _request pushBack [_uid, (_pdata call sock_hash)];

  true
};

pl_savePlayersList = {
  ARGVX3(0,_scope,"");

  init(_count,0);
  init(_start_time, diag_tickTime);

  def(_request);
  def(_scope);
  def(_player);
  def(_uid);
  def(_name);
  def(_request);

  _request = [_scope];

  {if (true) then {
    _player = _x;
    if (isNil "_player" || {typeName _player != "OBJECT" || {isNull _player || {not(isPlayer _player)}}}) exitWith {
      active_players_list set [_forEachIndex, objNull];
    };

    _uid = getPlayerUID _player;
    _name = name _player;

    if (!isNil{[_request, _player, _uid, _name] call pl_addPlayerListSave}) then {
      _count = _count + 1;
    };

  };} forEach (active_players_list);

  [_scope] call stats_wipe;

  init(_save_start, diag_tickTime);
  if (count _request > 1) then {
    //only send the save request if there is at least one player
    _request call stats_set;
  };
  diag_log format["pl_saveLoop: total of %1 entries saved (in player-list) in %2 ticks, save call took %3 ticks", (_count), (diag_tickTime - _start_time), (diag_tickTime - _save_start)];

  [_scope] call stats_flush;

  call p_ActivePlayersListCleanup;
};


pl_saveLoop = {
  ARGVX3(0,_scope,"");
  while {true} do {
    sleep A3W_playersList_saveInterval;
    if (not(isBOOLEAN(pl_saveLoopActive) && {!pl_saveLoopActive})) then {
      diag_log format["saving player list"];
      [_scope] call pl_savePlayersList;
    };
  };
};


diag_log "sFunctions.sqf loading complete";
