diag_log format["loading stats library ..."];
#include "macro.h"

//Some wrappers for logging
stats_log_severe = {
  ["stats", _this] call log_severe;
};

stats_log_warning = {
  ["stats", _this] call log_warning;
};

stats_log_info = {
  ["stats", _this] call log_info;
};

stats_log_fine = {
  ["stats", _this] call log_fine;
};

stats_log_finer = {
  ["stats", _this] call log_finer;
};

stats_log_finest = {
  ["stats", _this] call log_finest;
};

stats_log_set_level = {
  ["stats", _this] call log_set_level;
};


//Set default logging level for this component
LOG_INFO_LEVEL call stats_log_set_level;


stats_build_params = {
  if (isNil "_this") exitWith {};
  format["%1 stats_build_params;", _this] call stats_log_finest;

  ARGV3(0,_scope,"");
  ARGV2(1,_key_or_pairs);
  ARGV2(2,_default);


  if (undefined(_scope)) exitWith {nil};

  init(_params,[]);
  xPush(_params,_scope);


  //get(scope)
  if (undefined(_key_or_pairs)) exitWith {
    (_params)
  };

  if (not(isARRAY(_key_or_pairs) || {isSTRING(_key_or_pairs)})) exitWith {nil};

  //get(scope, pair,...)
  if (isARRAY(_key_or_pairs)) exitWith {
    init(_i,1);
    init(_count,count(_this));
    for [{}, {_i < _count}, {_i = _i + 1}] do { DO {
      ARGV3(_i,_pair,[]);
      if (undefined(_pair) || {count(_pair) == 0}) exitWith {};
      if (!isSTRING(xGet(_pair,0))) exitWith {};

      xPushIf(count(_pair) == 1,_pair,nil);
      xPush(_params,_pair);
    };};

    (_params)
  };

  //get(scope, key, default)
  xPush(_params,_key_or_pairs);
  xPush(_params,_default);

  (_params)
};


/**
* This function sets the given {@code _key}, and {@code _value} within the specified {@code _scope}
*
* e.g.
*
*   //set the value for "key1" in "scope1"
*   stats_set("scope1", "key1", "value1");
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key to set
* @param {*} _value Value to set
*
* @returns {boolean}  true on success, false on failure
*/


/**
 * This function sets one or more key-value {@code _pair}s within the specified {@code _scope}
 *
 * e.g.
 *
 *   //set values for "key1", and "key2" in "scope1"
 *   stats_set("scope1", ["key1", "value1"], ["key2", "value2"]);
 *
 *
 * @param {String} _scope Name of the scope to use
 * @param {...Array} _pair  Key-value pair
 * @param {String} _pair[0] Name of the key
 * @param {*} _pair[1] Value for the key
 *
 * @returns true on success, false on failure
 *
 */

stats_set = {
  (["set", _this] call stats_write)
};


/**
* This function pushes the given {@code _value} to the end of the array at {@code _key}, and within the specified {@code _scope}
*
* e.g.
*
*   //push the value into the array at "key1" within "scope1"
*   stats_push("scope1", "key1", "value1");
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key to push into
* @param {*} _value Value to push
*
* @returns {boolean}  true on success, false on failure
*/


/**
 * This function pushes one or more values into the specified keys within the given {@code _scope}
 *
 * e.g.
 *
 *   //push values into arrays at "key1", and "key2" within "scope1"
 *   stats_push("scope1", ["key1", "value1"], ["key2", "value2"]);
 *
 *
 * @param {String} _scope Name of the scope to use
 * @param {...Array} _pair  Key-value pair
 * @param {String} _pair[0] Name of the key to push into
 * @param {*} _pair[1] Value to push
 *
 * @returns true on success, false on failure
 *
 */
stats_push = {
  (["push", _this] call stats_write)
};

/**
* This function unshifts the given {@code _value} to the begining of the array at {@code _key}, and within the specified {@code _scope}
*
* e.g.
*
*   //unshift the value into the array at "key1" within "scope1"
*   stats_unshift("scope1", "key1", "value1");
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key to unshift into
* @param {*} _value Value to unshift
*
* @returns {boolean}  true on success, false on failure
*/


/**
 * This function unshifts one or more values into the specified keys within the given {@code _scope}
 *
 * e.g.
 *
 *   //unshift values into arrays at "key1", and "key2" within "scope1"
 *   stats_unshift("scope1", ["key1", "value1"], ["key2", "value2"]);
 *
 *
 * @param {String} _scope Name of the scope to use
 * @param {...Array} _pair  Key-value pair
 * @param {String} _pair[0] Name of the key to push into
 * @param {*} _pair[1] Value to push
 *
 * @returns true on success, false on failure
 *
 */
stats_unshift = {
  (["unshift", _this] call stats_write)
};


stats_write = {
  if (isNil "_this") exitWith {false};
  format["%1 stats_set;", _this] call stats_log_finest;

  ARGVX3(0,_operation,"");
  ARGVX3(1,_this,[]);

  init(_method,_operation);
  def(_params);
  _params = _this call stats_build_params;

  if (undefined(_params)) exitWith {false};


  def(_result);
  _result = ([_method, _params] call sock_rpc);
  if (undefined(_result)) exitWith {false};


  if (isSTRING(_result)) exitWith {
    _result call stats_log_severe;
    false
  };

  if (not(isBOOLEAN(_result))) exitWith {
    format["protocol error: was expecting _result of typeName %1, but instead got typeName %2", typeName true, typeName _result] call stats_log_severe;
    false
  };

  _result
};



