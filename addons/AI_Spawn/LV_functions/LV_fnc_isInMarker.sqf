//LV_fnc_isInMarker.sqf
private ["_dir","_difx","_dify","_relativedir","_adis","_bdis","_borderdis","_positiondis","_in","_e","_posF1","_posF2","_total","_dis1","_dis2","_pos","_marker","_cPos","_posx","_posy","_area","_areax","_areay","_areadir","_shape"];
_pos = _this select 0;
_marker = _this select 1;

_cPos = getMarkerPos _marker;
_posx = _cPos select 0;
_posy = _cPos select 1;
_area = getMarkerSize _marker;
_areax = _area select 0; 
_areay = _area select 1;
_areadir = markerDir _marker;
_shape = markerShape _marker;

if(_shape == "RECTANGLE")then{
	_difx = (_pos select 0) - _posx;
	_dify = (_pos select 1) - _posy;
	_dir = atan(_difx / _dify);
	if (_dify < 0) then {_dir = _dir + 180};
	_relativedir = _areadir - _dir;
	_adis = abs (_areax / cos (90 - _relativedir));
	_bdis = abs (_areay / cos _relativedir);
	_borderdis = _adis min _bdis;
	_positiondis = _pos distance _cPos;
	_in = if (_positiondis < _borderdis) then {true} else {false};
}else{
	_e = sqrt(_areax^2 - _areay^2);
	_posF1 = [_posx + (sin (_areadir+90) * _e),_posy + (cos (_areadir+90) * _e)];
	_posF2 = [_posx - (sin (_areadir+90) * _e),_posy - (cos (_areadir+90) * _e)];
	_total = 2 * _areax;
	_dis1 = _pos distance _posF1;
	_dis2 = _pos distance _posF2;
	_in = if (_dis1+_dis2 < _total) then {true} else {false};
};
_in;