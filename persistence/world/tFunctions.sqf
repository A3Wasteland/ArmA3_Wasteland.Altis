diag_log "tFunctions.sqf loading ...";

#include "macro.h"

call compile preprocessFileLineNumbers "persistence\lib\shFunctions.sqf";

t_getScope = {
  ("Time" call PDB_ServerTimeFileName)
};

t_getTime = {
  ARGVX3(0,_scope,"");

  if (!isSTRING(_scope)) then {
    _scope = call t_getScope;
  };

  def(_info);
  _info = [_scope, "Info"] call stats_get;

  def(_info_pairs);
  _info_pairs = [OR(_info,nil)] call stats_hash_pairs;

  diag_log "_info_pairs";
  diag_log _info_pairs;

  def(_timeSaved);
  def(_dayTime);
  def(_fog);
  def(_overcast);
  def(_rain);
  def(_wind);

  def(_name);
  def(_value);
  {
    _name = _x select 0;
    _value = _x select 1;

    if (_name == "TimeSaved") then {
      _timeSaved = OR(_value,nil);
    }
    else { if (_name == "DayTime") then {
      _dayTime = OR(_value, nil);
    }
    else { if (_name == "Fog") then {
      _fog = OR(_value, nil);
    }
    else { if (_name == "Overcast") then {
      _overcast = OR(_value, nil);
    }
    else { if (_name == "Rain") then {
      _rain = OR(_value, nil);
    }
    else { if (_name == "Wind") then {
      _wind = OR(_value, nil);
    };};};};};};
  } forEach _info_pairs;

  if (!isSCALAR(_timeSaved) || {_timeSaved < 1}) exitWith {[]};

  ([OR(_dayTime,nil), OR(_fog,nil), OR(_overcast,nil), OR(_rain,nil), OR(_wind,nil)])
};

getTime = t_getTime;

t_saveTime = {
  ARGVX3(0,_scope,"");

  if (!isSTRING(_scope)) then {
    _scope = call t_getScope;
  };

  init(_request,[_scope]);

  init(_objName, "Info");
  _request pushBack [ _objName + "." + "TimeSaved", 1];
  _request pushBack [ _objName + "." + "DayTime", dayTime];
  _request pushBack [ _objName + "." + "Fog", fog];
  _request pushBack [ _objName + "." + "Overcast", overcast];
  _request pushBack [ _objName + "." + "Rain", rain];
  _request pushBack [ _objName + "." + "Wind", wind];

  _request call stats_set;
};

saveTime = t_saveTime;

t_saveLoop_iteration = {
  ARGVX3(0,_scope,"");
  diag_log format["t_saveLoop: Saving time ... "];
  [[_scope], t_saveTime] call sh_fsm_invoke;
  diag_log format["t_saveLoop: Saving time complete"];
};


t_saveLoop_iteration_hc = {
  ARGVX3(0,_scope,"");

  init(_hc_id,owner HeadlessClient);
  diag_log format["t_saveLoop: Offloading time saving to headless client (id = %1)", _hc_id];

  t_saveLoop_iteration_hc_handler = [_scope];
  _hc_id publicVariableClient "t_saveLoop_iteration_hc_handler";
};

if (!(hasInterface || isDedicated)) then {
  diag_log format["Setting up HC handler for time"];
  "t_saveLoop_iteration_hc_handler" addPublicVariableEventHandler {
    //diag_log format["t_saveLoop_iteration_hc_handler = %1", _this];
    ARGVX3(1,_this,[]);
    ARGVX3(0,_scope,"");
    _this spawn t_saveLoop_iteration;
  };
};

t_saveLoop = {
  ARGVX3(0,_scope,"");
  while {true} do {
    sleep A3W_time_saveInterval;
    if (not(isBOOLEAN(t_saveLoopActive) && {!t_saveLoopActive})) then {
      if (call sh_hc_ready) then {
        [_scope] call t_saveLoop_iteration_hc;
      }
      else {
        [_scope] call t_saveLoop_iteration;
      };
    };
  };
};



t_loadTime = {
  ARGVX3(0,_scope,"");

  if (not(["A3W_timeSaving"] call isConfigOn)) exitWith {};

  def(_time);
  _time = [_scope] call  t_getTime;

  if (!isARRAY(_time)) exitWith {};

  diag_log format["===========> Time from Database: %1", OR(_time,nil)];

  def(_dayTime);
  def(_date);

	_dayTime = _time param [0, dayTime, [0]];
	_date = date;
	_date set [3, 0];
	_date set [4, _dayTime * 60];

	setDate _date;

	diag_log format["===========> Extracted daytime: %1", _dayTime];

	currentDate = date;
	publicVariable "currentDate";

	A3W_timeSavingInitDone = compileFinal 'true';
	publicVariable "A3W_timeSavingInitDone";

	[_time] call t_initWeather;
};


t_initWeather = {
  ARGVX2(0,_time)
  if (not(["A3W_weatherSaving"] call isConfigOn)) exitWith {};

	if (!isNil "drn_DynamicWeather_MainThread") then { terminate drn_DynamicWeather_MainThread };
	if (!isNil "drn_DynamicWeather_WeatherThread") then { terminate drn_DynamicWeather_WeatherThread };
	if (!isNil "drn_DynamicWeather_RainThread") then { terminate drn_DynamicWeather_RainThread };
	if (!isNil "drn_DynamicWeather_FogThread") then { terminate drn_DynamicWeather_FogThread };

	drn_DynamicWeather_MainThread = (_time select [1,4]) execVM "addons\scripts\DynamicWeatherEffects.sqf";
};


diag_log "tFunctions.sqf loading complete";