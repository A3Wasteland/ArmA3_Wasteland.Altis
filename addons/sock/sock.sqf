diag_log format["loading sock library ..."];
#include "macro.h"

//Some wrappers for logging
sock_log_severe = {
  ["sock", _this] call log_severe;
};

sock_log_info = {
  ["sock", _this] call log_info;
};

sock_log_fine = {
  ["sock", _this] call log_fine;
};

sock_log_finer = {
  ["sock", _this] call log_finer;
};

sock_log_finest = {
  ["sock", _this] call log_finest;
};


sock_log_set_level = {
  ["sock", _this] call log_set_level;
};


//Set default logging level for this component
LOG_INFO_LEVEL call sock_log_set_level;


/**
* This function escapes all instances of {@code _char} within the
* specified string {@code _str}
*
* @param _str (String type)
* @param _char (String type)
* @return
*
* Returns the same {@code _str} value, but with all intances  of {@code _char}
* escaped with a back-slash character '\'. If the string already contains
* back-slashes, they are also escaped.
*
*/

sock_json_string_escape = {
  ARGV2(0,_str);
  ARGV2(1,_char);

  private["_str_data", "_new_str_data", "_target_char"];
  _str_data = toArray(_str);
  _new_str_data = [];
  _target_char = (toArray(_char)) select 0;

  private["_escape_char", "_escaped", "_count", "_i"];
  _escape_char = 92; // ASCII value for back-slash
  _escaped = false;
  _count = count(_str_data);
  _i = 0;
  while {_i < _count} do {
    _current_char = _str_data select _i;
    if (_escaped) then {
      _escaped = false;
      _new_str_data set [count(_new_str_data), _current_char];
    }
    else { if (_current_char == _target_char) then {
      _new_str_data set [count(_new_str_data), _escape_char];
      _new_str_data set [count(_new_str_data), _current_char];
    }
    else { if ( _current_char == _escape_char) then {
      _escaped = true;
      _new_str_data set [count(_new_str_data), _escape_char];
    }
    else {
      _new_str_data set [count(_new_str_data), _current_char];
    };};};
    _i = _i + 1;
  };

  toString(_new_str_data)
};

/**
* This function recursively converts an SQF value into its equivalent JSON representation.
*
* @param _data (Any type) - Data to be converted to JSON
* @return
*
* Returns the JSON representation of {@code data}.
*
* SQF array, is mapped directly to JSON array
* SQF number, is mapped directly to JSON number
* SQF string, is escaped so that it does not have nested double-quotes, and then mapped to JSON string
* SQF nil, is mapped to JSON null
* SQF objNull, is mapped to JSON null
* SQF objects, are mapped to a simplified JSON object with the netId, and the name of the SQF object
*
*/

