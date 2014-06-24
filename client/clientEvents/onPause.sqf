//	@file Version: 1.0
//	@file Name: onPause.sqf
//	@file Author: AgentRev
//	@file Created: 22/12/2013 15:48

disableSerialization;

waitUntil {!isNull findDisplay 49}; // 49 = Esc menu

// Disable field manual to prevent scriptkiddie exploits
((findDisplay 49) displayCtrl 122) ctrlEnable false;

_getPublicVar = if (!isNil "getPublicVar") then { getPublicVar } else { missionNamespace getVariable "getPublicVar" };
_isConfigOn = if (!isNil "isConfigOn") then { isConfigOn } else { missionNamespace getVariable "isConfigOn" };

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
				_unconscious = (player getVariable ["FAR_isUnconscious", 0] == 1);
				_timeStamp = ["combatTimestamp", -1] call _getPublicVar;
				(!isNull findDisplay 49 && ((_timeStamp != -1 && diag_tickTime - _timeStamp < _abortDelay) || _unconscious))
			};

			if !(call _preventAbort) then
			{
				with missionNamespace do { [true] spawn fn_savePlayerData };
			};

			if !(["onPauseLoopRunning", false] call _getPublicVar) then
			{
				missionNamespace setVariable ["onPauseLoopRunning", true];

				_enableButtons =
				{
					_display = findDisplay 49;
					if (!isNull _display) then
					{
						(_display displayCtrl 104) ctrlEnable _this; // Abort
						(_display displayCtrl 1010) ctrlEnable _this; // Respawn
					};
				};

				while {!isNull findDisplay 49} do
				{
					if (call _preventAbort) then
					{
						with missionNamespace do { [false] spawn fn_savePlayerData };
						false call _enableButtons;

						private ["_unconscious", "_timeStamp", "_text"];

						while {call _preventAbort} do
						{
							if (_unconscious) then
							{
								_text = "\n\n\n\nCannot pussy out during bleeding!";
							}
							else
							{
								_remaining = ceil (_abortDelay - (diag_tickTime - _timeStamp));
								_mins = floor (_remaining / 60);
								_secs = _remaining - (_mins * 60);
								_time = format ["%1:%2%3", _mins, if (_secs < 10) then { "0" } else { "" }, _secs];

								_text = format ["\nCannot pussy out during combat! (%1)", _time];
							};

							cutText [_text, "PLAIN DOWN"];
							sleep 1;
						};

						true call _enableButtons;
						cutText ["", "PLAIN DOWN"];
					}
					else
					{
						sleep 0.1;
					};
				};

				missionNamespace setVariable ["onPauseLoopRunning", nil];
			};
		}
		else
		{
			with missionNamespace do { [true] spawn fn_savePlayerData };
		};
	};
};
