// WARNING! This is a modified version for use with the GoT Wasteland v2 missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap (GoT2DayZ.nl)

sleep 10;
_check = ("Objects" call PDB_databaseNameCompiler) call iniDB_exists;
if(!_check) exitWith {};
_objectscount = ["Objects" call PDB_databaseNameCompiler, "Count", "Count", "NUMBER"] call iniDB_read;
if(isNil "_objectscount") exitWith {};
for[{_i = 0}, {_i < _objectscount}, {_i = _i + 1}] do {
	_objSaveName = format["obj%1", _i];
	_class = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "classname", "STRING"] call iniDB_read;
	_pos = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "pos", "ARRAY"] call iniDB_read;
	_dir = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "dir", "ARRAY"] call iniDB_read;
	_supplyleft = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "supplyleft", "NUMBER"] call iniDB_read;
	// _weapons = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "weapons", "ARRAY"] call iniDB_read;
	// _magazines = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "magazines", "ARRAY"] call iniDB_read;
	if(!isNil "_objSaveName" && !isNil "_class" && !isNil "_pos" && !isNil "_dir" && !isNil "_supplyleft") then 
	{

		_obj = createVehicle [_class,_pos, [], 0, "CAN COLLIDE"];
		_obj setPosASL _pos;
		_obj setVectorDirAndUp _dir;

		if(_class == "Land_Sacks_goods_F") then 
		{
			_obj setVariable["food",_supplyleft,true];
		};

		if(_class == "Land_BarrelWater_F") then 
		{
			_obj setVariable["water",_supplyleft,true];
		};
		// fix for rissen/sunken objects
		// seems not to be needed here, so disabled again
// 		_adjustPOS=-1;
// 		switch(_class) do {
// 			case "Land_Scaffolding_F":
// 			{
// 				_adjustPOS=-3; 
// 			};
// 			case "Land_Canal_WallSmall_10m_F":
// 			{
// 				_adjustPOS=3;
// 			};
// 			case "Land_Canal_Wall_Stairs_F":
// 			{
// 				_adjustPOS=3;
// 			};
//		};
//		_obj setpos [getpos _obj select 0,getpos _obj select 1, (getposATL _obj select 2)+_adjustPOS];

		clearWeaponCargoGlobal _obj;
		clearMagazineCargoGlobal _obj;

		// disabled because i dont want to load contents just base parts
		// for[{_ii = 0}, {_ii < (count (_weapons select 0))}, {_ii = _ii + 1}] do {
			// _obj addWeaponCargoGlobal [(_weapons select 0) select _ii, (_weapons select 1) select _ii];
		// };

		// for[{_ii = 0}, {_ii < (count (_magazines select 0))}, {_ii = _ii + 1}] do {
		// _obj addMagazineCargoGlobal [(_magazines select 0) select _ii, (_magazines select 1) select _ii];
		// };
		// _obj setVariable ["objectLocked", true, true]; //force lock
	};
};
	diag_log format["GoT Wasteland - baseSaving loaded %1 parts from iniDB", _objectscount];
