//	@file Name: c_setupPlayerDB.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};

fn_requestPlayerData = compileFinal "requestPlayerData = player; publicVariableServer 'requestPlayerData'";
fn_applyPlayerData = "persistence\players\c_applyPlayerData.sqf" call mf_compile;
fn_savePlayerData = "persistence\players\c_savePlayerData.sqf" call mf_compile;

"applyPlayerData" addPublicVariableEventHandler
{
	_this spawn
	{
		_data = _this select 1;
		
		if (count _data > 0) then
		{
			playerData_alive = true;
			
			_pos = [_data, "Position", []] call BIS_fnc_getFromPairs;
			
			if (count _pos > 2) then
			{
				player groupChat "Preloading location...";
				waitUntil {sleep 0.1; preloadCamera _pos};
			};
			
			_data call fn_applyPlayerData;
			
			player groupChat "Player account loaded!";
			
			//fixes the issue with saved player being GOD when they log back on the server!
			player allowDamage true;
			
			execVM "client\functions\firstSpawn.sqf";
		};
		
		playerData_loaded = true;
	};
};
