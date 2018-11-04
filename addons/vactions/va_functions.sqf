if (!isNil "va_actions_functions_defined") exitWith {};
diag_log format["Loading vehicle actions functions ..."];
#include "macro.h"


#define cameraDirDist(x) ([(positionCameraToWorld [0,0,0]), (positionCameraToWorld [0,0,x])] call BIS_fnc_vectorDiff)
#define insideAVehicle(x) ((vehicle x) != x)

//Normalize the config variables
cfg_va_info_action_on = OR_BOOLEAN(cfg_va_info_action_on,true);
cfg_va_unflip_action_on = OR_BOOLEAN(cfg_va_unflip_action_on,true);
cfg_va_unflip_wait_time = OR_POSITIVE(cfg_va_unflip_wait_time,10);
cfg_va_unflip_wait_distance = OR_POSITIVE(cfg_va_unflip_wait_distance,10);
cfg_va_pull_player_action_on = OR_BOOLEAN(cfg_va_pull_player_action_on,true);
cfg_va_lock_action_on = OR_BOOLEAN(cfg_va_lock_action_on,true);
cfg_va_lock_owner_only = OR_BOOLEAN(cfg_va_lock_owner_only,true);
cfg_va_lock_from_inside = OR_BOOLEAN(cfg_va_lock_from_inside,true);
cfg_va_lock_actions_classes_list = OR_ARRAY(cfg_va_lock_actions_classes_list,[]);
cfg_va_lock_sound_play = OR_BOOLEAN(cfg_va_lock_sound_play,true);


va_player_inside = {
  ARGVX4(0,_player,objNull,false);
  ARGVX4(1,_vehicle,objNull,false);

  (((vehicle _player) == _vehicle) && {(_vehicle != _player)})
};

va_player_exit = {
  //player groupChat format["player_exit_vehicle %1",_this];
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);
  ARGV4(2,_immediate,false,true);


  _vehicle lock false;
  if (_immediate) exitWith {
    moveOut _player;

    // ejection bug workaround
    if (!isNull objectParent _player) then
    {
      _player setPos (_player modelToWorldVisual [0,0,0]);
    };
  };

  //leave engine in same state after exiting
  def(_engine_state);
  _engine_state =  isEngineOn _vehicle;
  _player action ["getOut",_vehicle];
  _vehicle engineOn _engine_state;
};

va_is_player_owner = {
  ARGVX4(0,_player,objNull,false);
  ARGVX4(1,_vehicle,objNull,false);

  if (not(alive _player)) exitWith {};

  def(_ownerUID);
  _ownerUID = _vehicle getVariable ["ownerUID", "unknown"];

  def(_uid);
  _uid = getPlayerUID _player;

  (_uid == _ownerUID)
};

va_pull_player_action = {
  ARGVX3(3,_this,[]);
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);
  ARGVX3(2,_target,objNull);

  [_target, _vehicle, false] call va_player_exit;
};

va_pull_player_action_available = {
  if (not(cfg_va_pull_player_action_on)) exitWith {false};

  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);
  ARGVX3(2,_target,objNull);


  if (not(alive _player)) exitWith {false};
  if (not(isPlayer _target) && {getText (configFile >> "CfgVehicles" >> typeOf _target >> "simulation") == "UAVPilot"}) exitWith {false};
  if (cursorTarget != _vehicle) exitWith {false};
  if (not(locked _vehicle < 2)) exitWith {false};
  if (not([_target, _vehicle] call va_player_inside)) exitWith {false};

  true
};

va_flipped = {
  ARGVX4(0,_vehicle,objNull,false);

  def(_pos);
  _pos = getPos _vehicle;

  //no unflip action if vehicle is in water
  if (surfaceIsWater _pos) exitWith {false};

  def(_snormal);
  def(_vnormal);
  _snormal = surfaceNormal _pos;
  _vnormal = vectorUp _vehicle;

  def(_angle);
  _angle = [_snormal, _vnormal] call vector_angle;

  (_angle > 15)
};

