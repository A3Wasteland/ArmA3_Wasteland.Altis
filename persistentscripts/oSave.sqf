// WARNING! This is a modified version for use with the GoT Wasteland v2 missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap (GoT2DayZ.nl)

sleep 60;
while {true} do {
	//player groupchat "hey";
	PersistentDB_ObjCount = 0;
	{
		_var = _x getVariable "objectLocked";
		if(!isNil "_var" && (alive _x)) then {
			_classname = typeOf _x;
			// addition to check if the classname matches the building parts
			if(_classname in objectList) then {
				_pos = getPosASL _x;
				_dir = [vectorDir _x] + [vectorUp _x];

				_supplyleft = 0;

				if(_x isKindOf "Land_Sacks_goods_F") then {
					_supplyleft = _x getVariable "food";
					if(isNil "_supplyleft") then
					{
						_supplyleft = 20;
					};
				};

				if(_x isKindOf "Land_BarrelWater_F") then { 
					_supplyleft = _x getVariable "water";
					if(isNil "_supplyleft") then
					{
						_supplyleft = 20;
					};
				};

				// i dont want to save weapons/ammo just bases themselves so this is off
				// _weapons = getWeaponCargo _x;
				// _magazines = getMagazineCargo _x;
				_objSaveName = format["obj%1", PersistentDB_ObjCount];

				["Objects" call PDB_databaseNameCompiler, _objSaveName, "classname", _classname] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "pos", _pos] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "dir", _dir] call iniDB_write;
				["Objects" call PDB_databaseNameCompiler, _objSaveName, "supplyleft", _supplyleft] call iniDB_write;
				// ["Objects" call PDB_databaseNameCompiler, _objSaveName, "weapons", _weapons] call iniDB_write;
				// ["Objects" call PDB_databaseNameCompiler, _objSaveName, "magazines", _magazines] call iniDB_write;

				PersistentDB_ObjCount = PersistentDB_ObjCount + 1;
				};
			};
	} forEach allMissionObjects "All";
	["Objects" call PDB_databaseNameCompiler, "Count", "Count", PersistentDB_ObjCount] call iniDB_write;
	diag_log format["GoT Wasteland - baseSaving saved %1 parts to iniDB", PersistentDB_ObjCount];
	sleep 120;
};