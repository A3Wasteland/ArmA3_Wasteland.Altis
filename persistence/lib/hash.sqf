if (!isNil "hash_loaded") exitWith {};
diag_log "hash loading ...";

#include "macro.h"

/**
 * Gets the key-value pair from the specified hash.
 *
 * e.g.
 *  [_hash, _key] call hash_get_key_value;
 *
 * This is useful if you need to pass the key-value pair by reference to another function
 *
 */
hash_get_key_value = {
  ARGVX3(0,_hash,[]);
  ARGVX3(1,_key,"");

  def(_result);
  def(_ckey);

  {
    if(true) then {
      if(!isARRAY(_x)) exitWith {};
      _ckey = _x select 0;
      if (!isSTRING(_ckey)) exitWith {};
      if (_ckey != _key) exitWith {};
      _result = _x;
    };
    if (!isNil "_result") exitWith {};
  } forEach _hash;

  OR(_result,nil)
};

/**
 * Gets the value for the given key within the specified hash
 *
 * e.g.
 *  [_hash, _key] call hash_get_key;
 *
 */

hash_get_key = {
  ARGVX2(0,_hash);
  ARGVX3(1,_key,"");

  def(_key_value);
  _key_value = [_hash, _key] call hash_get_key_value;

  if (!isARRAY(_key_value)) exitWith {};
  if (count(_key_value) < 2) exitWith {};

  (_key_value select 1)
};

/**
 * Puts the given key-value pair into the target hash
 *
 * e.g.
 *  [_hash, _key, _value] call hash_set_key;
 *
 * Note that value may be nil
 *
 */
hash_set_key = {
  ARGVX3(0,_hash,[]);
  ARGVX3(1,_key,"");
  ARGV2(2,_value);

  //diag_log format["_key = %1, _value = %2", _key, OR(_value,nil)];

  def(_key_value);
  _key_value = [_hash, _key] call hash_get_key_value;

  if (!isARRAY(_key_value)) then {
    _key_value = [_key, OR(_value,nil)];
    _hash pushBack _key_value;
  }
  else {
    _key_value set [1, OR(_value,nil)];
  };

  (_key_value)
};

/**
 * Merges all the key-value pairs from source to target
 *
 * e.g.
 *  [_target, _source] call hash_set_all;
 *
 */
hash_set_all = {
  ARGVX3(0,_target,[]);
  ARGVX3(1,_source,[]);

  def(_key);
  def(_value);
  {if (true) then {
    if (isNil "_x") exitWith {};
    if (!isARRAY(_x)) exitWith {};

    _key = _x select 0;
    _value = if (count(_x) > 1) then {_x select 1} else {nil};

    [_target,_key, OR(_value,nil)] call hash_set_key;
  };} forEach _source;

  (_target)
};

/**
 * Delete a key from the hash (does not set it to nil), it actually removes it
 */
hash_remove_key = {
  ARGVX3(0,_hash,[]);
  ARGVX3(1,_key,"");

  def(_ckey);
  def(_index);
  {
    if(true) then {
      if(!isARRAY(_x)) exitWith {};
      _ckey = _x select 0;
      if (!isSTRING(_ckey)) exitWith {};
      if (_ckey != _key) exitWith {};
      _index = _forEachIndex;
    };
    if (!isNil "_index") exitWith {};
  } forEach _hash;

  if (isNil "_index") exitWith {};
  _hash deleteAt _index;
};


hash_loaded = true;
diag_log "hash loading complete";