va_unflip_action_available = {
  if (not(cfg_va_unflip_action_on)) exitWith {false};
  ARGVX4(0,_vehicle,objNull,false);


  ([_vehicle] call va_flipped)
};

va_unflip_action = {

  if (isSCRIPT(va_unflip_action_script) && {not(scriptDone va_unflip_action_script)}) exitWith {
    player groupChat format["Vehicle unflip action is already in progress, please wait"];
  };

  va_unflip_action_script = _this spawn {
   //player groupChat format["va_unflip_action %1",_this];
    ARGVX3(3,_this,[]);
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_vehicle,objNull);

    if (not(alive _player)) exitWith {};


    def(_display_name);
    _display_name = [typeOf _vehicle] call generic_display_name;

    init(_sleep,cfg_va_unflip_wait_time);
    init(_dist,cfg_va_unflip_wait_distance);

    _player groupChat format["Unflipping the %1, wait for %2 seconds nearby.", _display_name, _sleep];
    sleep _sleep;

    if ((_player distance _vehicle) > _dist) exitWith {
      _player groupChat format["Could not unflip the %1, you must stay within %2 meters.", _display_name, _dist];
    };

    [[_vehicle,surfaceNormal (getPos _vehicle)],"A3W_fnc_unflip",_vehicle] call BIS_fnc_MP;


    _player groupChat format["The %1 has been unflipped", _display_name];
  };
};

//place-holder in case people want to modify this condition
va_information_action_available = {
  if (not(cfg_va_info_action_on)) exitWith {false};

  ARGVX4(0,_player,objNull,false);
  ARGVX4(1,_vehicle,objNull,false);

  //put your custom logic here, if you want to restrict who can see the vehicle information

  true
};


va_get_tag = {
  ARGVX4(0,_vehicle,objNull,"");
  def(_tag);
  _tag =  _vehicle getVariable "vehicle_key"; //sock-rpc-stats
  if (isSTRING(_tag)) exitWith {_tag};

  _tag = _vehicle getVariable "A3W_vehicleID"; //iniDB, and extDB
  if (isSTRING(_tag)) exitWith {_tag};
  if (not(isNil "_tag")) exitWith {str _tag};

  ""
};

va_get_owner_name = {
  ARGVX4(0,_vehicle,objNull,"None");

  def(_name);
  _name = _vehicle getVariable "ownerN";
  if (isSTRING(_name)) exitWith {_name};

  _name = _vehicle getVariable "ownerName";
  if (isSTRING(_name)) exitWith {_name};

  def(_uid1);
  def(_uid2);
  def(_uid3);
  def(_uid4);

  //I know, it's ugly, but got to try all these
  _uid1 = _vehicle getVariable ["uid", ""];
  _uid2 = _vehicle getVariable ["owner", ""];
  _uid3 = _vehicle getVariable ["ownerUID", ""];
  _uid4 = _vehicle getVariable ["UID", ""];

  if (_uid1 == "" && { _uid2 == "" && { _uid3 == "" && { _uid4 == ""}}}) exitWith {"None"};

  def(_uid);
  def(_player);

  {if (true) then {
    if (!isPlayer _x) exitWith {};
    _uid = getPlayerUID _x;
    if (_uid == "") exitWith {};

    if (_uid == _uid1 || {
        _uid == _uid2 || {
        _uid == _uid3 || {
        _uid == _uid4}}}) exitWith {
      _player = _x;
    }
  };} forEach allPlayers;

  if (!isOBJECT(_player)) exitWith {"Not in game"};

  (name _player)
};


