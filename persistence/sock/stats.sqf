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
*   ["scope1", "key1", "value1"] call stats_set;
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
 *   ["scope1", ["key1", "value1"], ["key2", "value2"])] call stats_set;
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
*   ["scope1", "key1", "value1"] call stats_push;
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
 *   ["scope1", ["key1", "value1"], ["key2", "value2"]] call stats_push;
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
*   ["scope1", "key1", "value1"] call stats_unshift;
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
 *   ["scope1", ["key1", "value1"], ["key2", "value2"]] call stats_unshift;
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

/**
* This function merges the given {@code _value} with the existing value at the specified {@code _key}, and within the given scope {@code _scope}
*
* e.g.
*
*   //merges the _hash into the existing value at "key1"
*   private["_hash"];
*   _hash = [
*             ["child1", "val1"],
*             ["child2", "val2"]
*           ] call sock_hash;
*
*   ["scope1", "key1", _hash] call stats_merge;
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key to merge into
* @param {*} _value Value to merge
*
* @returns {boolean}  true on success, false on failure
*/


/**
 * This function merges one or more values into the existing values at the specified keys within the given {@code _scope}
 *
 * e.g.
 *
 *   private["_hash1", "_hash2"];
 *   _hash1 = [
 *             ["child1", "val1"],
 *             ["child2", "val2"]
 *           ] call sock_hash;
 *
 *   _hash12= [
 *             ["child1", "val1"],
 *             ["child2", "val2"]
 *           ] call sock_hash;
 *
 *   //merges _hash1 into the value at "key1", and _hash2 into the value at "key2"
 *   ["scope1", ["key1", _hash1], ["key2", _hash2]] call stats_merge;
 *
 *
 * @param {String} _scope Name of the scope to use
 * @param {...Array} _pair  Key-value pair
 * @param {String} _pair[0] Name of the key to merge into
 * @param {*} _pair[1] Value to merge
 *
 * @returns true on success, false on failure
 *
 */