/**
* This function gets the value of the given {@code _key}, within the specified {@code _scope}
*
* e.g.
*
*  //get the value for "key1"
*  stats_get("scope", "key1");
*
*  //get the value for "key1", or use "default1" if not found
*  stats_get("scope", "key1", "default1")
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key to set
* @param {*} [_default] Default value to use if {@code _key} does not exist
* @return
*
* The value assocaited with the specified {@code _key}
*
*/

/**
* This function gets multiple (or all) key-value pairs within the specified {@code _scope}
*
* e.g.
*
*   //get the values for all keys within "scope1"
*   stats_get("scope1")
*
*   //get the values for "key1", "key2", and "key3"
*   stats_get("scope1", ["key1", "default1"], [key2, "default2"], ["key3"])
*

* @param {Strnig} _scope  Name of the scope to use
* @param {...Array} [_pair] One or more key-value pairs to retrieve
* @param {String} [_pair[0]] Name of the key
* @param {*} [_pair[1]] Default value to use, if key is not found
*
* @return
*
* On success, returns array containing the key-value pairs.
* e.g.
*
* [["key1","value1"],["key2", "value2"],...]
*
* On failure, returns null
*
*/

stats_get = {
  (["get", _this] call stats_read)
};



/**
* This function pops the value at the end of the array at {@code _key}, within the specified {@code _scope}
*
* e.g.
*
*  //pop the value for array at "key1"
*  stats_pop("scope", "key1");
*
*  //pop the value for array at "key1", or use "default1" if not found
*  stats_pop("scope", "key1", "default1")
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key to pop value off
* @param {*} [_default] Default value to use if {@code _key} does not exist
* @return
*
* The value assocaited with the specified {@code _key}
*
*/

/**
* This function pops multiple values for the arrays at the specified keys, within the given {@code _scope}
*
* e.g.
*
*
*   //pop the values for arrays at "key1", "key2", and "key3"
*   stats_pop("scope1", ["key1", "default1"], [key2, "default2"], ["key3"])
*

* @param {Strnig} _scope  Name of the scope to use
* @param {...Array} [_pair] One or more key-value pairs to retrieve
* @param {String} [_pair[0]] Name of the key to pop value off
* @param {*} [_pair[1]] Default value to use, if key is not found
*
* @return
*
* On success, returns array containing the key-value pairs.
* e.g.
*
* [["key1","value1"],["key2", "value2"],...]
*
* On failure, returns null
*
*/

stats_pop = {
  (["pop", _this] call stats_read)
};


/**
* This function shifts the value at the begining of the array at {@code _key}, within the specified {@code _scope}
*
* e.g.
*
*  //shift the value for array at "key1"
*  stats_shift("scope", "key1");
*
*  //shift the value for array at "key1", or use "default1" if not found
*  stats_shift("scope", "key1", "default1")
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key to shift value out
* @param {*} [_default] Default value to use if {@code _key} does not exist
* @return
*
* The value assocaited with the specified {@code _key}
*
*/

/**
* This function shifts multiple values for the arrays at the specified keys, within the given {@code _scope}
*
* e.g.
*
*
*   //shift the values for arrays at "key1", "key2", and "key3"
*   stats_shift("scope1", ["key1", "default1"], [key2, "default2"], ["key3"])
*

* @param {Strnig} _scope  Name of the scope to use
* @param {...Array} [_pair] One or more key-value pairs to retrieve
* @param {String} [_pair[0]] Name of the key to shift value out
* @param {*} [_pair[1]] Default value to use, if key is not found
*
* @return
*
* On success, returns array containing the key-value pairs.
* e.g.
*
* [["key1","value1"],["key2", "value2"],...]
*
* On failure, returns null
*
*/
stats_shift = {
  (["shift", _this] call stats_read)
};


stats_read = {
  if (isNil "_this") exitWith {};
  format["%1 stats_get;", _this] call stats_log_fine;

  ARGVX3(0,_operation,"");
  ARGVX3(1,_this,[]);

  init(_method, _operation);
  init(_params,_this call stats_build_params);
  if (undefined(_params)) exitWith {nil};

  def(_result);
  _result = [_method, _params] call sock_rpc;

  //get(scope, key, default) - Expect anything
  if (isSTRING(xGet(_params,1))) exitWith {
    OR(_result,nil)
  };

  //get(scope) or get(scope, pair, ...) - Expect [["k", "v"],["k", "v"],...]
  _result = OR(_result,false);

  if (isSTRING(_result)) exitWith {
    _result call stats_log_severe;
    false
  };

  if (not(isCODE(_result))) exitWith {
    format["was expecting _result of typeName %1, but instead got typeName %2", typeName {}, typeName _result] call stats_log_severe;
    false
  };

  (call _result)

};

/**
* This function flushes data (on server side) associated with one or more scopes
*
* Flushing means that the remote data will be saved to the database, and removed from memory.
* This is useful to call once a player has disconnected from the server.
*
* e.g.
*
*  //flush the stats for "scope1"
*  stats_flush("scope1");
*
*  //flush the stats for "scope1", and "scope2"
*  stats_flush("scope1", "scope2")
*
* @param {...String} _scope One or more scope anmes
* @return
*
* The the number of scopes that were flushed.
*
*/
stats_flush = {
  if (isNil "_this") exitWith {};
  format["%1 stats_get;", _this] call stats_log_fine;

  if (!isARRAY(_this)) exitWith {nil};

  init(_method, "flush");
  init(_params,_this);

  def(_result);
  _result = [_method, _params] call sock_rpc;
  if (undefined(_result)) exitWith {nil};


  if (isSTRING(_result)) exitWith {
    _result call stats_log_severe;
    nil
  };

  if (not(isSCALAR(_result))) exitWith {
    format["protocol error: was expecting _result of typeName %1, but instead got typeName %2", typeName 0, typeName _result] call stats_log_severe;
    nil
  };

  _result
};



diag_log format["loading stats library complete"];