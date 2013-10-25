//	@file Version: 1.0
//	@file Name: spawnStoreObject.sqf
//	@file Author: AgentRev
//	@file Created: 11/10/2013 22:17
//	@file Args:

if (!isServer) exitWith {};

private ["_player", "_class", "_marker", "_key", "_isGeneralStore", "_isGunStore", "_objectID", "_objectsArray", "_itemEntry", "_itemPrice", "_isDamageable", "_safePos", "_safePos"];

_player = [_this, 0, objNull, [objNull]] call BIS_fnc_param;
_class = [_this, 1, "", [""]] call BIS_fnc_param;
_marker = [_this, 2, "", [""]] call BIS_fnc_param;
_key = [_this, 3, "", [""]] call BIS_fnc_param;

_isGeneralStore = ["GenStore", _marker] call fn_findString == 0;
_isGunStore = ["GunStore", _marker] call fn_findString == 0;
_marker = _marker + "_objSpawn";

if (_key != "" && {isPlayer _player} && {_isGeneralStore || _isGunStore} && {{_x == _marker} count allMapMarkers > 0}) then
{
	_objectID = "";
	
	switch (true) do 
	{
		case _isGeneralStore: { _objectsArray = genObjectsArray };
		case _isGunStore:     { _objectsArray = staticGunsArray };
	};
	
	if (!isNil "_objectsArray") then
	{
		{
			if (_class == _x select 1) exitWith
			{
				_itemEntry = _x;
			};
		} forEach (call _objectsArray);
		
		if (!isNil "_itemEntry") then
		{
			_itemPrice = _itemEntry select 2;
			_isDamageable = {_class isKindOf _x} count ["StaticWeapon", "Lamps_base_F", "Cargo_Patrol_base_F", "Cargo_Tower_base_F"] > 0;
			
			/*if (_class isKindOf "Box_NATO_Ammo_F") then
			{
				switch (side _player) do
				{
					case OPFOR:       { _class = "Box_East_Ammo_F" };
					case INDEPENDENT: { _class = "Box_IND_Ammo_F" };
				};
			};*/
			
			if (_player getVariable ["cmoney", 0] >= _itemPrice) then
			{
				//_objectSize = sizeOf _class;
				//if (_objectSize == 0) then { _objectSize = 2 };
				//_safePos = [markerPos _marker, 0, 5, _objectSize, 0, 60*(pi/180), 0] call findSafePos;
				
				_safePos = (markerPos _marker) findEmptyPosition [0, 20, _class];
				if (count _safePos == 0) then { _safePos = markerPos _marker };
				
				_object = createVehicle [_class, _safePos, [], 0, "None"];
				
				[_object, false] call vehicleSetup;
				_object allowDamage _isDamageable;
				
				_objectID = netId _object;			
			};
		};
	};
	
	[compile format ["%1 = '%2'", _key, _objectID], "BIS_fnc_spawn", _player, false] call TPG_fnc_MP;
};
