//	@file Name: c_setupPlayerDB.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};

fn_requestPlayerData = compileFinal "requestPlayerData = player; publicVariableServer 'requestPlayerData'";
fn_deletePlayerData = compileFinal "deletePlayerData = player; publicVariableServer 'deletePlayerData'; playerData_gear = ''";
fn_applyPlayerData = "persistence\players\c_applyPlayerData.sqf" call mf_compile;
fn_applyPlayerInfo = "persistence\players\c_applyPlayerInfo.sqf" call mf_compile;
fn_savePlayerData = "persistence\players\c_savePlayerData.sqf" call mf_compile;

"applyPlayerData" addPublicVariableEventHandler
{
	_this spawn
	{
		_data = _this select 1;
		_saveValid = [_data, "PlayerSaveValid", false] call fn_getFromPairs;

		if (_saveValid) then
		{
			playerData_alive = true;

			_pos = [_data, "Position", []] call fn_getFromPairs;
			_preload = profileNamespace getVariable ["A3W_preloadSpawn", true];

			if (count _pos == 2) then { _pos set [2, 0] };
			if (count _pos == 3) then
			{
				if (_preload) then
				{
					player groupChat "Preloading previous location...";
					waitUntil {sleep 0.1; preloadCamera _pos};
				}
				else
				{
					player groupChat "Loading previous location...";
				};
			}
			else
			{
				playerData_resetPos = true;
			};

			_data call fn_applyPlayerData;
		};

		_data call fn_applyPlayerInfo;

		if (_saveValid) then
		{
			player groupChat "Player account loaded!";

			if (isNil "playerData_resetPos") then
			{
				player enableSimulation true;
				player allowDamage true;
				player setVelocity [0,0,0];

				execVM "client\functions\firstSpawn.sqf";
			}
			else
			{
				player groupChat "Your position has been reset";
			};
		};

		playerData_loaded = true;
	};
};
