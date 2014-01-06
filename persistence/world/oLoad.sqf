// WARNING! This is a modified version for use with the GoT Wasteland v2 missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap (GoT2DayZ.nl)
if (!isServer) exitWith {};
diag_log "A3W - Starting load of Base Saving objects";
private ["_deleteBaseTime", "_deleteAmmoboxTime", "_obj"];
sleep 10;
_check = ("Objects" call PDB_databaseNameCompiler) call iniDB_exists;
if (!_check) then {savedobjectsloaddone = true;};
if (!_check) exitWith {};
_objectscount = ["Objects" call PDB_databaseNameCompiler, "Count", "Count", "NUMBER"] call iniDB_read;
if (isNil "_objectscount") then {savedobjectsloaddone = true;};
if (isNil "_objectscount") exitWith {};
// datetimelocked="["date", 07, 11, 2013, 18, 50, 10]"


if (A3W_baseSaveTime > 30) then {A3W_baseSaveTime = 30;};
if (A3W_baseSaveTime < 1) then {A3W_baseSaveTime = 1;};
if (A3W_ammoboxSaveTime > 30) then {A3W_ammoboxSaveTime = 30;};
if (A3W_ammoboxSaveTime < 0) then {A3W_ammoboxSaveTime = 0;};
if (A3W_restarts < 1) then {A3W_restarts = 1;};

_deleteCapturedtime = call compile ("subtracthours" callExtension format ["%1", (24/A3W_restarts)]);
_deleteCapturedDOY = (_deleteCapturedtime select 1) + ((_deleteCapturedtime select 2) * 100) + (((_deleteCapturedtime select 3)-2000) * 10000);
_deleteCapturedMOD = (_deleteCapturedtime select 5) + ((_deleteCapturedtime select 4) * 60);

diag_log format["Delete Captured Ammobox if Locked Before %1 on %2", _deleteCapturedMOD, _deleteCapturedDOY];

_deleteBaseTime =  call compile ("subtracthours" callExtension format ["%1", (24 * A3W_baseSaveTime)]);
_deleteAmmoboxTime = call compile ("subtracthours" callExtension format ["%1", (24 * A3W_AmmoboxSaveTime)]);

diag_log format["_deleteBaseTime is %1", _deleteBaseTime];
diag_log format["_deleteAmmoboxTime is %1", _deleteAmmoboxTime];

_deleteBaseDOY = (_deleteBaseTime select 1) + ((_deleteBaseTime select 2) * 100) + (((_deleteBaseTime select 3)-2000) * 10000);
_deleteBaseMOD = (_deleteBaseTime select 5) + ((_deleteBaseTime select 4) * 60);
diag_log format["Delete Base part if Locked Before %1 on %2 ", _deleteBaseMOD, _deleteBaseDOY];

_deleteAmmoboxDOY = (_deleteAmmoboxTime select 1) + ((_deleteAmmoboxTime select 2) * 100) + (((_deleteAmmoboxTime select 3)-2000) * 10000);
_deleteAmmoboxMOD = (_deleteAmmoboxTime select 5) + ((_deleteAmmoboxTime select 4) * 60);
diag_log format["Delete Ammobox if Locked Before %1 on %2", _deleteAmmoboxMOD, _deleteAmmoboxDOY];