va_information_action = {
  ARGVX3(3,_this,[]);
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);


  def(_class);
  def(_driver);
  def(_picture);
  def(_display_name);
  _class = typeOf _vehicle;
  _driver = driver _vehicle;
  _driver = if (isNull _driver) then {"None"} else {(name _driver)};
  _picture = [_class] call generic_picture_path;
  _display_name = [_class] call generic_display_name;

  def(_owner);
  def(_tag);
  _owner = [_vehicle] call va_get_owner_name;
  _tag = [_vehicle] call va_get_tag;

  def(_text);
  def(_label);
  def(_value);
  _text = "";
  {
    _label = _x select 0;
    _value = _x  select 1;
    _text = _text + "<t align='left' font='PuristaMedium' size='1'>" + _label + "</t><t align='left' font='PuristaMedium'>" + _value + "</t><br />";
  }
  forEach(
    [["   ID:         ", ([_tag,17] call str_truncate)],
     ["   Direction:  ", str(round(getdir _vehicle)) + toString [176]],
     ["   Grid:       ", mapGridPosition _vehicle],
     ["   Altitude:   ", str(round(getposASL _vehicle select 2)) + " meter(s) ASL"],
     ["   Driver:     ", ([_driver,17] call str_truncate)],
     ["   Seats:     ", str((_vehicle emptyPositions "cargo")+(_vehicle emptyPositions "driver")) + " seat(s)"],
     ["   Size:       ", str(round((sizeOf _class)*10)/10) + " meter(s)"],
     ["   Owner:     ",  ([_owner,17] call str_truncate)]


    ]);

  _text = format["<t align='center' font='PuristaMedium' size='1.4' >Vehicle Information</t><br /><img image='%1' size='2.8'   /><br /><t  align='center'>(%2)</t>", _picture, ([_display_name,25] call str_truncate)] + "<br /><br />" + _text;
  hint parseText _text;
};

va_lock = {
  _this pushBack 2;
  _this call va_remote_lock;
};

va_unlock = {
  _this pushBack 0;
  _this call va_remote_lock;
};


/*
  0 - Unlocked
  1 - Default
  2 - Locked
  3 - Locked for player
*/

va_remote_lock = {
  ARGVX3(0,_vehicle, objNull);
  ARGVX3(1,_state,1);
  //[[_vehicle, _state] , "A3W_fnc_lock", true, false, true] call BIS_fnc_MP;
  [_vehicle, _state] call A3W_fnc_setLockState;
};

va_is_locked = {
  ARGVX4(0,_vehicle,objNull,false);
  def(_state);
  _state = locked _vehicle;
  (_state == 2 || { _state == 3})
};


va_lock_toggle = {
  ARGVX3(0,_vehicle,objNull);

  def(_locked);
  def(_state);

  _locked = [_vehicle] call va_is_locked;
  _state = if (_locked) then {2} else {0};

  [_vehicle, _state] call va_remote_lock;
  _state
};

va_lock_action = {
  ARGVX3(3,_this,[]);
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);

  if ([_vehicle] call va_is_locked) exitWith {};


  if (cfg_va_lock_sound_play) then {
    playSound3d ["a3\sounds_f\air\Heli_Attack_02\Mixxx_door.wss",_player, true];
  };

  [_vehicle] call va_lock;
};

va_unlock_action = {
  ARGVX3(3,_this,[]);
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);

  if (not([_vehicle] call va_is_locked)) exitWith {};

   if (cfg_va_lock_sound_play) then {
    playSound3d ["a3\sounds_f\air\Heli_Attack_01\close.wss", _vehicle, insideAVehicle(_player)];
  };

  [_vehicle] call va_unlock;
};

va_is_lockable = {
  ARGVX3(0,_vehicle,objNull);

  if (_vehicle isKindOf "Man") exitWith {false};

  def(_class);
  _class = typeOf _vehicle;

  ({_class isKindOf _x} count cfg_va_lock_actions_classes_list > 0 && {{_class isKindOf _x} count cfg_va_lock_actions_classes_list_excl == 0})
};

