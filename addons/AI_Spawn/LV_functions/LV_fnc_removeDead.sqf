//ARMA3Alpha function LV_fnc_removeDead v1.2 - by SPUn / lostvar
//Syntax: nul = [range,players] execVM "addons\AI_Spawn\LV_fnc_removeDead.sqf";
//  range = min range from players where bodies dissapear, Default: 300
//  players = array of players, Default: playableUnits

if (!isServer)exitWith{};
private["_players","_deleteThese","_range","_grp"];
_range = if(count _this > 0)then{_this select 0;} else {300};
_players = if(count _this > 1)then{_this select 1;} else {playableUnits};
while{true}do{
  _deleteThese = allDeadMen;
  {
    for[{_i=0},{_i < (count _players)},{_i = _i + 1;}]do{
      if(((_players select _i) distance _x) < _range)exitWith{_deleteThese = _deleteThese - [_x];};
    };
  }forEach allDeadMen;
  {
    if (_x isKindOf "Man") then {hideBody _x;};
  }forEach _deleteThese;
  sleep 10;
  {
    if (_x isKindOf "Man") then {deleteVehicle _x;};
  }forEach _deleteThese;
  
  {
	_grp = _x;
	if(({alive _x}count units _grp)==0)then{deleteGroup _grp;};
  }forEach allGroups;
  
  sleep 50;
};

//wrecks
//groups