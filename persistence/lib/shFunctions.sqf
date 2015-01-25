if (!isNil "shFunctions_loaded") exitWith {};
diag_log "shFunctions loading ...";

#include "macro.h"


sh_isSaveableVehicle = {
  ARGVX4(0,_obj,objNull,false);

  init(_result, false);
  {
    if (_obj isKindOf _x) exitWith {
      _result = true;
    };
  } forEach A3W_saveable_vehicles_list;

  (_result)
};

sh_strToSide = {
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


sh_restoreVariables = {
  ARGVX3(0,_obj,objNull);
  ARGVX3(1,_variables,[]);

  def(_name);
  def(_value);

  {
    _name = _x select 0;
    _value = _x select 1;

    if (!isNil "_value") then {
      switch (_name) do {
        case "side": { _value = _value call sh_strToSide};
        case "R3F_Side": { _value = _value call sh_strToSide };
        case "ownerName": {
          switch (typeName _value) do {
            case "ARRAY": { _value = toString _value };
            case "STRING": { /* do nothing, it's already a string */ };
            default { _value = "[Unknown]" };
          };
        };
      };
    };

    _obj setVariable [_name, OR(_value,nil), true];
  } forEach _variables;
};

sh_isStaticWeapon = {
  ARGVX4(0,_obj,objNull,false);
  init(_class,typeOf _obj);
  (_class isKindOf "StaticWeapon")
};

sh_isBeacon = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["a3w_spawnBeacon", false])
};

sh_isBox = {
  ARGVX4(0,_obj,objNull,false);
  init(_class,typeOf _obj);
  (_class isKindOf "ReammoBox_F")
};

sh_isWarchest = {
  ARGVX4(0,_obj,objNull,false);
  (
    _obj getVariable ["a3w_warchest", false] && {
    (_obj getVariable ["side", sideUnknown]) in [WEST,EAST]}
  )
};

sh_isAMissionVehicle = {
  ARGVX4(0,_obj,objNull,false);
  def(_mission);
  _mission = _obj getVariable "A3W_missionVehicle";
  (isBOOLEAN(_mission) && {_mission})
};


sh_isAPurchasedVehicle = {
  ARGVX4(0,_obj,objNull,false);
  def(_purchased);
  _purchased = _obj getVariable "A3W_purchasedVehicle";
  (isBOOLEAN(_purchased) && {_purchased})
};

sh_isUAV_UGV = {
  ARGVX4(0,_obj,objNull,false);
  (getNumber(configFile >> "CfgVehicles" >> typeOf _obj >> "isUav") > 0)
};

sh_isUAV = {
  ARGV2(0,_arg);

  def(_class);
  if (isOBJECT(_arg)) then {
    _class = typeOf _arg;
  }
  else { if (isSTRING(_arg)) then {
    _class = _arg;
  }};

  if (isNil "_class") exitWith {false};

  (_class isKindOf "UAV_02_base_F" || {_class isKindOf "UAV_01_base_F"})
};


sh_getVehicleTurrets = {
  def(_default);
  _default = [nil,nil,nil];
  ARGVX4(0,_veh,objNull,_default);

  def(_all_turrets);
  _all_turrets = [magazinesAmmo _veh, [], []];

  def(_class);
  _class = typeOf _veh;

  def(_turretMags);
  def(_turretMags2);
  def(_turretMags3);

  _turretMags = _all_turrets select 0;
  _turretMags2 = _all_turrets select 1;
  _turretMags3 = _all_turrets select 2;

  def(_hasDoorGuns);
  _hasDoorGuns = isClass (configFile >> "CfgVehicles" >> _class >> "Turrets" >> "RightDoorGun");

  def(_turrets);
  _turrets = allTurrets [_veh, false];

  if !(_class isKindOf "B_Heli_Transport_03_unarmed_F") then {
    _turrets = [[-1]] + _turrets; // only add driver turret if not unarmed Huron, otherwise flares get saved twice
  };

  if (_hasDoorGuns) then {
    // remove left door turret, because its mags are already returned by magazinesAmmo
    {
      if (_x isEqualTo [1]) exitWith {
        _turrets set [_forEachIndex, 1];
      };
    } forEach _turrets;

    _turrets = _turrets - [1];
  };


  {if (true) then {
    _path = _x;
    if (str(_path) == "[0]") exitWith {}; //don't look at the mags from the first turret again

    {
      if (([_turretMags, _x, -1] call fn_getFromPairs == -1) || {_hasDoorGuns}) then {
        if (_veh currentMagazineTurret _path == _x && {count _turretMags3 == 0}) then {
          _turretMags3 pushBack [_x, _path, [_veh currentMagazineDetailTurret _path] call getMagazineDetailAmmo];
        }
        else {
          _turretMags2 pushBack [_x, _path];
        };
      };
    } forEach (_veh magazinesTurret _path);
  }} forEach _turrets;

  (_all_turrets)
};


sh_restoreVehicleTurrets = {
  ARGVX3(0,_veh,objNull);
  ARGV3(1,_turret0,[]);
  ARGV3(2,_turret1,[]);
  ARGV3(3,_turret2,[]);

  //legacy data did not contain turret information, in that case, don't attempt to restore them
  if (isNil "_turret0" && {isNil "_turret1" && {isNil "_turret3"}}) exitWith {};

  _veh setVehicleAmmo 0;

  if (!isNil "_turret2") then {
    {
      _veh addMagazineTurret [_x select 0, _x select 1];
      _veh setVehicleAmmo (_x select 2);
    } forEach _turret2;
  };

  if (!isNil "_turret0") then {
    { _veh addMagazine _x } forEach _turret0;
  };

  if (!isNil "_turret1") then {
    { _veh addMagazineTurret _x } forEach _turret1;
  };

};


