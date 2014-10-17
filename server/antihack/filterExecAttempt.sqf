//	@file Version: 1.0
//	@file Name: filterExecAttempt.sqf
//	@file Author: AgentRev
//	@file Created: 14/07/2013 13:10

if (!isServer) exitWith {};

private "_packetName";
_packetName = [_this, 0, "", [""]] call BIS_fnc_param;

if (_packetName == "BIS_fnc_MP_packet") then
{
	private ["_values", "_code", "_function", "_whitelisted", "_filePath", "_args2", "_buffer"];

	_values = +(_this select 1);
	_values deleteAt 0;

	_code = _values select 0;
	_function = _values select 1;
	_whitelisted = false;

	if (_function == "BIS_fnc_execVM") then
	{
		_filePath = [_code, 1, "", [""]] call BIS_fnc_param;

		{
			if (_filePath == _x) exitWith
			{
				_whitelisted = true;
			};
		}
		forEach
		[
			"client\functions\defineServerRules.sqf",
			"territory\client\updateTerritoryMarkers.sqf",
			"initPlayerServer.sqf"
		];
	};

	if (!_whitelisted) then
	{
		{
			if (_function == _x) exitWith
			{
				_whitelisted = true;
			};
		}
		forEach
		[
			"BIS_fnc_effectKilledAirDestruction",
			"BIS_fnc_effectKilledAirDestructionStage2",
			"BIS_fnc_effectKilledSecondaries"/*,
			"JTS_FNC_SENT"*/ // PM Compact by JTS
		];
	};

	if (_whitelisted) then
	{
		_this call BIS_fnc_MPexec;
	}
	else
	{
		_values deleteAt 0;
		_args2 = if (typeName _code == "STRING") then { "'" + _code + "'" } else { str (if (typeName _code in ["BOOL","SCALAR","ARRAY","SIDE"]) then { _code } else { str _code }) };
		_buffer = toArray ("ANTI-HACK: Blocked remote execution: params=" + str _values + " args=" + _args2);

		while {count _buffer > 0} do
		{
			diag_log toString (_buffer select [0, 1024]);
			_buffer deleteRange [0, 1024];
		};
	};
};
