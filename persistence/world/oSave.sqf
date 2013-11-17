//	@file Version: 1.2
//	@file Name: oSave.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Description: Basesaving script

if (!isServer) exitWith {};

// Copy objectList array
_saveableObjects = +objectList;

// Add general store objects
{
	_genObject = _x select 1;
	
	if ({_genObject == _x} count _saveableObjects == 0) then
	{
		_saveableObjects set [count _saveableObjects, _genObject];
	};
} forEach (call genObjectsArray);

while {true} do
{
	sleep 60;
	_PersistentDB_ObjCount = 0;
	
	{
		_object = _x;
		
		if (_object getVariable ["objectLocked", false] && {alive _object}) then
		{
			_classname = typeOf _object;
			
			// addition to check if the classname matches the building parts
			if (!(_object isKindOf "ReammoBox_F") && {{_classname == _x} count _saveableObjects > 0}) then
			{
				_pos = getPosASL _object;
				_dir = [vectorDir _object] + [vectorUp _object];

				_supplyleft = 0;

				switch (true) do
				{
					case (_object isKindOf "Land_Sacks_goods_F"):
					{
						_supplyleft = _object getVariable ["food", 20];
					};
					case (_object isKindOf "Land_WaterBarrel_F"):
					{ 
						_supplyleft = _object getVariable ["water", 20];
					};
				};

				// Save weapons & ammo
				// _weapons = getWeaponCargo _object;
				// _magazines = getMagazineCargo _object;
				
				_objSaveName = format["obj%1", _PersistentDB_ObjCount];

				["Objects" call PDB_databaseNameCompiler, _objSaveName, "classname", _classname] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "pos", _pos] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "dir", _dir] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "supplyleft", _supplyleft] call iniDB_write;
				// ["Objects" call PDB_databaseNameCompiler, _objSaveName, "weapons", _weapons] call iniDB_write;
				// ["Objects" call PDB_databaseNameCompiler, _objSaveName, "magazines", _magazines] call iniDB_write;

				_PersistentDB_ObjCount = _PersistentDB_ObjCount + 1;
			};
		};
	} forEach allMissionObjects "All";
	
	["Objects" call PDB_databaseNameCompiler, "Count", "Count", _PersistentDB_ObjCount] call iniDB_write;
	
	diag_log format["A3W - %1 parts have been saved with iniDB", _PersistentDB_ObjCount];
	sleep 60;
};
