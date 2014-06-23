
/*
	Author: Karel Moricky, modified by AgentRev

	Description:
	Execute received remote execution

	Parameter(s):
	_this select 0: STRING - Packet variable name
	_this select 1: ARRAY - Packet value (sent by TPG_fnc_MP function; see its description for more details)
	
	Returns:
	BOOL - true if function was executed successfuly
*/

private ["_params","_functionName","_target","_isPersistent","_isCall","_varName","_varValue","_function"];

_varName = _this select 0;
_varValue = _this select 1;

_mode = 	[_varValue,0,[0]] call bis_fnc_param;
_params = 	[_varValue,1,[]] call bis_fnc_param;
_functionName =	[_varValue,2,"",[""]] call bis_fnc_param;
_target =	[_varValue,3,true,[objnull,true,0,[],sideUnknown,grpnull]] call bis_fnc_param;
_isPersistent =	[_varValue,4,false,[false]] call bis_fnc_param;
_isCall =	[_varValue,5,false,[false]] call bis_fnc_param;

if (ismultiplayer && _mode == 0) then {
	if (isserver) then {
		if (typename _target == typename []) then {

			//--- Multi execution
			{
				[_varName,[_mode,_params,_functionName,_x]] call TPG_fnc_MPexec;
			} foreach _target;
		} else {

			//--- Single execution
			private ["_ownerID","_serverID"];
			_serverID = owner (missionnamespace getvariable ["bis_functions_mainscope",objnull]); //--- Server ID is not always 0

			//--- Server process
			switch (typename _target) do {
				case (typename objnull): {
					_ownerID = owner _target;
				};
				case (typename true): {
					_ownerID = [_serverID,-1] select _target;
				};
				case (typename 0): {
					_ownerID = _target;
				};
				case (typename grpnull);
				case (typename sideUnknown): {
					_ownerID = -1;
				};
			};
			missionNamespace setVariable [_mpPacketKey, [1,_params,_functionName,_target,_isPersistent,_isCall]];

			//--- Send to clients
			if (_ownerID < 0) then {
				//--- Everyone
				publicvariable _mpPacketKey;
			} else {
				if (_ownerID != _serverID) then {
					//--- Client
					_ownerID publicvariableclient _mpPacketKey;
				};
			};

			//--- Server execution (for all or server only)
			if (_ownerID < 0 || _ownerID == _serverID) then {
				[_mpPacketKey, missionNamespace getVariable _mpPacketKey] spawn TPG_fnc_MPexec;
			};

			//--- Persistent call (for all or clients)
			if (_isPersistent) then {
				if (typename _target != typename 0) then {
					private ["_logic","_queue"];
					_logic = missionnamespace getvariable ["bis_functions_mainscope",objnull];
					_queue = _logic getvariable ["BIS_fnc_MP_queue",[]];
					_queue set [
						count _queue,
						+(missionNamespace getVariable _mpPacketKey)
					];
					_logic setvariable ["BIS_fnc_MP_queue",_queue,true];
				} else {
					["Persistent execution is not allowed when target is %1. Use %2 or %3 instead.",typename 0,typename objnull,typename false] call bis_fnc_error;
				};
			};
		};
	};

} else {
	//--- Client
	private ["_canExecute"];
	_canExecute = switch (typename _target) do {
		case (typename grpNull): {group player == _target || (!alive player && player getVariable ["currentGroupRestore", grpNull] == _target)};
		case (typename sideUnknown): {playerSide == _target};
		default {true};
	};

	if (_canExecute) then 
	{
		private ["_allowedFunctions", "_blockedParams", "_blockedFunction", "_defineServerRules"];
		
		_allowedFunctions =
		[
			"chatBroadcast",
			"checkHackedVehicles",
			"flagHandler",
			"clientFlagHandler",
			"titleTextMessage",
			"territoryActivityHandler",
			"spawnStoreObject",
			"pushVehicle",
			"convertTerritoryOwner",
			"updateTerritoryMarkers",
			"parachuteLiftedVehicle"
		];
		
		_blockedParam = 
		[
			[
				"createMine",
				"createUnit",
				"createVehicle",
				"money",
				"toString",
				"publicVariableClient",
				"BIS_fnc_AAN",
				"BIS_fnc_3dCredits",
				"spawnCrew",
				"spawnEnemy",
				"spawnGroup",
				"spawnVehicle",
				"BIS_fnc_MP_packet",
				"vChecksum"
			],
			[str _params] call fn_filterString
		] call fn_findString;
		
		_blockedFunction = [["creat","spawning","AAN","3dCredits","spawnCrew","spawnEnemy","spawnGroup","spawnVehicle"], [_functionName] call fn_filterString] call fn_findString;
		
		_defineServerRules = (_functionName == "BIS_fnc_execVM" && {[_params, 1, "", [""]] call BIS_fnc_param == "client\functions\defineServerRules.sqf"});
		
		if (_functionName in _allowedFunctions || {_defineServerRules} || {_blockedParam == -1 && _blockedFunction == -1}) then
		{
			_function = missionnamespace getvariable _functionName;
			if (!isnil "_function") then
			{
				_params spawn _function;
				true
			}
			else
			{
				["Function '%1' does not exist",_functionName] call bis_fnc_error;
				false
			};
		}
		else
		{
			if (isServer) then
			{
				diag_log format ["TPG_fnc_MPexec: An unknown player attempted to execute: function=%2 parameters=[%1]", _functionName, _params];
			};
		};
	};
};
