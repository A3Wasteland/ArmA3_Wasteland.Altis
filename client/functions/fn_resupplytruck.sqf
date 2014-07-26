//	@file Version: 1.0
//	@file Name: fn_resupplytruck.sqf
//	@file Author: Wiking
//	@file Created: 13/07/2014 21:58
private ["_vehtosupply", "_object", "_type", "_magazines", "_removed", "_count", "_count_other", "_config2", "_vehicleName", "_magname" ];

_vehtosupply = vehicle player;
x_reload_time_factor = 3;

//Get Infos

/*=================================================================================================================
  Config Lookup Methods based on Script by Jacmac/Xeno
=================================================================================================================*/

Cfg_Lookup_WeaponInfo =
{
    private["_commonInfo", "_cfg"];
    _cfg = (configFile >> "CfgWeapons" >> _this);
    _commonInfo = _cfg call Cfg_Lookup_CommonInfo;
    [_commonInfo select 0, _commonInfo select 1, _commonInfo select 2, _commonInfo select 3]
};

Cfg_Lookup_MagazineInfo =
{
    private["_commonInfo", "_cfg", "_Count"];
    _cfg = (configFile >> "CfgMagazines" >> _this);
    _commonInfo = _cfg call Cfg_Lookup_CommonInfo;
    _Count = if (isText(_cfg >> "count")) then { parseNumber(getText(_cfg >> "count")) } else { getNumber(_cfg >> "count") };
    [_commonInfo select 0, _commonInfo select 1, _commonInfo select 2, _commonInfo select 3, _Count]
};

Cfg_Lookup_VehicleInfo =
{
    private["_commonInfo", "_cfg", "_MaxSpeed", "_MaxFuel", "_TurretCount", "_Turrets", "_VehMagazines"];
    _cfg  = (configFile >> "CfgVehicles" >> _this);
    _TurretCount = count (configFile >> "CfgVehicles" >> _this >> "Turrets");
    _Turrets = getArray(configFile >> "CfgVehicles" >> _this >> "Turrets");
    _VehMagazines = getArray(configFile >> "CfgVehicles" >> _this >> "magazines");
    _commonInfo = _cfg call Cfg_Lookup_CommonInfo;
    _MaxSpeed = if (isText(_cfg >> "maxSpeed")) then { parseNumber(getText(_cfg >> "maxSpeed")) } else { getNumber(_cfg >> "maxSpeed") };
    _MaxFuel = if (isText(_cfg >> "fuelCapacity")) then { parseNumber(getText(_cfg >> "fuelCapacity")) } else { getNumber(_cfg >>"fuelCapacity") };
    [_commonInfo select 0, _commonInfo select 1, _commonInfo select 2, _commonInfo select 3, _MaxSpeed, _MaxFuel, _TurretCount, _Turrets, _VehMagazines]
};

Cfg_Lookup_CommonInfo =
{
    private["_cfg", "_DisplayName", "_Description", "_TypeID", "_Pic"];
    _cfg = _this;
    _DisplayName = if (isText(_cfg >> "displayName")) then { getText(_cfg >> "displayName") } else { "/" };
    _Description = if (isText(_cfg >> "Library" >> "libTextDesc")) then { getText(_cfg >> "Library" >> "libTextDesc") } else { "/" };
    _Pic = if (isText(_cfg >> "picture")) then { getText(_cfg >> "picture") } else { "/" };
    _TypeID = if (isText(_cfg >> "type")) then { parseNumber(getText(_cfg >> "type")) } else { getNumber(_cfg >> "type") };
    [_DisplayName, _Description, _TypeID, _Pic]
};

Cfg_Lookup_Weapons_GetName          = { (_this call Cfg_Lookup_WeaponInfo) select 0 };
Cfg_Lookup_Weapons_GetDesc          = { (_this call Cfg_Lookup_WeaponInfo) select 1 };
Cfg_Lookup_Weapons_GetType          = { (_this call Cfg_Lookup_WeaponInfo) select 2 };
Cfg_Lookup_Weapons_GetPic           = { (_this call Cfg_Lookup_WeaponInfo) select 3 };

Cfg_Lookup_Magazine_GetName         = { (_this call Cfg_Lookup_MagazineInfo) select 0 };
Cfg_Lookup_Magazine_GetDesc         = { (_this call Cfg_Lookup_MagazineInfo) select 1 };
Cfg_Lookup_Magazine_GetType         = { (_this call Cfg_Lookup_MagazineInfo) select 2 };
Cfg_Lookup_Magazine_GetPic          = { (_this call Cfg_Lookup_MagazineInfo) select 3 };
Cfg_Lookup_Magazine_GetCount        = { (_this call Cfg_Lookup_MagazineInfo) select 4 };

