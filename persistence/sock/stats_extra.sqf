diag_log format["loading sock-rpc-stats extra functions ..."];

#include "macro.h"

stats_hash_pairs = {
  ARGV3(0,_hash,{});
  ARGV2(1,_default);

  if (isNil "_hash") exitWith {
    OR(_default,[])
  };

  init(_val, call _hash);
  OR(_val,[])
};

stats_hash_set = {
  ARGVX3(0,_scope,"");
  ARGVX3(1,_key,"");
  ARGVX3(2,_pairs,[]);

  init(_request,[]);
  _request pushBack _scope;

  {
    _request pushBack [_key + "." + (_x select 0), _x select 1];
  } forEach _pairs;

  if (count(_request) > 1) then {
    _request call stats_set;
  };
};


diag_log format["loading sock-rpc-stats extra functions complete"];
