//	@file Name: addDefensiveMines.sqf
//	@file Author: Tyler
//  Add defense SLAM mine perimeter for vehicle protection of AI ground soldiers

private ["_missionPos"];
_missionPos = _this select 0;

_defMines = [];
_nbMines = 60;
_maxRadius = 80;
_nbRings = 4;
_mineGap = 0;
for "_i" from 1 to _nbRings do {
  _mineGap = _mineGap + ((_i*(_maxRadius/_nbRings))*2)*pi;
};
_mineGap = _mineGap/_nbMines;
for "_i" from 1 to _nbRings do {
  _distance = _i*(_maxRadius/_nbRings);
  _mineCnt = ceil (((_distance*2)*pi) / _mineGap);
  for "_i" from 1 to _mineCnt do {
     _deg = (360/_mineCnt)*_i;
     _minePos = _missionPos vectorAdd ([[_distance, 0, 0], _deg] call BIS_fnc_rotateVector2D);
     _mine = createMine ["SLAMDirectionalMine", _minePos, [], 0];
     _defMines pushBack _mine;
  };
};