stats_merge = {
  (["merge", _this] call stats_write)
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
*  ["scope", "key1", "default1"] call stats_get;
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
*   ["scope1"] call stats_get;
*
*   //get the values for "key1", "key2", and "key3"
*   ["scope1", ["key1", "default1"], [key2, "default2"], ["key3"]] call stats_get;
*
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
* On failure, returns nil
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
*  ["scope", "key1"] call stats_pop;
*
*  //pop the value for array at "key1", or use "default1" if not found
*  ["scope", "key1", "default1"] call stats_pop;
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
*   ["scope1", ["key1", "default1"], [key2, "default2"], ["key3"]] call stats_pop;
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
* On failure, returns nil
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
*  ["scope", "key1"] call stats_shift;
*
*  //shift the value for array at "key1", or use "default1" if not found
*  ["scope", "key1", "default1"] call stats_shift;
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
*   ["scope1", ["key1", "default1"], [key2, "default2"], ["key3"]] call stats_shift;
*
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
* On failure, returns nil
*
*/
stats_shift = {
  (["shift", _this] call stats_read)
};

/**
* This function counts the child keys within the given {@code _scope}
*
* e.g.
*
*  //count child keys at "scope1"
*  ["scope"] call stats_count;
*
*
* @param {String} _scope  Name of the scope to use
*
* @return
*
* The count of child keys at the specified {@code _scope}
*
*/

/**
* This function counts the child keys at the specified {@code _key}, within the given {@code _scope}
*
* e.g.
*
*  //count child keys at "key1"
*  ["scope", "key1"] call stats_count;
*
*  //count the child keys at "key1", or use -1 if not found
*  ["scope", "key1", -1] call stats_count;
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key where child keys will be counted
* @param {*} [_default] Default value to use if {@code _key} does not exist
* @return
*
* The count of child keys at the specified {@code _key}
*
*/

/**
* This function counts the child keys for one or more of the specified keys, within the given {@code _scope}
*
* e.g.
*
*
*   //count the child keys at "key1", "key2", and "key3"
*   ["scope1", ["key1", -1], [key2, -1], ["key3", -1]] call stats_count;
*
*
* @param {Strnig} _scope  Name of the scope to use
* @param {...Array} [_pair] One or more key-value pairs
* @param {String} [_pair[0]] Name of the key where child keys will be counted
* @param {*} [_pair[1]] Default value to use, if key is not found
*
* @return
*
* On success, returns array containing the key-value pairs.
* e.g.
*
* [["key1", 0],["key2", 2], ["key3", -1], ...]
*
* On failure, returns nil
*
*/
stats_count = {
  (["count", _this] call stats_read)
};



/**
* This function retrieves the names of child keys within the given {@code _scope}
*
* e.g.
*
*  //retrieve the names of child keys at "scope1"
*  ["scope"] call stats_keys;
*
*
* @param {String} _scope  Name of the scope to use
*
* @return
*
* Array containing the names of child keys
*
* e.g.
*
*   ["key1", "key2", "key3", ...]
*
*
*/

/**
* This function retrievs the names of child keys at the specified {@code _key}, within the given {@code _scope}
*
* e.g.
*
*  //retrieve the names of child keys at "key1"
*  ["scope", "key1"] call stats_keys;
*
*  //retrieve the names of child keys at "key1", or use nil if not found
*  ["scope", "key1", nil] call stats_keys;
*
* @param {String} _scope  Name of the scope to use
* @param {String} _key Name of the key where the names of child keys will be retrieved
* @param {*} [_default] Default value to use if {@code _key} does not exist
* @return
*
* On success returns an array with the names of the child keys within specified {@code _key}
*
* e.g.
*
*  [ "a", "b", "c"]
*
* On failure, or if the key is not found, returns the default value
*
*/

/**
* This function retrieves the names of child keys for one or more of the specified keys, within the given {@code _scope}
*
* e.g.
*
*
*   //retrieve the names of child keys at "key1", "key2", and "key3"
*   ["scope1", ["key1", nil], ["key2", []], ["key3", nil]] call stats_keys;
*
*
* @param {Strnig} _scope  Name of the scope to use
* @param {...Array} [_pair] One or more key-value pairs
* @param {String} [_pair[0]] Name of the key where the names of chikd keys will be retreived
* @param {*} [_pair[1]] Default value to use, if key is not found
*
* @return
*
* On success, returns array containing the key-value pairs.
* e.g.
*
* [["key1", ["a", "b", "c"]],["key2", []], ["key3", nil], ...]
*
* On failure, returns nil
*
*/

stats_keys = {
  (["keys", _this] call stats_read)
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


  /* For single result operations,  - Expect anything
   *   get(scope, key, default)
   *   shift(scope, key default)
   *   pop(scope, key, default)
   *   count(scope)
   *   keys(scope)
   * Expect anything as the result
   */
  if (isSTRING(xGet(_params,1)) || {
      ((["keys","count"] find _method) >= 0 && { undefined(xGet(_params,1))})
      }) exitWith {
    OR(_result,nil)
  };

  /* For multi result operations,
   *   get(scope)
   *   get(scope, [k,v],...)
   *   pop(scope, [k,v],...)
   *   shift(scope, [k,v],...)
   *   keys(scope, [k,v],...)
   *   count(scope, [k,v],...)
   * Expect  as result
   *
   * A code {[["k", "v"],["k", "v"],...]} for a sucessful response
   * A string result might indicate an error message
   * A nil result is an outright failure
   */


  if (undefined(_result)) exitWith {
    format["was expecting _result of typeName %1, but instead got nil during %2 operation", typeName {}, _method] call stats_log_severe;
    nil
  };

  //an error must have occurred
  if (isSTRING(_result)) exitWith {
    _result call stats_log_severe;
    nil
  };

  if (not(isCODE(_result))) exitWith {
    format["was expecting _result of typeName %1, but instead got typeName %2 during %3 operation", typeName {}, typeName _result, _method] call stats_log_severe;
    nil
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
  format["%1 stats_flush;", _this] call stats_log_fine;

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




/**
* This function wipes all keys within a specific scope
*
*
* e.g.
*
*  //wipe all keys for "scope1"
*  stats_wipe("scope1");
*
* @param {String} _scope Scope to wipe
* @return
*
* True on success, false on failure
*
*/
stats_wipe = {
  if (isNil "_this") exitWith {fale};
  format["%1 stats_wipe;", _this] call stats_log_fine;

  if (!isARRAY(_this)) exitWith {false};

  init(_method, "wipe");
  init(_params,_this);

  def(_result);
  _result = [_method, _params] call sock_rpc;
  if (undefined(_result)) exitWith {false};


  if (isSTRING(_result)) exitWith {
    _result call stats_log_severe;
    false
  };

  if (not(isBOOLEAN(_result))) exitWith {
    format["protocol error: was expecting _result of typeName %1, but instead got typeName %2", typeName false, typeName _result] call stats_log_severe;
    false
  };

  _result
};



diag_log format["loading stats library complete"];