for "_i" from 0 to (_objectscount - 1) do 
{
	_objSaveName = format["obj%1", _i];
	_class = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "classname", "STRING"] call iniDB_read;
	_pos = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "pos", "ARRAY"] call iniDB_read;
	_dir = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "dir", "ARRAY"] call iniDB_read;
	_supplyleft = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "supplyleft", "NUMBER"] call iniDB_read;
	_weapons = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "weapons", "ARRAY"] call iniDB_read;
	_magazines = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "magazines", "ARRAY"] call iniDB_read;
    _items = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "items", "ARRAY"] call iniDB_read;
    _datetimelocked =  ["Objects" call PDB_databaseNameCompiler, _objSaveName, "datetimelocked", "ARRAY"] call iniDB_read;
    
	if (!isNil "_objSaveName" && !isNil "_class" && !isNil "_pos" && !isNil "_dir" && !isNil "_supplyleft") then 
	{
        _obj = createVehicle [_class,_pos, [], 0, "CAN COLLIDE"];
		_obj setPosASL _pos;
		_obj setVectorDirAndUp _dir;

		if (_class == "Land_Sacks_goods_F") then 
		{
			_obj setVariable["food",_supplyleft,true];
		};

		if (_class == "Land_BarrelWater_F") then 
		{
			_obj setVariable["water",_supplyleft,true];
		};


		clearWeaponCargoGlobal _obj;
		clearMagazineCargoGlobal _obj;
        clearItemCargoGlobal _obj;
        // B_supplyCrate_F 
        _relock = true;       
        if (_obj isKindOf "ReammoBox_F") then
        {
            for [{_ii = 0}, {_ii < (count (_weapons select 0))}, {_ii = _ii + 1}] do 
            {
                _obj addWeaponCargoGlobal [(_weapons select 0) select _ii, (_weapons select 1) select _ii];
            };

            for [{_ii = 0}, {_ii < (count (_magazines select 0))}, {_ii = _ii + 1}] do 
            {
                _obj addMagazineCargoGlobal [(_magazines select 0) select _ii, (_magazines select 1) select _ii];
            };
        
            for [{_ii = 0}, {_ii < (count (_items select 0))}, {_ii = _ii + 1}] do 
            {
                _obj addItemCargoGlobal [(_items select 0) select _ii, (_items select 1) select _ii];
            };
            _lockedDOY = (_datetimelocked select 1) + ((_datetimelocked select 2) * 100) + (((_deleteAmmoboxTime select 3)-2000) * 10000);
            _lockedMOD = (_datetimelocked select 5) + ((_datetimelocked select 4) * 60);
            if (({_class == _x} count weaponboxList > 0) or _class == "B_supplyCrate_F" ) then
            {
                if (_lockedDOY < _deleteCapturedDOY) then {_relock = false;};
                if (_lockedDOY == _deleteCapturedDOY) then
                {
                    if (_lockedMOD < _deleteCapturedMOD) then {_relock = false;};
                
                };
            }
            else
            {
                if (_lockedDOY  < _deleteAmmoboxDOY)  then {_relock = false;};
                if (_lockedDOY == _deleteAmmoboxDOY) then
                {
                    if (_lockedMOD < _deleteAmmoboxMOD) then {_relock = false;};
                };
            };
        }
        else
        {
            _lockedDOY = (_datetimelocked select 1) + ((_datetimelocked select 2) * 100) + (((_deleteAmmoboxTime select 3)-2000) * 10000);
            if (_lockedDOY  < _deleteBaseDOY)  then {_relock = false;};
            if (_lockedDOY == _deleteBaseDOY) then
            {
                _lockedMOD = (_datetimelocked select 5) + ((_datetimelocked select 4) * 60);
                if (_lockedMOD < _deleteBaseMOD) then {_relock = false;};
            };
            
        };
            
        diag_log format["A3W - baseSaving locked %1 a %2 %3 at %4", _objSaveName, _relock, _class, _dateTimelocked];
        _obj setVariable ["objectLocked", _relock, true]; //force lock
        
        if (count _datetimelocked == 7) then
        {
            _t = _datetimelocked;
            _datetimelocked = ["0", _t select 1, _t select 2, _t select 3, _t select 4, _t select 5];
        };
        
        if (_relock) then { _obj setVariable ["datetimelocked", _dateTimelocked, true];};
	};
};
	diag_log format["A3W - baseSaving loaded %1 parts from iniDB", _objectscount];
    diag_log format["A3W - Base saving parts saved for %1 days", A3W_baseSaveTime];
    diag_log format["A3W - Ammo boxes saved for %1 days", A3W_ammoboxSaveTime];
    savedobjectsloaddone= true;
