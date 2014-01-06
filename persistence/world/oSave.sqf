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
} forEach call genObjectsArray;

if (A3W_boxSaving == 1) then
{
    {
        _genObject = _x ;
	
        if ({_genObject == _x} count _saveableObjects == 0) then
        {
            _saveableObjects set [count _saveableObjects, _genObject];
        };
    } forEach weaponboxList;
}
else
{
    _saveableObjects = _saveableObjects - ["Box_NATO_Ammo_F"];
};
while {!savedobjectsloaddone} do
{
    sleep 10;
};
while {true} do
{
	sleep 60;
	_PersistentDB_ObjCount = 0;
    _currentdatetime = call compile ("subtracthours" callExtension "0");
	{
		_object = _x;
		
		if (_object getVariable ["objectLocked", false] && {alive _object}) then
		{
			_classname = typeOf _object;
			
			// addition to check if the classname matches the building parts
			if ({_classname == _x} count _saveableObjects > 0) then
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
					case (_object isKindOf "Land_BarrelWater_F"):
					{ 
						_supplyleft = _object getVariable ["water", 20];
					};
				};

				// Save weapons & ammo
				_weapons = getWeaponCargo _object;
				_magazines = getMagazineCargo _object;
                _items = getItemCargo _object;
                _datetimelocked = _object getVariable "datetimelocked";
                if (isNil "_datetimelocked") then
                {
                    _datetimelocked = _currentdatetime;
                    _object setVariable ["datetimelocked", _datetimelocked, true];
                    diag_log format["A3W - Base saving has found nil date for obj%1", _PersistentDB_ObjCount];
                }
                else
                {
                    switch (true) do
                    {
                        case (typename _datetimelocked == "STRING"): 
                        {
                            diag_log format["A3W - Base saving has found String date for obj%1 which is a %2", _PersistentDB_ObjCount, _classname];
                            if ( _datetimelocked == "") then
                            {
                                _datetimelocked = _currentdatetime;
                                diag_log format["A3W - Base saving has found blank string date for obj%1", _PersistentDB_ObjCount];
                                _object setVariable ["datetimelocked", _datetimelocked, true];
                            }
                            else
                            {
                                _datetimelocked_array = compile _datetimelocked;
                                _datetimelocked = _datetimelocked_array;
                            }; 
                        };
                        
                        case (typename _datetimelocked == "ARRAY"):
                        {
                            diag_log format["A3W - Base saving has found Array date for obj%1 which is a %2", _PersistentDB_ObjCount, _classname];
                            if (count _datetimelocked != 6) then
                            {
                                _datetimelocked = _currentdatetime;
                                diag_log format["A3W - Base saving has found invalid Array date for obj%1 which is a %2", _PersistentDB_ObjCount, _classname];
                            };
                        };
                        default 
                        {
                            diag_log format["A3W - Base saving has found Other type date for obj%1 which is a %2", _PersistentDB_ObjCount, _classname];
                        };
                    };

                };
                
				_objSaveName = format["obj%1", _PersistentDB_ObjCount];

				["Objects" call PDB_databaseNameCompiler, _objSaveName, "classname", _classname] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "pos", _pos] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "dir", _dir] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "supplyleft", _supplyleft] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "weapons", _weapons] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "magazines", _magazines] call iniDB_write;
                ["Objects" call PDB_databaseNameCompiler, _objSaveName, "items", _items] call iniDB_write;
                ["Objects" call PDB_databaseNameCompiler, _objSaveName, "datetimelocked", _datetimelocked] call iniDB_write;

				_PersistentDB_ObjCount = _PersistentDB_ObjCount + 1;
			};
		};
	} forEach allMissionObjects "All";
	
	["Objects" call PDB_databaseNameCompiler, "Count", "Count", _PersistentDB_ObjCount] call iniDB_write;
	
	diag_log format["A3W - %1 parts have been saved with iniDB", _PersistentDB_ObjCount];
	sleep 60;
};
