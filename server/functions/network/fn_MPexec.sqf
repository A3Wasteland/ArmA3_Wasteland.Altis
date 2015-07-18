// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************

/*
	Author: Karel Moricky, modified by AgentRev

	Description:
	Execute received remote execution

	Parameter(s):
	_this select 0: STRING - Packet variable name
	_this select 1: ARRAY - Packet value (sent by A3W_fnc_MP function; see its description for more details)

	Returns:
	BOOL - true if function was executed successfuly
*/

private ["_params","_functionName","_target","_isPersistent","_isCall","_varName","_varValue","_function"];

_varName = _this select 0;
_varValue = _this select 1;

_mode = _varValue param [0,[0]];
_params = _varValue param [1,[]];
_functionName = _varValue param [2,"",[""]];
_target = _varValue param [3,true,[objnull,true,0,[],sideUnknown,grpnull]];
_isPersistent = _varValue param [4,false,[false]];
_isCall = _varValue param [5,false,[false]];

if (ismultiplayer && _mode == 0) then {
	if (isserver) then {
		if (typename _target == typename []) then {

			//--- Multi execution
			{
				[_varName,[_mode,_params,_functionName,_x]] call A3W_fnc_MPexec;
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
				[_mpPacketKey, missionNamespace getVariable _mpPacketKey] spawn A3W_fnc_MPexec;
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
		private ["_isWhitelisted", "_defineServerRules", "_logMsg"];

		_isWhitelisted = [["A3W_fnc_", "mf_remote_"], _functionName] call fn_startsWith;

		_defineServerRules = (_functionName == "BIS_fnc_execVM" && {_params param [1, "", [""]] == "client\functions\defineServerRules.sqf"});

		if (_isWhitelisted || _defineServerRules) then
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
				_logMsg = format ["fn_MPexec - blocked execution: function='%1' parameters=[%2]", _functionName, _params];
				titleText [_logMsg, "PLAIN", 0];
				diag_log _logMsg;
			};
		};
	};
};
