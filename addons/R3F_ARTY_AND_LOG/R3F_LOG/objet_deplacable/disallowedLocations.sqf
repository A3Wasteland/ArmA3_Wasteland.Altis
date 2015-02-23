_disallowedLocations=[];

//Missions
for "_i" from 1 to 20 do {
  _pos = getMarkerPos format["Mission_%1",_i];
  if (!(((_pos select 0) == 0) && {((_pos select 1) == 0) && {((_pos select 2) == 0)}})) then {
    diag_log format ["Adding new pos: Mission_%1 : %2",_i,_pos];
    _disallowedLocations pushBack _pos;
  };
};

//Towns
for "_i" from 1 to 20 do {
  _pos = getMarkerPos format["Town_%1",_i];
  if (!(((_pos select 0) == 0) && {((_pos select 1) == 0) && {((_pos select 2) == 0)}})) then {
    diag_log format ["Adding new pos: Town_%1 : %2",_i,_pos];
    _disallowedLocations pushBack _pos;
  };
};

//GunStore
for "_i" from 1 to 4 do {
  _pos = getMarkerPos format["GunStore%1_objSpawn",_i];
  if (!(((_pos select 0) == 0) && {((_pos select 1) == 0) && {((_pos select 2) == 0)}})) then {
    diag_log format ["Adding new pos: GunStore%1 : %2",_i,_pos];
    _disallowedLocations pushBack _pos;
  };
};

//GenStore
for "_i" from 1 to 5 do {
  _pos = getMarkerPos format["GenStore%1_objSpawn",_i];
  if (!(((_pos select 0) == 0) && {((_pos select 1) == 0) && {((_pos select 2) == 0)}})) then {
    diag_log format ["Adding new pos: GenStore%1 : %2",_i,_pos];
    _disallowedLocations pushBack _pos;
  };
};

//VehStore
for "_i" from 1 to 5 do {
  //Land
  _pos = getMarkerPos format["VehStore%1_landSpawn",_i];
  if (!(((_pos select 0) == 0) && {((_pos select 1) == 0) && {((_pos select 2) == 0)}})) then {
    diag_log format ["Adding new pos: VehStore%1 : %2",_i,_pos];
    _disallowedLocations pushBack _pos;
  };
  //Heli
  _pos = getMarkerPos format["VehStore%1_heliSpawn",_i];
  if (!(((_pos select 0) == 0) && {((_pos select 1) == 0) && {((_pos select 2) == 0)}})) then {
    diag_log format ["Adding new pos: VehStore%1 : %2",_i,_pos];
    _disallowedLocations pushBack _pos;
  };
  //Sea
  _pos = getMarkerPos format["VehStore%1_seaSpawn",_i];
  if (!(((_pos select 0) == 0) && {((_pos select 1) == 0) && {((_pos select 2) == 0)}})) then {
    diag_log format ["Adding new pos: VehStore%1 : %2",_i,_pos];
    _disallowedLocations pushBack _pos;
  };
  //Plane
  _pos = getMarkerPos format["VehStore%1_planeSpawn",_i];
  if (!(((_pos select 0) == 0) && {((_pos select 1) == 0) && {((_pos select 2) == 0)}})) then {
    diag_log format ["Adding new pos: VehStore%1 : %2",_i,_pos];
    _disallowedLocations pushBack _pos;
  };
};

(_disallowedLocations);