//	@file Version: 1.2
//	@file Name: oSave.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Description: Basesaving save script

if (!isServer) exitWith {};

_baseSavingOn = ["A3W_baseSaving"] call isConfigOn;
_boxSavingOn = ["A3W_boxSaving"] call isConfigOn;

_saveableObjects = [];

_isSaveable =
{
	_result = false;
	{ if (_this == _x) exitWith { _result = true } } forEach _saveableObjects;
	_result
};

// Add objectList & general store objects
{
	_obj = _x;
	if (_forEachIndex > 0) then { _obj = _x select 1 };
	
	if (!(_obj isKindOf "ReammoBox_F") && {!(_obj call _isSaveable)}) then
	{
		[_saveableObjects, _obj] call BIS_fnc_arrayPush;
	};
} forEach [objectList, call genObjectsArray];

_fileName = "Objects" call PDB_databaseNameCompiler;

while {true} do
{
	sleep 60;
	
	_oldObjCount = [_fileName, "Info", "Count", "NUMBER"] call iniDB_read;
	_objCount = 0;
	
	{
		_obj = _x;
		
		if (_obj getVariable ["objectLocked", false] && {alive _obj}) then
		{
			_class = typeOf _obj;
			
			if ((_baseSavingOn && {_class call _isSaveable}) || {_boxSavingOn && {_obj isKindOf "ReammoBox_F"}}) then
			{
				_netId = netId _obj;
				_pos = getPosATL _obj;
				_dir = [vectorDir _obj, vectorUp _obj];
				_damage = damage _obj;
				_allowDamage = if (_obj getVariable ["allowDamage", false]) then { 1 } else { 0 };
				
				if (isNil {_obj getVariable "baseSaving_spawningTime"}) then
				{
					_obj setVariable ["baseSaving_spawningTime", diag_tickTime];
				};
				
				_hoursAlive = (_obj getVariable ["baseSaving_hoursAlive", 0]) + ((diag_tickTime - (_obj getVariable "baseSaving_spawningTime")) / 3600);

				_variables = [];
				
				switch (true) do
				{
					case (_obj isKindOf "Land_Sacks_goods_F"):
					{
						[_variables, ["food", _obj getVariable ["food", 20]] call BIS_fnc_arrayPush;
					};
					case (_obj isKindOf "Land_WaterBarrel_F"):
					{
						[_variables, ["water", _obj getVariable ["water", 20]] call BIS_fnc_arrayPush;
					};
				};
				
				_owner = _obj getVariable ["ownerUID", ""];
				
				if (_owner != "") then
				{
					[_variables, ["_owner", _owner] call BIS_fnc_arrayPush;
				};
				
				_weapons = [];
				_magazines = [];
				_items = [];
				_backpacks = [];
				
				if (getNumber (configFile >> "CfgVehicles" >> _class >> "maximumLoad") > 0) then
				{
					// Save weapons & ammo
					_weapons = (getWeaponCargo _obj) call cargoToPairs;
					_magazines = (getMagazineCargo _obj) call cargoToPairs;
					_items = (getItemCargo _obj) call cargoToPairs;
					_backpacks = (getBackpackCargo _obj) call cargoToPairs;
				};

				_objCount = _objCount + 1;
				_objName = format ["Obj%1", _objCount];

				[_fileName, _objName, "Class", _class] call iniDB_write;
				[_fileName, _objName, "Position", _pos] call iniDB_write;
				[_fileName, _objName, "Direction", _dir] call iniDB_write;
				[_fileName, _objName, "HoursAlive", _hoursAlive] call iniDB_write;
				[_fileName, _objName, "Damage", _damage] call iniDB_write;
				[_fileName, _objName, "AllowDamage", _allowDamage] call iniDB_write;
				[_fileName, _objName, "Variables", _variables] call iniDB_write;
				
				[_fileName, _objName, "Weapons", _weapons] call iniDB_write;
				[_fileName, _objName, "Magazines", _magazines] call iniDB_write;
				[_fileName, _objName, "Items", _items] call iniDB_write;
				[_fileName, _objName, "Backpacks", _backpacks] call iniDB_write;
			};
		};
	} forEach allMissionObjects "All";
	
	[_fileName, "Info", "Count", _objCount] call iniDB_write;
	
	diag_log format ["A3W - %1 baseparts have been saved with iniDB", _objCount];
	
	// Reverse-delete old objects
	if (_oldObjCount > _objCount) then
	{
		for [{_i = _oldObjCount, {_i > _objCount}, {_i = _i - 1}] do
		{
			[_fileName, format ["Obj%1", _i]] call iniDB_deleteSection;
		};
	};
};