va_lock_action_available = {
  if (not(cfg_va_lock_action_on)) exitWith {false};

  ARGVX4(0,_player,objNull,false);
  ARGVX4(1,_vehicle,objNull,false);

  if ([_vehicle] call va_is_locked) exitWith {false};

  if (not([_vehicle] call va_is_lockable)) exitWith {false};

  if (cfg_va_lock_from_inside &&  {[_player, _vehicle] call va_player_inside}) exitWith {true};

  if (cfg_va_lock_owner_only && {not([_player, _vehicle] call va_is_player_owner)}) exitWith {false};

  true
};

va_unlock_action_available = {
  if (not(cfg_va_lock_action_on)) exitWith {false};

  ARGVX4(0,_player,objNull,false);
  ARGVX4(1,_vehicle,objNull,false);

  if (not([_vehicle] call va_is_locked)) exitWith {false};

  if (not([_vehicle] call va_is_lockable)) exitWith {false};

  if (cfg_va_lock_from_inside &&  {[_player, _vehicle] call va_player_inside}) exitWith {true};

  if (cfg_va_lock_owner_only && {not([_player, _vehicle] call va_is_player_owner)}) exitWith {false};

  true
};


va_outside_actions = OR(va_outside_actions,[]);

va_outside_remove_actions = {
  if (count va_outside_actions == 0) exitWith {};
  //player groupChat format["va_outside_remove_actions %1", _this];

  ARGVX3(0,_player,objNull);
  if (not(isPlayer _player)) exitWith {};

  {
    private["_action_id"];
    _action_id = _x;
    _player removeAction _action_id;
  } forEach va_outside_actions;
  va_outside_actions = [];
};


va_outside_owner_add_actions = {
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);

  def(_crew);
  _crew = crew _vehicle;
  {if (true) then {
    private["_member"];
    _member = _x;

    def(_action_id);
    _action_id = _player addaction [format["<img image='addons\vactions\icons\pull.paa'/> Pull %1", (name _member)], {_this call va_pull_player_action;}, [_player, _vehicle, _member],10,false,false,"",
      format["([objectFromNetId %1, objectFromnetId %2, objectFromNetId %3] call va_pull_player_action_available)", str(netId _player), str(netId _vehicle), str(netId _member)]];
    va_outside_actions = va_outside_actions + [_action_id];
  };} forEach _crew;
};

va_outside_add_actions = {
  if (count va_outside_actions > 0) exitWith {};
  //player groupChat format["va_outside_add_actions %1", _this];
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);

  if (not(isPlayer _player)) exitWith {};

  def(_display_name);
  _display_name = [typeOf _vehicle] call generic_display_name;

  //Add crew actions
  if ([_player, _vehicle] call va_is_player_owner) then {
    [_player, _vehicle] call va_outside_owner_add_actions;
  };

  //Add unfliping action
  _action_id = _player addaction [format["<img image='addons\vactions\icons\flip.paa'/> Unflip %1", _display_name], {_this call va_unflip_action;}, [_player, _vehicle],10,false,false,"",
  format["([objectFromNetId %1] call va_unflip_action_available)",str(netId _vehicle)]];
  va_outside_actions = va_outside_actions + [_action_id];


  //Add view vehicle information action
  _action_id = player addaction [format["<img image='addons\vactions\icons\info.paa'/> %1 info", _display_name], {_this call va_information_action;}, [_player, _vehicle],0,false,false,"",
  format["([objectFromNetId %1, objectFromNetId %2] call va_information_action_available)", str(netId _player), str(netId _vehicle)]];
  va_outside_actions = va_outside_actions + [_action_id];

  //Add vehicle lock action
  _action_id = player addaction [format["<img image='addons\vactions\icons\lock.paa'/> Lock %1", _display_name], {_this call va_lock_action;}, [_player, _vehicle],0,false,false,"",
  format["([objectFromNetId %1, objectFromNetId %2] call va_lock_action_available)", str(netId _player), str(netId _vehicle)]];
  va_outside_actions = va_outside_actions + [_action_id];

  //Add vehicle unlock action
  _action_id = player addaction [format["<img image='addons\vactions\icons\key.paa'/> Unlock %1", _display_name], {_this call va_unlock_action;}, [_player, _vehicle],999,true,false,"",
  format["([objectFromNetId %1, objectFromNetId %2] call va_unlock_action_available)", str(netId _player), str(netId _vehicle)]];
  va_outside_actions = va_outside_actions + [_action_id];
};