sh_getValueFromPairs = {
  ARGVX3(0,_object_data,[]);
  ARGVX3(1,_searchForKey,"");

  def(_result);
  def(_key);
  def(_value);

  {
    _key = _x select 0;
    _value = _x select 1;
    if (_key == _searchForKey) exitWith {
      _result = OR(_value,nil)
    };
  } forEach _object_data;
  
  if (isNil "_result") exitWith {
    //diag_log format ["Error: %1 does not have %2!", _x, _searchForKey];
    nil
  };


  (_result);
};


sh_fsm_invoke = {
  //diag_log format["%1 call sh_fsm_invoke", _this];
  ARGV2(0,_left);
  ARGVX2(1,_right);
  ARGV4(2,_async,false,false);

  if (!isCODE(_right)) exitWith {};
  if (isNil "_left") then {
    _left = [];
  };


  def(_var_name);
  _var_name = format["var_%1",ceil(random 10000)];

  def(_fsm);
  _fsm = [_var_name, _left, _right] execFSM "persistence\sock\call3.fsm";

  //if async, return the name of the variable that will hold the results
  if (_async) exitWith {_var_name};

  waitUntil {completedFSM _fsm};

  def(_result);
  _result = (missionNamespace getVariable _var_name);
  missionNamespace setVariable [_var_name, nil];
  OR(_result,nil)
};

sh_isFlying = {
  ARGV2(0,_arg);

  init(_flying_height,20);

  if (isOBJECT(_arg)) exitWith {
    (!isTouchingGround _arg && (getPos _arg) select 2 > _flying_height)
  };

  if (isPOS(_arg)) exitWith {
   (_arg select 2 > _flying_height)
  };

  false
};

sh_drop_player_inventory = {
  //Taken from onKilled. Drop player items and money.
  private["_player", "_money"];
  _player = _this;
  _money = _player getVariable ["cmoney", 0];
  _player setVariable ["cmoney", 0, true];

  // wait until corpse stops moving before dropping stuff
  waitUntil {(getPos _player) select 2 < 1 && vectorMagnitude velocity _player < 1};

  // Drop money
  private["_m"];
  if (_money > 0) then
  {
    _m = createVehicle ["Land_Money_F", getPosATL _player, [], 0.5, "CAN_COLLIDE"];
    _m setDir random 360;
    _m setVariable ["cmoney", _money, true];
    _m setVariable ["owner", "world", true];
  };

  // Drop items
  private["_inventory", "_id", "_qty",  "_type", "_object"];
  _inventory = _player getVariable ["inventory",[]];
  {   
    _id = _x select 0;
    _qty = _x select 1;
    _type = _x select 4;
    for "_i" from 1 to _qty do {
    _obj = createVehicle [_type, getPosATL _player, [], 0.5, "CAN_COLLIDE"];
    _obj setDir getDir _player;
    _obj setVariable ["mf_item_id", _id, true];
    };
  } forEach _inventory;
};

sh_hc_ready = {
  (!isNil "HeadlessClient" && {
   !isNull HeadlessClient && {
   HeadlessClient getVariable ["hc_ready",false]}})
};


sh_sync_request_handler = {
  if (!isServer) exitWith {};
  ARGVX3(1,_this,[]);
  ARGVX3(0,_client,objNull);
  ARGVX3(1,_var,"");
  ARGVX3(2,_flag,"");

  init(_id,owner _client);
  diag_log format["Syncing %1 to client (_id = %2)" ,_var, _id];
  _id publicVariableClient _var;

  //set flag to indicate result is ready
  missionNamespace setVariable [_flag, true];
  _id publicVariableClient _flag;
  missionNamespace setVariable [_flag, nil];
};

if (isServer) then {
  "sh_sync_request" addPublicVariableEventHandler { _this spawn sh_sync_request_handler;};
};

if (not(hasInterface || isDedicated)) then {
  sh_sync = {
    if (isServer) exitWith {};
    ARGVX3(0,_var);

    def(_flag);
    _flag = format["sync_flag_%1_%2", ceil(random 1000), ceil(random 1000)];
    sh_sync_request = [player,_var,_flag];
    publicVariableServer "sh_sync_request";

    init(_timed_out,false);
    init(_end_time,diag_tickTime + 10);
    waitUntil {
      if (not(isNil{missionNamespace getVariable _flag})) exitWith {true};
      if (diag_tickTime > _end_time) exitWith {
        _timed_out = true;
        true
      };
      uiSleep 0.5;
    };

    if (_timed_out) exitWith {
      diag_log format["WARNING: Timeout occurred while waiting for value of variable %2", _var];
      false
    };
  };
};

sh_hc_forward = {_this spawn {
  ARGVX3(0,_var,"");
  if (not(hasInterface || isDedicated)) exitWith {};
  if (not(call sh_hc_ready)) exitWith {};
  init(_id, owner HeadlessClient);

  //diag_log format["Forwarding %1 to headless client (_id = %2)", _var, _id];
  _id publicVariableClient _var;
}};

shFunctions_loaded = true;
diag_log "shFunctions loading complete";