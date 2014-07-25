//	@file Version: 1.0
//	@file Name: filterExecAttempt.sqf
//	@file Author: AgentRev
//	@file Created: 14/07/2013 13:10

if (!isServer) exitWith {};

private "_packetName";
_packetName = [_this, 0, "", [""]] call BIS_fnc_param;

if (_packetName == "BIS_fnc_MP_packet") then
{
	private ["_values", "_arguments", "_code", "_function", "_filePath", "_allowedFile", "_allowedFunction"];
	_values = [_this select 1, 0] call BIS_fnc_removeIndex;
	
	_arguments = [_values, 0] call BIS_fnc_removeIndex;
	_code = _values select 0;
	_function = _values select 1;
	
	_allowedFile = false;
	
	if (_function == "BIS_fnc_execVM") then
	{
		_filePath = [_code, 1, "", [""]] call BIS_fnc_param;
		
		{
			if (_filePath == _x) exitWith
			{
				_allowedFile = true;
			};
		}
		forEach
		[
			"client\functions\defineServerRules.sqf",
			"territory\client\updateTerritoryMarkers.sqf",
			"initPlayerServer.sqf"
		];
	};
	
	_allowedFunction = false;
	
	{
		if (_function == _x) exitWith
		{
			_allowedFunction = true;
		};
	}
	forEach
	[
		"BIS_fnc_effectKilledAirDestruction",
		"BIS_fnc_effectKilledAirDestructionStage2",
		"BIS_fnc_effectKilledSecondaries",
		"BIS_fnc_kbTellLocal",
		"BIS_fnc_showNotification",
		"BIS_fnc_taskSetState",
		"BIS_fnc_tridentHandleDamage",
		"BIS_fnc_tridentHandleDamage_server",
		"JTS_FNC_SENT" // PM Compact by JTS
	];

	if (_allowedFile || _allowedFunction) then
	{
		_this call BIS_fnc_MPexec;
	}
	else
	{
		_arguments = [_values, 0] call BIS_fnc_removeIndex;
		_code = _values select 0;
		diag_log format ["ANTI-HACK 0.8.0: Blocked remote execution: arguments=%1 code=%2", _arguments, str _code];
	};
};