if (!isNil "shFunctions_loased") exitWith {};
diag_log "shFunctions loading ...";

#include "macro.h"

call compile preProcessFileLineNumbers "persistence\lib\normalize_config.sqf";

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

sh_isUAV = {
  ARGVX4(0,_obj,objNull,false);
  (getNumber(configFile >> "CfgVehicles" >> typeOf _obj >> "isUav") > 0)
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
  private ["_result"];
  ARGVX3(0,_object_data,[]);
  ARGVX3(1,_searchForKey,"");
  
  if (!(isARRAY(_object_data))) exitWith {};
  if (!(isSTRING(_searchForKey))) exitWith {};
  
  {
    _key = _x select 0;
    _value = _x select 1;
    switch (_key) do {
      case _searchForKey: { _result = OR(_value,nil);};
    };
  } forEach _object_data;
  
  if (isNil "_result") then {
    diag_log format ["Error: %1 does not have %2!"],_x,_searchForKey;
  }else{
    (_result);
  };
};

shFunctions_loased = true;
diag_log "shFunctions loading complete";