sock_json = {
  if (undefined(_this)) exitWith {
    "null"
  };


  def(_type);
  _type =  typeName _this;

  init(_data,_this);

  if (_type == typeName "") exitWith {
    str([_data, """"] call sock_json_string_escape)
  };

  if (_type == typeName 0) exitWith {
    (format["%1", _data])
  };

  if (_type == typeName objNull) exitWith {
    ('{"netId":' + ((netId _data) call sock_json) + ',"name":' + ((name _data) call sock_json) + '}')
  };

  if (_type == typeName []) exitWith {
    private["_array_json", "_i", "_count", "_element", "_element_json"];
    _array_json = "[";
    _count = count(_data);
    _i = 0;
    while {_i < _count} do {

      _element = _data select _i;
      _element_json = if (isNil "_element") then { "null" } else {_element call sock_json};

      if (_i == 0) then {
        _array_json = _array_json + _element_json;
      }
      else {
        _array_json = _array_json + "," + _element_json;
      };
      _i = _i + 1;
    };
    _array_json = _array_json + "]";
    (_array_json)
  };

  //other types, just convert to string
  (str(_data) call sock_json)
};

/**
* This function talks directly to the sock.dll extension using the SOCK-SQF protocol.
*
* @param _request (String type) - This is the actual text to be sent to the remote side.
* @return
*
* On success, returns the reponse string that was sent by the remote side
* On failure, returns nil
*/
sock_get_response = {
  if (isNil "_this") exitWith {};
  format["%1 call sock_get_response;", _this] call sock_log_finest;

  if (typeName _this != typeName "") exitWith {};


  init(_request,_this);
  init(_extension,"sock");

  //("sock_get_response: _request=" + _request) call sock_log_fine;

  def(_response_info);
  _response_info = call compile (_extension callExtension _request);

  if (undefined(_response_info)) exitWith {
    (format["protocol error: Was expecting response of typeName of %1, but got %2", (typeName []), "nil"]) call sock_log_severe;
    nil
  };


  if (isSTRING(_response_info)) exitWith {
    ("error: " + _response_info) call sock_log_severe;
    nil
  };

  if (not(isARRAY(_response_info))) exitWith {
   (format["protocol error: Was expecting response of typeName of %1, but got %2", (typeName []), typeName _response_info]) call sock_log_severe;
   nil
  };

  init(_chunks,_response_info);
  init(_chunk_count,count(_chunks));

  init(_i,0);
  init(_response,"");

  //retrieve all the response chunks, and concatenate them
  while {_i < _chunk_count } do {
    init(_address,xGet(_chunks,_i));
    def(_data);
    _data = _extension callExtension (_address);
     _response = _response + _data;
     _i = _i + 1;
  };

  format["sock_get_response: _response = %1",  OR(_response,"nil")] call sock_log_finest;
  OR(_response,nil)
};


/**
* This function sends a JSON-RPC request using the sock.dll/sock.so extension.
*
* @param _method (String type) - This is the name of the remote method to be invoked
* @param _params (Array type) - This is an array of arguments to be passed in, when invoking {@code _method}
* @param default (Any type) - This is the value to return if there is an error
* @return
*
* On success, returns the response from the RPC server
* On failure, returns the value of the {@code _default} argument, or nil if {@code _default} was not specified.
*/
sock_rpc = {
  if (isNil "_this") exitWith {nil};
  format["%1 call sock_rpc;", _this] call sock_log_finest;

  if (not(isServer)) exitWith {
    (_this call sock_rpc_remote)
  };

  (_this call sock_rpc_local)
};


sock_rpc_remote = {
  if (isNil "_this") exitWith {nil};
  format["%1 call sock_rpc_remote;", _this] call sock_log_finest;

  init(_request,_this);

  if (not(isClient)) exitWith {nil};

  def(_var_name);
  _var_name = format["sock_rpc_remote_response_%1",ceil(random 10000)];
  missionNamespace setVariable [_var_name, nil];
  missionNamespace setVariable [sock_rpc_remote_request_name, [player, _var_name, _request]];
  publicVariableServer sock_rpc_remote_request_name;


  def(_response);
  init(_end_time, time + 5);
  while {true} do {
    _response = missionNamespace getVariable [_var_name, nil];
    if (!isNil "_response") exitWith {};
    if (time > _end_time) exitWith {};
    sleep 0.01;
  };
  missionNamespace setVariable [_var_name, nil];

  if (undefined(_response)) exitWith {
    format["timeout occurred while waiting for response of %1", _var_name] call sock_log_severe;
    nil
  };

  if (not(isARRAY(_response))) exitWith {
    format["protocol error, expected response to be of type %1", typeName []] call sock_log_severe;
    nil
  };

  if (count(_response) == 0) exitWith {
    format["protocol error, expected response to have at least one element"] call sock_log_severe;
    nil
  };

  (_response select 0)
};




sock_rpc_remote_request_listener = {
  if (isNil "_this") exitWith {nil};
  format["%1 call sock_rpc_remote_request_listener;", _this] call sock_log_finest;

  private["_variable", "_request"];

  ARGV3(0,_variable,"");
  ARGV3(1,_request,[]);

  if (undefined(_variable) || {undefined(_request)}) exitWith {nil};

  _this = _request;
  ARGVX3(0,_client,objNull);
  ARGVX3(1,_var_name,"");
  ARGVX3(2,_args,[]);

  private["_response"];
  _response = _args call sock_rpc_local;
  _response = [OR(_response,nil)];

  private["_client_id"];
  _client_id = owner _client;

  missionNamespace setVariable [_var_name, _response];
  format["sock_rpc_remote_request_listener: client_id: %1", _client_id] call sock_log_finest;
  format["sock_rpc_remote_request_listener: response: %1", _response] call sock_log_finest;
  _client_id publicVariableClient _var_name;
  missionNamespace setVariable [_var_name, nil];
};



sock_rpc_local = {
  if (isNil "_this") exitWith {nil};
  format["%1 call sock_rpc_local;", _this] call sock_log_finest;

  ARGV3(0,_method,"");
  ARGV3(1,_params,[]);
  ARGV2(2,_default)

  if (undefined(_method)) exitWith {nil};
  initIf(defined(_params),_params_str,(_params call sock_json),'[]');

  private["_json_rpc"];
  _json_rpc = '{"method":' + str(_method) + ', "params":' + _params_str + '}';
  //format["_json_rpc = %1;", _json_rpc] call sock_log_finest;

  private["_result_container"];
  _result_container = call compile(_json_rpc call sock_get_response);


  if (isNil "_result_container") exitWith {
    (format["protocol error: Was expecting response of typeName of %1, but got %2", (typeName []), "nil"]) call sock_log_severe;
    if (isNil "_default") exitWith {nil};
    OR(_default,nil)
  };

  if (typeName _result_container != typeName []) exitWith {
    (format["protocol error: Was expecting response of typeName of %1, but got %2", (typeName []), (typeName _result_container)]) call sock_log_severe;
    if (isNil "_default") exitWith {nil};
    OR(_default,nil)
  };

  if (count _result_container < 2) exitWith {
    (format["protocol error: Was expecting response count of %1, but got %2 ", 2, count(_result_container)]) call sock_log_severe;
    if (isNil "_default") exitWith {nil};
    OR(_default,nil)
  };

  private["_error", "_result"];
  _this = _result_container;
  ARGV3(0,_error,false);
  ARGV2(1,_result);

  //success case
  if (not(_error)) exitWith {
    OR(_result,nil)
  };

  //error cases
  if (typeName _result != typeName "") exitWith {
    (format["protocol error: Was expecting error response of typeName %1, but got %2", (typeName ""), (typeName _result)]) call sock_log_severe;
    if (isNil "_default") exitWith {nil};
    OR(_default,nil)
  };

  (format["remote error: %1", _result]) call sock_log_severe;
  OR(_default,nil)
};




sock_init = {
  init(_flag_name, "sock_init_complete");

  sock_rpc_remote_request_name = "sock_rpc_remote_request";
  //Server-side init
  if (isServer) then {
    sock_rpc_remote_request_name addPublicVariableEventHandler { _this call sock_rpc_remote_request_listener;};

    //tell clients that server pstats has initialized
    missionNamespace setVariable[_flag_name, true];
    publicVariable _flag_name;
    "sock_rpc library loaded on server ..." call sock_log_info;
  };

  //Client-side init (must wait for server-side init to complete)
  if (isClient) then {
    "waiting for server to load sock_rpc library ..." call sock_log_info;
    waitUntil {not(isNil _flag_name)};
    "waiting for server to load sock_rpc library ... done" call sock_log_info;
  };
};


[] call sock_init;

diag_log format["loading sock library complete"];