Cfg_Lookup_Vehicle_GetName          = { (_this call Cfg_Lookup_VehicleInfo) select 0 };
Cfg_Lookup_Vehicle_GetDesc          = { (_this call Cfg_Lookup_VehicleInfo) select 1 };
Cfg_Lookup_Vehicle_GetType          = { (_this call Cfg_Lookup_VehicleInfo) select 2 };
Cfg_Lookup_Vehicle_GetPic           = { (_this call Cfg_Lookup_VehicleInfo) select 3 };
Cfg_Lookup_Vehicle_GetSpeed         = { (_this call Cfg_Lookup_VehicleInfo) select 4 };
Cfg_Lookup_Vehicle_GetFuel          = { (_this call Cfg_Lookup_VehicleInfo) select 5 };
Cfg_Lookup_Vehicle_GetTurretCount   = { (_this call Cfg_Lookup_VehicleInfo) select 6 };
Cfg_Lookup_Vehicle_GetTurrets	    = { (_this call Cfg_Lookup_VehicleInfo) select 7 };
Cfg_Lookup_Vehicle_GetMagazines     = { (_this call Cfg_Lookup_VehicleInfo) select 8 };



_object = _vehtosupply;
_type = typeOf _object;
_vehicleName = _type call Cfg_Lookup_Vehicle_GetName;

_object setVehicleAmmo 1;

_vehtosupply vehicleChat format ["Servicing %1... Please stand by...", _vehicleName];
_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

if (count _magazines > 0) then {
    _removed = [];
    {
        if (!(_x in _removed)) then {
            _object removeMagazines _x;
            _removed = _removed + [_x];
        };
    } forEach _magazines;
    {
	   _magname = _x call Cfg_Lookup_Magazine_GetName;
	   
	   if !(_magname == "") then {
       _vehtosupply vehicleChat format ["Reloading %1", _magname];
	   } else { 
	   _vehtosupply vehicleChat format ["Reloading %1", _x]; 
	   };
        sleep x_reload_time_factor;
        _object addMagazine _x;
    } forEach _magazines;
};

_count = count (configFile >> "CfgVehicles" >> _type >> "Turrets");

if (_count > 0) then {
    for "_i" from 0 to (_count - 1) do {
        scopeName "xx_reload2_xx";
        _config = (configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
        _magazines = getArray(_config >> "magazines");
        _removed = [];
        {
            if (!(_x in _removed)) then {
                _object removeMagazines _x;
                _removed = _removed + [_x];
            };
        } forEach _magazines;
        {
			_magname = _x call Cfg_Lookup_Magazine_GetName;
        if !(_magname == "") then {
       _vehtosupply vehicleChat format ["Reloading %1", _magname];
	   } else { 
	   _vehtosupply vehicleChat format ["Reloading %1", _x]; 
	   };
            sleep x_reload_time_factor;
            _object addMagazine _x;
            sleep x_reload_time_factor;
        } forEach _magazines;
        _count_other = count (_config >> "Turrets");
        if (_count_other > 0) then {
            for "_i" from 0 to (_count_other - 1) do {
                _config2 = (_config >> "Turrets") select _i;
                _magazines = getArray(_config2 >> "magazines");
                _removed = [];
                {
                    if (!(_x in _removed)) then {
                        _object removeMagazines _x;
                        _removed = _removed + [_x];
                    };
                } forEach _magazines;
                {
					_magname = _x call Cfg_Lookup_Magazine_GetName;
						   if !(_magname == "") then {
       _vehtosupply vehicleChat format ["Reloading %1", _magname];
	   } else { 
	   _vehtosupply vehicleChat format ["Reloading %1", _x]; 
	   };
                    sleep x_reload_time_factor;
                    _object addMagazine _x;
                    sleep x_reload_time_factor;
                } forEach _magazines;
            };
        };
    };
};
_object setVehicleAmmo 1;   // Reload turrets / drivers magazine
sleep x_reload_time_factor;
_vehtosupply vehicleChat "Repairing...";
_object setDamage 0;
sleep x_reload_time_factor;
_vehtosupply vehicleChat "Refueling...";
while {fuel _object < 0.99} do {
    //_object setFuel ((fuel _vehicle + 0.1) min 1);
    _object setFuel 1;
    sleep 0.01;
};

sleep x_reload_time_factor;
_vehtosupply vehicleChat format ["%1 is ready...", _vehicleName];