va_inside_actions = OR(va_inside_actions,[]);

va_inside_add_actions = {
  if (count va_inside_actions > 0) exitWith {};
  //player groupChat format["va_inside_add_actions %1", _this];
  ARGVX3(0,_player,objNull);
  ARGVX3(1,_vehicle,objNull);

  if (not(isPlayer _player)) exitWith {};

  def(_display_name);
  _display_name = [typeOf _vehicle] call generic_display_name;

  //Add vehicle lock action
  _action_id = player addaction [format["<img image='addons\vactions\icons\lock.paa'/> Lock %1", _display_name], {_this call va_lock_action;}, [_player, _vehicle],0,false,false,"",
  format["([objectFromNetId %1, objectFromNetId %2] call va_lock_action_available)", str(netId _player), str(netId _vehicle)]];
  va_inside_actions = va_inside_actions + [_action_id];

  //Add vehicle unlock action
  _action_id = player addaction [format["<img image='addons\vactions\icons\key.paa'/> Unlock %1", _display_name], {_this call va_unlock_action;}, [_player, _vehicle],10,false,false,"",
  format["([objectFromNetId %1, objectFromNetId %2] call va_unlock_action_available)", str(netId _player), str(netId _vehicle)]];
  va_inside_actions = va_inside_actions + [_action_id];
};


va_inside_remove_actions = {
  if (count va_inside_actions == 0) exitWith {};
  //player groupChat format["va_inside_remove_actions %1", _this];

  ARGVX3(0,_player,objNull);
  if (not(isPlayer _player)) exitWith {};

  {
    private["_action_id"];
    _action_id = _x;
    _player removeAction _action_id;
  } forEach va_inside_actions;
  va_inside_actions = [];
};


va_outside_target = {
  ARGVX3(0,_player,objNull);
  if (!isPlayer _player) exitWith {};

  def(_target);
  _objects = nearestObjects [_player, ["Helicopter", "Plane", "Ship_F", "Car", "Motorcycle", "Tank"], 10];
  if (!isARRAY(_objects) || {count _objects == 0}) exitWith {};
  _target = cursorObject;

  if (_player distance _target > 10) exitWith {};

  if (({_target isKindOf _x } count ["Helicopter", "Plane", "Ship_F", "Car", "Motorcycle", "Tank"]) == 0) exitWith {};

  _target
};


va_check_outside_actions = {
  //player groupChat format["va_check_outside_actions"];
  init(_player,player);


  _target_vehicle = [_player, 3.5] call va_outside_target;
  //player groupChat format["_target_vehicle = %1",_target_vehicle];
  if (!isOBJECT(_target_vehicle) || {insideAVehicle(_player) || {not(alive _player)}}) exitWith {
    [_player] call va_outside_remove_actions;
  };

  [_player, _target_vehicle] call va_outside_add_actions;
};

va_check_inside_actions = {
  //player groupChat format["va_check_inside_actions"];
  init(_player,player);

  if (!(alive _player) || {!insideAVehicle(_player)}) exitWith {
    [_player] call va_inside_remove_actions;
  };

  [_player, vehicle _player] call va_inside_add_actions;
};


va_client_loop_stop = false;
va_client_loop = {
  if (not(isClient)) exitWith {};
  private ["_va_client_loop_i"];
  _va_client_loop_i = 0;

  while {_va_client_loop_i < 5000 && {not(va_client_loop_stop)}} do {
    call va_check_outside_actions;
    call va_check_inside_actions;

    sleep 0.5;
    _va_client_loop_i = _va_client_loop_i + 1;
  };
  [] spawn va_client_loop;
};

[] spawn va_client_loop;

diag_log format["Loading vehicle actions functions complete"];

va_actions_functions_defined = true;