//	@file Version: 1.2
//	@file Name: oLoad.sqf
//	@file Author: JoSchaap, AgentRev, Austerror
//	@file Description: Basesaving load script

sleep 10;
_check = ("Objects" call PDB_databaseNameCompiler) call iniDB_exists;
if (!_check) exitWith {};
_objectscount = ["Objects" call PDB_databaseNameCompiler, "Count", "Count", "NUMBER"] call iniDB_read;
if (isNil "_objectscount") exitWith {};

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
	_owner = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "ownerUID", "STRING"] call iniDB_read;
	_allowDamage = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "allowDamage", "NUMBER"] call iniDB_read;
	_damageVal = ["Objects" call PDB_databaseNameCompiler, _objSaveName, "damage", "NUMBER"] call iniDB_read;
	
	if (!isNil "_objSaveName" && !isNil "_class" && !isNil "_pos" && !isNil "_dir" && !isNil "_supplyleft") then 
	{

		_obj = createVehicle [_class,_pos, [], 0, "CAN COLLIDE"];
		_obj setPosASL _pos;
		_obj setVectorDirAndUp _dir;
		
		if (_allowDamage > 0) then
		{
			_obj setDamage _damageVal;
			_obj setVariable ["allowDamage", true];
		}
		else
		{
			_obj allowDamage false;
		}
		
		if (_class == "Land_Sacks_goods_F") then 
		{
			_obj setVariable ["food", _supplyleft, true];
		};

		if (_class == "Land_WaterBarrel_F") then 
		{
			_obj setVariable ["water", _supplyleft, true];
		};
		
		clearWeaponCargoGlobal _obj;
		clearMagazineCargoGlobal _obj;
		
		for "_ii" from 0 to (count (_weapons select 0) - 1) do
		{
			_obj addWeaponCargoGlobal [(_weapons select 0) select _ii, (_weapons select 1) select _ii];
		};

		for "_ii" from 0 to (count (_magazines select 0) - 1) do
		{
			_obj addMagazineCargoGlobal [(_magazines select 0) select _ii, (_magazines select 1) select _ii];
		};
			
		_obj setVariable ["objectLocked", true, true]; //force lock
		_obj setVariable ["ownerUID", _owner, true]; // Set owner id
	};
};

diag_log format ["A3Wasteland - baseSaving loaded %1 parts from iniDB", _objectscount];
