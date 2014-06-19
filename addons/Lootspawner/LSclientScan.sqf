//	@file Name: LSclientScan.sqf
//	@file Author: AgentRev, Na_Palm

// execVM this file on clients

#define PLAYER_LOOT_SPAWN_RADIUS 75 //Radius (in meter) around players to spawn loot
#define LOOT_SPAWN_INTERVAL 30*60	//Time (in sec.) to pass before an building spawns new loot (must also change in Lootspawner.sqf)

//Buildings that can spawn loot go in this list
#include "LSlootBuildings.sqf"

_spawnBuilding_list = [];

{
	[_spawnBuilding_list, _x select 0] call BIS_fnc_arrayPush;
} forEach Buildingstoloot_list;
	
if (hasInterface) then
{
	while {true} do
	{
		if (alive player) then
		{
			// jogging has 4.16..., sprinting has 5.5... so if player velocity is < 6 spawn loot
			if (vectorMagnitude velocity player < 6) then
			{
				_buildList = [];
				
				{
					_var = _x getVariable ["BuildingLoot", [0,0]];
					_status = _var select 0;
					_timeStamp = _var select 1;
					
					if (_status < 2 && {_timeStamp == 0 || {serverTime - _timeStamp > LOOT_SPAWN_INTERVAL}}) then
					{
						_pos = _x modelToWorld [0,0,0]; // nearestObjects scan distance is based from model center
						
						[_buildList, [typeOf _x, _pos]] call BIS_fnc_arrayPush; // buildings must be transmitted by position and class because they have no network ID
					};
				
				} forEach nearestObjects [player, _spawnBuilding_list, PLAYER_LOOT_SPAWN_RADIUS];
				
				if (count _buildList > 0) then
				{
					pvar_spawnLootBuildings = _buildList;
					publicVariableServer "pvar_spawnLootBuildings";
				};
			};
		};
		
		sleep 10;
	};
};
