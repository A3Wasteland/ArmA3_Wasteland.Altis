//	@file Version: 1.0
//	@file Name: onPause.sqf
//	@file Author: AgentRev
//	@file Created: 22/12/2013 15:48

disableSerialization;

waitUntil {!isNull findDisplay 49}; // 49 = Esc menu

// Disable field manual to prevent scriptkiddie exploits
((findDisplay 49) displayCtrl 122) ctrlEnable false;

with missionNamespace do
{
	_getPublicVar = missionNamespace getVariable "getPublicVar";
	_isConfigOn = missionNamespace getVariable "isConfigOn";
	
	if (alive player && !isNil "_getPublicVar" && !isNil "_isConfigOn") then
	{
		if (["A3W_playerSaving"] call _isConfigOn &&
		   {["playerSetupComplete", false] call _getPublicVar} &&
		   {!(["playerSpawning", false] call _getPublicVar)}) then
		{
			_abortDelay = ["A3W_combatAbortDelay", 0] call _getPublicVar;
			
			if (_abortDelay > 0) then
			{
				_preventAbort =
				{
					_timeStamp = ["combatTimestamp", -1] call _getPublicVar;
					(!isNull findDisplay 49 && {_timeStamp != -1} && {diag_tickTime - _timeStamp < _abortDelay})
				};
				
				_enableButtons =
				{
					_display = findDisplay 49;
					if (!isNull _display) then
					{
						(_display displayCtrl 104) ctrlEnable _this; // Abort
						(_display displayCtrl 1010) ctrlEnable _this; // Respawn
					};
				};
				
				if !(["cannotAbortMessage", false] call _getPublicVar) then
				{
					if (call _preventAbort) then
					{
						missionNamespace setVariable ["cannotAbortMessage", true];
						
						with missionNamespace do { [false] spawn fn_savePlayerData };
						false call _enableButtons;
						
						private "_timeStamp";
						while {call _preventAbort} do
						{
							_remaining = ceil (_abortDelay - (diag_tickTime - _timeStamp));
							_mins = floor (_remaining / 60);
							_secs = _remaining - (_mins * 60);
							_time = format ["%1:%2%3", _mins, if (_secs < 10) then { "0" } else { "" }, _secs];
							
							cutText [format ["\nCannot pussy out during combat! (%1)", _time], "PLAIN DOWN"];
							sleep 1;
						};
						
						true call _enableButtons;
						cutText ["", "PLAIN DOWN"];
						
						missionNamespace setVariable ["cannotAbortMessage", false];
					}
					else
					{
						with missionNamespace do { [true] spawn fn_savePlayerData };
					};
				};
			}
			else
			{
				with missionNamespace do { [true] spawn fn_savePlayerData };
			};
		};
	};
};
