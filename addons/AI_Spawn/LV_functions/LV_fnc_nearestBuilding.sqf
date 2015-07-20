///////LV_fnc_nearestBuilding.sqf 0.4 - SPUn / LostVar
//Returns array of real buildings, excluding other "house" objects
//_type "all in radius" returns [all buildings in radius] or nil
//_type "nearest one" returns [nearest building] or nil
private["_houseObjects","_type","_center","_center0","_radius","_buildings","_bld"];
_type = _this select 0;
_center = _this select 1;
_radius = _this select 2;

if(_center in allMapMarkers)then{
	_center0 = getMarkerPos _center;
}else{
	if (typeName _center == "ARRAY") then{
		_center0 = _center;
	}else{
		_center0 = getPos _center;
	};
};

switch (_type) do {
	case "all in radius":{
		_houseObjects = nearestObjects [_center0, ["building"], _radius];
	};
	case "nearest one":{
		_houseObjects = nearestObjects [_center0, ["building"], 500];
	};
};

if(isNil("_houseObjects"))exitWith{nil};
if((count _houseObjects)==0)exitWith{nil};

_buildings = [];
{
	if(str(_x buildingPos 0) != "[0,0,0]")then{_buildings set[(count _buildings),_x];};
}forEach _houseObjects;

if((count _buildings)==0)exitWith{nil};

switch (_type) do {
	case "all in radius":{
		_buildings;
	};
	case "nearest one":{
		_bld = _buildings select 0;
		{
			if((_x distance _center)<(_bld distance _center))then{ _bld = _x; };
		}forEach _buildings;
		_buildings = [_bld];
		_buildings;
	};
};