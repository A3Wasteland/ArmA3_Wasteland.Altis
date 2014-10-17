//	@file Version: 1.2
//	@file Name: oLoad.sqf
//	@file Author: JoSchaap, AgentRev, Austerror
//	@file Description: Basesaving load script

if (!isServer) exitWith {};

#include "functions.sqf"

_strToSide =
{
	switch (toUpper _this) do
	{
		case "WEST":  { BLUFOR };
		case "EAST":  { OPFOR };
		case "GUER":  { INDEPENDENT };
		case "CIV":   { CIVILIAN };
		case "LOGIC": { sideLogic };
		default       { sideUnknown };
	};
};
_maxLifetime = ["A3W_vehicleLifetime", 0] call getPublicVar;
_exists = _filename2 call iniDB_exists;
_objectsCount = 0;
sleep 60;
if (!isNil "_exists" && {_exists}) then
{
	_objectsCount = [_filename2, "Info", "ObjCount", "NUMBER"] call iniDB_read;
	
	if (!isNil "_objectsCount") then
	{
		for "_i" from 1 to _objectsCount do
		{
			_objName = format ["v%1", _i];
			
			_class = [_filename2, _objName, "Class", "STRING"] call iniDB_read;
			_pos = [_filename2, _objName, "Position", "ARRAY"] call iniDB_read;
			_hoursAlive = [_filename2, _objName, "HoursAlive", "NUMBER"] call iniDB_read;
			
			if (!isNil "_class" && {!isNil "_pos"} && {_maxLifetime <= 0 || {_hoursAlive < _maxLifetime}}) then 
			{
				_variables = [_filename2, _objName, "Variables", "ARRAY"] call iniDB_read;
				
				_allowed = switch (true) do
				{
					default                       { _baseSavingOn };
				};
				
				if (_allowed) then
				{
					_dir = [_filename2, _objName, "Direction", "ARRAY"] call iniDB_read;
					_damage = [_filename2, _objName, "Damage", "NUMBER"] call iniDB_read;
					_allowDamage = [_filename2, _objName, "AllowDamage", "NUMBER"] call iniDB_read;
					_texture = [_filename2, _objName, "Texture", "STRING"] call iniDB_read;
					
					_obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
					_obj setPosWorld ATLtoASL _pos;
				
										
					if (!isNil "_dir") then
					{
						_obj setVectorDirAndUp _dir;
					};
					_obj setVariable ["baseSaving_hoursAlive", _hoursAlive];
					_obj setVariable ["baseSaving_spawningTime", diag_tickTime];	
					//_obj setVariable ["R3F_LOG_est_transporte_par", _obj, false]; // there was a problem with towing after vehicle loaded but this doesnt seem necessary anymore
					
					if (vehicleThermalsOn) then
					{
						_obj disableTIEquipment false;
					}
					else
					{
						if !(_obj isKindOf "UAV_02_base_F") then
						{						
							_obj disableTIEquipment true;
						};
					};
					
					if (_obj isKindOf "SUV_01_base_F") then
					{
					_centerOfMass = getCenterOfMass _vehicle;
					_centerOfMass set [2, -0.657];
					_obj setCenterOfMass _centerOfMass;
					};			
			
			//Attempt to set the vehicle texture on the vehicle
			private ["_veh", "_texture", "_selections"];

			_veh = _obj;
			_texture = [_filename2, _objName, "Texture", "STRING"] call iniDB_read;

			if (!isNull _obj && _texture != "") then
			{
			_veh setVariable ["BIS_enableRandomization", false, true];

			// Apply texture to all appropriate parts
			_selections = switch (true) do
			{
				case (_veh isKindOf "Van_01_base_F"):             { [0,1] };
		
				case (_veh isKindOf "MRAP_01_base_F"):            { [0,2] };
				case (_veh isKindOf "MRAP_02_base_F"):            { [0,2] };
				case (_veh isKindOf "MRAP_03_base_F"):            { [0,1] };

				case (_veh isKindOf "Truck_01_base_F"):           { [0,1,2] };
				case (_veh isKindOf "Truck_02_base_F"):           { [0,1] };
				case (_veh isKindOf "Truck_03_base_F"):           { [0,1] };

				case (_veh isKindOf "APC_Wheeled_01_base_F"):     { [0,2] };
				case (_veh isKindOf "APC_Wheeled_02_base_F"):     { [0,2] };
				case (_veh isKindOf "APC_Wheeled_03_base_F"):     { [0,2,3] };

				case (_veh isKindOf "APC_Tracked_01_base_F"):     { [0,1,2,3] };
				case (_veh isKindOf "APC_Tracked_02_base_F"):     { [0,1,2] };
				case (_veh isKindOf "APC_Tracked_03_base_F"):     { [0,1] };

				case (_veh isKindOf "MBT_01_base_F"):             { [0,1,2] };
				case (_veh isKindOf "MBT_02_base_F"):             { [0,1,2,3] };
				case (_veh isKindOf "MBT_03_base_F"):             { [0,1,2] };

				case (_veh isKindOf "Heli_Transport_01_base_F"):  { [0,1] };
				case (_veh isKindOf "Heli_Transport_02_base_F"):  { [0,1,2] };
				case (_veh isKindOf "Heli_Attack_02_base_F"):     { [0,1] };

				case (_veh isKindOf "Plane_Base_F"):              { [0,1] };

				default                                           { [0] };
		};
		
				  { _veh setObjectTextureGlobal [_x, _texture] } forEach _selections;
					_veh setVariable ["A3W_objectTexture", _texture, true];				
		};			
					
					if (_allowDamage > 0) then
					{
						_obj setDamage _damage;
						_obj setVariable ["allowDamage", true];
					}
					else
					{
						_obj allowDamage false;
					};								
					
					{
						_var = _x select 0;
						_value = _x select 1;
						
						switch (_var) do
						{
							case "side": { _value = _value call _strToSide };
							case "ownerName": { _value = _value call iniDB_Base64Decode };
						};
						
						_obj setVariable [_var, _value, true];
					} forEach _variables;
					
					clearWeaponCargoGlobal _obj;
					clearMagazineCargoGlobal _obj;
					clearItemCargoGlobal _obj;
					clearBackpackCargoGlobal _obj;
					
					_unlock = switch (true) do
					{
						case (_obj call _isWarchest): { true };
						case (_obj call _isBeacon):
						{
							[pvar_spawn_beacons, _obj] call BIS_fnc_arrayPush;
							publicVariable "pvar_spawn_beacons";
							true
						};
						default { false };
					};
					
					if (_unlock) exitWith
					{
						_obj setVariable ["objectLocked", false, true];
					};
					
					if (_boxSavingOn) then
					{
						_weapons = [_filename2, _objName, "Weapons", "ARRAY"] call iniDB_read;
						_magazines = [_filename2, _objName, "Magazines", "ARRAY"] call iniDB_read;
						_items = [_filename2, _objName, "Items", "ARRAY"] call iniDB_read;
						_backpacks = [_filename2, _objName, "Backpacks", "ARRAY"] call iniDB_read;
						
						if (!isNil "_weapons") then
						{
							{ _obj addWeaponCargoGlobal _x } forEach _weapons;
						};
						if (!isNil "_magazines") then
						{
							{ _obj addMagazineCargoGlobal _x } forEach _magazines;
						};
						if (!isNil "_items") then
						{
							{ _obj addItemCargoGlobal _x } forEach _items;
						};
						if (!isNil "_backpacks") then
						{
							{ _obj addBackpackCargoGlobal _x } forEach _backpacks;
						};
					};
				};
			};
		};
	};
};

diag_log format ["A3Wasteland - vehicle persistence loaded %1 objects from iniDB", _objectsCount];

execVM "persistence\world\vSave.sqf";