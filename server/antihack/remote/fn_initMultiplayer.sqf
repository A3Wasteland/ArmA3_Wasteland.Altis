
/*
	Author: Karel Moricky, modified by AgentRev

	Description:
	Multiplayer mission init, executed automatically upon mission start.

	Parameter(s):
	None

	Returns:
	NOTHING
*/

//--- Execute MP functions

if (isnil _mpPacketKey) then {
	[_mpPacketKey] spawn {
		private ["_mpPacketKey"];
		_mpPacketKey = _this select 0;
		
		waituntil {!isnull cameraon || isDedicated || !hasInterface};
		
		// ["BIS_fnc_initMultiplayer"] call bis_fnc_startLoadingScreen;
		
		// if (isNil _mpPacketKey) then
		// {
			call compile format ["%1 = []", _mpPacketKey];
		// }
		// else
		// {
		// 	[_mpPacketKey, call compile _mpPacketKey] call TPG_fnc_MPexec;
		// };

		_mpPacketKey addPublicVariableEventHandler compileFinal "_this call TPG_fnc_MPexec";

		//--- Execute persistent functions
		waituntil {!isnil "bis_functions_mainscope"};
		_queue = bis_functions_mainscope getvariable ["BIS_fnc_MP_queue",[]];
		{
			if (str _x != str call compile _mpPacketKey) then
			{
				//--- Do not declare persistent call again to avoid infinite loop
				_varValue = +_x;
				_mode = 	[_varValue,0,[0]] call bis_fnc_paramin;
				_params = 	[_varValue,1,[]] call bis_fnc_paramin;
				_functionName =	[_varValue,2,"",[""]] call bis_fnc_paramin;
				_target =	[_varValue,3,-1,[objnull,true,0,[],sideUnknown,grpnull]] call bis_fnc_paramin;
				_isPersistent =	[_varValue,4,false,[false]] call bis_fnc_paramin;
				_isCall =	[_varValue,5,false,[false]] call bis_fnc_paramin;

				switch (typename _target) do {
					case (typename objnull): {
						if (local _target) then {
							[_mpPacketKey,[_mode,_params,_functionName,_target,false,_isCall]] call TPG_fnc_MPexec; //--- Local execution
						};
					};
					case (typename true): {
						if (_target) then {
							[_mpPacketKey,[_mode,_params,_functionName,_target,false,_isCall]] call TPG_fnc_MPexec; //--- Local execution
						} else {
							[_params,_functionName,_target,false,_isCall] call TPG_fnc_MP; //--- Global execution
						};
					};
					case (typename grpnull);
					case (typename sideUnknown): {
						[_mpPacketKey,[_mode,_params,_functionName,_target,false,_isCall]] call TPG_fnc_MPexec; //--- Local execution
					};
					case (typename 0): {
						//--- Disabled
					};
				};
			};
		} foreach _queue;
		
		// ["BIS_fnc_initMultiplayer"] call bis_fnc_endLoadingScreen;
	};
};
