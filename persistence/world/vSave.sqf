//	@file Version: 1.2
//	@file Name: oSave.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Description: Basesaving save script

if (!isServer) exitWith {};

#include "functions.sqf"

_saveableObjects = [];

_isSaveable =
{
	_result = false;
	{ if (_this == _x) exitWith { _result = true } } forEach _saveableObjects;
	_result
};

// Add objectList & general store objects
{
	_index = _forEachIndex;
	
	{
		_obj = _x;
		if (_index > 0) then { _obj = _x select 1 };
		
		if (!(_obj isKindOf "AllVehicles") && {!(_obj call _isSaveable)}) then
		{
			[_saveableObjects, _obj] call BIS_fnc_arrayPush;
		};
		
	} forEach _x;
} forEach [civilianVehicles, call allVehStoreVehicles]; //objectList

// If file doesn't exist, create Info section at the top
if !(_filename2 call iniDB_exists) then
{
	[_filename2, "Info", "ObjCount", 0] call iniDB_write;
};

while {true} do
{
	sleep 60;

	_oldObjCount = [_filename2, "Info", "ObjCount", "NUMBER"] call iniDB_read;
	_objCount = 0;
	
	{
		_obj = _x;
		
		if (alive _obj) then
		{
			_class = typeOf _obj;
			_ownerId = _x getVariable "ownerUID";
			if(!isNil "_ownerId" && {(_baseSavingOn && {_class call _isSaveable}) || {_boxSavingOn && {_obj isKindOf "AllVehicles"}}})

			   then
			{
				_netId = netId _obj;
				_pos = ASLtoATL getPosWorld _obj;
				_value = (_pos select 2) + 0.3;
				_pos set [2, _value];
				_dir = [vectorDir _obj, vectorUp _obj];
				_damage = damage _obj;
				_allowDamage = if (_obj getVariable ["allowDamage", false]) then { 1 } else { 0 };
				_texture = _obj getVariable ["A3W_objectTexture", ""];
				
				if (isNil {_obj getVariable "baseSaving_spawningTime"}) then
				{
					_obj setVariable ["baseSaving_spawningTime", diag_tickTime];
				};
				
				_hoursAlive = (_obj getVariable ["baseSaving_hoursAlive", 0]) + ((diag_tickTime - (_obj getVariable "baseSaving_spawningTime")) / 3600);			
				_variables = [];

				_owner = _obj getVariable ["ownerUID", ""];
				
				if (_owner != "") then
				{
					[_variables, ["ownerUID", _owner]] call BIS_fnc_arrayPush;
				};
				
				_ownerN = _obj getVariable ["ownerN", ""];
				
				if (_ownerN != "") then
				{
					[_variables, ["ownerN", _ownerN]] call BIS_fnc_arrayPush;
				};
								
				_weapons = [];
				_magazines = [];
				_items = [];
				_backpacks = [];
				
				// Save weapons & ammo
				_weapons = (getWeaponCargo _obj) call cargoToPairs;
				_magazines = (getMagazineCargo _obj) call cargoToPairs;
				_items = (getItemCargo _obj) call cargoToPairs;
				_backpacks = (getBackpackCargo _obj) call cargoToPairs;

				_objCount = _objCount + 1;
				_objName = format ["v%1", _objCount];

				[_filename2, _objName, "Class", _class] call iniDB_write;
				[_filename2, _objName, "Position", _pos] call iniDB_write;
				[_filename2, _objName, "Direction", _dir] call iniDB_write;
				[_filename2, _objName, "HoursAlive", _hoursAlive] call iniDB_write;
				[_filename2, _objName, "Damage", _damage] call iniDB_write;
				[_filename2, _objName, "AllowDamage", _allowDamage] call iniDB_write;
				[_filename2, _objName, "Variables", _variables] call iniDB_write;
				[_filename2, _objName, "Texture", _texture] call iniDB_write;
				[_filename2, _objName, "Weapons", _weapons] call iniDB_write;
				[_filename2, _objName, "Magazines", _magazines] call iniDB_write;
				[_filename2, _objName, "Items", _items] call iniDB_write;
				[_filename2, _objName, "Backpacks", _backpacks] call iniDB_write;
				
				sleep 0.01;
			};
		};
	} forEach allMissionObjects "All";
	
	[_filename2, "Info", "ObjCount", _objCount] call iniDB_write;

	diag_log format ["A3W - %1 vehicles have been saved with iniDB", _objCount];
	
	// Reverse-delete old objects
	if (_oldObjCount > _objCount) then
	{
		for [{_i = _oldObjCount}, {_i > _objCount}, {_i = _i - 1}] do
		{
			[_filename2, format ["v%1", _i]] call iniDB_deleteSection;
		};
	};
};