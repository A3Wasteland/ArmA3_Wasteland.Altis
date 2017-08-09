// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: setupPlayerDB.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};

_playerFuncs = "persistence\client\players";

fn_applyPlayerData = [_playerFuncs, "applyPlayerData.sqf"] call mf_compile;
fn_applyPlayerInfo = [_playerFuncs, "applyPlayerInfo.sqf"] call mf_compile;
fn_savePlayerData = [_playerFuncs, "savePlayerData.sqf"] call mf_compile;

fn_requestPlayerData =
{
	playerData_alive = nil;
	playerData_loaded = nil;
	playerData_resetPos = nil;
	[player] remoteExecCall ["A3W_fnc_requestPlayerData", 2];
} call mf_compile;

fn_deletePlayerData =
{
	[player] remoteExecCall ["A3W_fnc_deletePlayerData", 2];
	playerData_infoPairs = nil;
	playerData_savePairs = nil;
} call mf_compile;


("pvar_applyPlayerData_" + getPlayerUID player) addPublicVariableEventHandler
{
	(_this select 1) spawn
	{
		scopeName "pvar_applyPlayerData";
		_data = _this;
		_saveValid = [_data, "PlayerSaveValid", false] call fn_getFromPairs;
		_ghostingTimer = [_data, "GhostingTimer", 0] call fn_getFromPairs;

		private "_pos";

		if (_saveValid) then
		{
			if (_ghostingTimer > 0 && {!((getPlayerUID player) call isAdmin) || ["A3W_extDB_GhostingAdmins"] call isConfigOn}) then
			{
				["You have recently played on another server from the same hive.<br/><br/>" +
				"In order to prevent ghosting, you will have to wait before being able to play here.<br/><br/>" +
				"Respawning will cancel the timer. You can also rejoin your previous server without penalty.", "Ghosting Timer"] spawn BIS_fnc_guiMessage;

				playerData_ghostingTimer = true;
				_time = diag_tickTime;

				while {diag_tickTime - _time < _ghostingTimer && alive player} do
				{
					9999 cutText ["Ghosting timer\n" + ((_ghostingTimer - (diag_tickTime - _time)) call fn_formatTimer), "BLACK", 0.01];
					uiSleep 0.5;
				};

				playerData_ghostingTimer = nil;
				if (!alive player) then { breakOut "pvar_applyPlayerData" };

				9999 cutText ["Loading...", "BLACK", 0.01];
			};

			playerData_alive = true;

			_pos = [_data, "Position", []] call fn_getFromPairs;
			_preload = profileNamespace getVariable ["A3W_preloadSpawn", true];

			{ if (typeName _x == "STRING") then { _pos set [_forEachIndex, parseNumber _x] } } forEach _pos;

			if (count _pos == 2) then { _pos set [2, 0] };
			if (count _pos == 3) then
			{
				if (_preload) then
				{
					9999 cutText ["Preloading previous location...", "BLACK", 0.01];
					waitUntil {sleep 0.1; preloadCamera _pos};
				};

				9999 cutText ["Loading previous location...", "BLACK", 0.01];
			}
			else
			{
				playerData_resetPos = true;
			};

			waitUntil {!isNil "bis_fnc_init" && {bis_fnc_init}}; // wait for loading screen to be done

			_data call fn_applyPlayerData;
		};

		_data call fn_applyPlayerInfo;

		if (_saveValid) then
		{
			if (isNil "playerData_resetPos") then
			{
				execVM "client\functions\firstSpawn.sqf";

				playerData_spawnPos = _pos;
				playerData_spawnDir = [_data, "Direction"] call fn_getFromPairs;

				[] spawn fn_savePlayerData;
			}
			else
			{
				player groupChat "Your position has been reset";
			};
		};

		playerData_loaded = true;
	};
};
