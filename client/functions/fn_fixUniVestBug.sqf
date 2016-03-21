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
		if !(["A3W_playerSaving"] call isConfigOn) exitWith {};

		while {true} do
		{
			sleep 30;
			{
				if (alive _x && !(_x getVariable ["playerSpawning", true])) then
				{
					[uniform _x, vest _x] remoteExecCall ["A3W_fnc_fixUniVestBug", owner _x];
				};
				sleep 0.01;
			} forEach allPlayers;
		};
	};
}
else
{
	if (!alive player || player getVariable ["playerSpawning", true] || count _this < 2 || !(_this isEqualTypeAll "")) exitWith {};

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

		_data = [[player] call fn_getPlayerData, { [_arrFix, _x select 0] call fn_startsWith }] call BIS_fnc_conditionalSelect;

		if (_fixUniform) then { removeUniform player };
		if (_fixVest) then { removeVest player };

		[_data, false] call fn_applyPlayerData;
	};
};
