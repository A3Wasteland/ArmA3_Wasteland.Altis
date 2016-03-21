// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_fixUniVestBug.sqf
//	@file Author: AgentRev

// Crappy workaround for uniform and vest desync bug from A3 v1.56

// me irl http://i.imgur.com/XStaKp3.gifv

if (isServer) then
{
	if (!isNil "A3W_fixUniVestBug_active") exitWith {};
	A3W_fixUniVestBug_active = compileFinal "true";

	[] spawn
	{
		waitUntil {sleep 30; !isNil "A3W_serverSetupComplete"};
		while {true} do
		{
			sleep 30;
			{
				if (!local _x && alive _x && !(_x getVariable ["playerSpawning", true])) then
				{
					[uniform _x, vest _x] remoteExecCall ["A3W_fnc_fixUniVestBug", _x];
				};
				sleep 0.01;
			} forEach allPlayers;
		};
	};
}
else
{
	if (count _this < 2 || isNil "playerCompiledScripts" || !alive player || player getVariable ["playerSpawning", true]) exitWith {};

	params ["_sUniform", "_sVest"];

	_cUniform = uniform player;
	_cVest = vest player;

	_fixUniform = (_cUniform != _sUniform);
	_fixVest = (_cVest != _sVest);

	if (_fixUniform || _fixVest) then
	{
		_arrFix = [];

		if (_fixUniform) then { _arrFix pushBack "Uniform" };
		if (_fixVest) then { _arrFix pushBack "Vest" };

		if (isNil "fn_getPlayerData") then { fn_getPlayerData = "persistence\client\players\getPlayerData.sqf" call mf_compile };
		if (isNil "fn_applyPlayerData") then { fn_applyPlayerData = "persistence\client\players\applyPlayerData.sqf" call mf_compile };

		_data = [[player] call fn_getPlayerData, { [_arrFix, _x select 0] call fn_startsWith }] call BIS_fnc_conditionalSelect;

		if (_fixUniform) then { removeUniform player };
		if (_fixVest) then { removeVest player };

		[_data, false] call fn_applyPlayerData;
	};
};
