diag_log format["loading sock-rpc-stats iniDB API adapter ..."];

//load the iniDB adapter library
call compile preProcessFileLineNumbers "persistence\sock\main.sqf";

#include "macro.h"


//Some wrappers for logging
inidb_log_severe = {
  ["stats-iniDB", _this] call log_severe;
};

inidb_log_warning = {
  ["stats-iniDB", _this] call log_warning;
};

inidb_log_info = {
  ["stats-iniDB", _this] call log_info;
};

inidb_log_fine = {
  ["stats-iniDB", _this] call log_fine;
};

inidb_log_finer = {
  ["stats-iniDB", _this] call log_finer;
};

inidb_log_finest = {
  ["stats-iniDB", _this] call log_finest;
};

inidb_log_set_level = {
  ["stats-iniDB", _this] call log_set_level;
};


//Set default logging level for this component
LOG_INFO_LEVEL call inidb_log_set_level;


iniDB_version =  "1.2";

iniDB_HashFunction =  {
  "iniDB_HashFunction: not supported" call inidb_log_finest;
};

iniDB_CRC32 =  {
  "iniDB_CRC32: not supported" call inidb_log_finest;
};

iniDB_MD5 =  {
  "iniDB_MD5: not supported" call inidb_log_finest;
};


iniDB_Base64Encode =  {
  "iniDB_Base64Encode: not supported" call inidb_log_finest;
};

iniDB_Base64Decode =  {
  "iniDB_Base64Decode: not supported" call inidb_log_finest;
};

iniDB_exists =  {
  format["%1 call iniDB_exists;", _this] call inidb_log_finest;
  not(isNil{([_this] call stats_get)})
};


iniDB_delete =  {
  "iniDB_delete: not supported" call inidb_log_finest;
};

iniDB_deleteSection =  {
  format["%1 call iniDB_deleteSection;", _this] call inidb_log_finest;
  ARGVX3(0,_var,"");
  ARGVX3(1,_sec,"");

  ([_var, _sec, nil] call stats_set)
};


iniDB_readRaw =  {
  "iniDB_readRaw: not supported" call inidb_log_finest;
};


iniDB_writeRaw =  {
  "iniDB_writeRaw: not supported" call inidb_log_finest;
};


iniDB_Datarizer =  {
  "iniDB_Datarizer: not supported" call inidb_log_finest;
};



//cast a result according to iniDB rules
iniDB_cast_result = {
  ARGV2(0,_result);
  ARGV3(1,_type,"");

  //if no result, and no type, return empty string
  if (isNil "_result" && isNil "_type") exitWith {
    ""
  };

  //normalize _type
  if (not(isNil "_type")) then {
    _type = toUpper _type;
    if (_type == "NUMBER") then {
      _type = typeName 0;
    };
  };

  //no result, but type was specified, return an appropriate default value
  if (isNil "_result") exitWith {
    if (_type == typeName []) exitWith {[]};
    if (_type == typeName "") exitWith {""};
    if (_type == typeName 0) exitWith {0};
    ""
  };

  //no type specified, return result as-is
  if (isNil "_type") exitWith {
    _result
  };

  //both type, and result specified, but types did not match, do casting
  if (typeName _result != _type) exitWith {
    if (_type == typeName []) exitWith {[]};
    if (_type == typeName "") exitWith {str _result};
    if (_type == typeName 0) exitWith {parseNumber str _result};
    ""
  };

  _result
};

iniDB_read =  {
  format["%1 call iniDB_read;", _this] call inidb_log_finest;
  ARGVX3(0,_file,"");
  ARGVX3(1,_sec,"");
  ARGVX3(2,_key,"");
  ARGV3(3,_type,"");

  //iniDB has special rules about the return type
  def(_result);
  _result = ([([_file, _sec + "." + _key] call stats_get), OR(_type,nil)] call iniDB_cast_result);
  format["iniDB_read: _result = %1", _result] call inidb_log_finest;
  _result
};


iniDB_write =  {
  format["%1 call iniDB_write;", _this] call inidb_log_finest;
  ARGVX3(0,_file,"");
  ARGVX3(1,_sec,"");
  ARGVX3(2,_key,"");
  ARGV2(3,_data);

  ([_file, _sec + "." + _key, _data] call stats_set)
};

diag_log format["loading sock-rpc-stats iniDB API adapter complete"];