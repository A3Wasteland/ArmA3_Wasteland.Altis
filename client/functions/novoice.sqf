private ["_chat", "_chatIndex", "_seconds", "_reset_timer", "_disconnect_me", "_warn_one", "_warn_last", "_reset_timer", "_checkInterval"];
_globalSeconds = _this select 0;
_sideSeconds = _this select 1;
_commandSeconds = _this select 2;

_chat = [ localize "str_channel_global", localize "str_channel_side", localize "str_channel_command" ];

_checkInterval = 0.2;
noVoiceResetTimer = [0, 0, 0];
noVoiceWarnOne = [false, false, false];
noVoiceWarnFinal = [false, false, false];
noVoiceDisconnectMe = [-1, -1, -1];

disableSerialization;
_DS_really_loud_sounds = {for "_i" from 1 to 10 do {playSound format ["%1",_this select 0];};};
_DS_double_cut = {1 cutText [format ["%1",_this select 0],"PLAIN DOWN"];2 cutText [format ["%1",_this select 0],"PLAIN"];};
_DS_slap_them = {_randomnr = [2,-1] call BIS_fnc_selectRandom;(vehicle player) SetVelocity [_randomnr * random (4) * cos getdir (vehicle player), _randomnr * random (4) * cos getdir (vehicle player), random (4)];};

_voiceBanAction = {
	_chatIndex = _this;
	_uid = getPlayerUID player;
	
	if ( { (_x select 0) == _uid } count pvar_voiceBanPlayerArray == 0) then 
	{
		pvar_voiceBanPlayerArray set [ count pvar_voiceBanPlayerArray, [_uid, 0, 0, 0]];
	};
	
	{
		if ((_x select 0) == _uid ) then
		{
			switch (_chatIndex) do
			{
				case 1:
				{
					_x set [2, (_x select 2) + 1];
				};
				case 2:
				{
					_x set [3, (_x select 3) + 1];
				};
				default
				{
					_x set [1, (_x select 1) + 1];
				};
			};
			
			if(((_x select 1) + (_x select 2) + (_x select 3)) > 1) then //delete player data on second kick and afterwards so it doesn't get abused to 'combatlog'
			{
				_uid call fn_deletePlayerSave;
			};
		};
	} forEach pvar_voiceBanPlayerArray;
	
	publicVariable "pvar_voiceBanPlayerArray";
} call mf_compile;

_checkVoiceChat = {
	_chatIndex = _this select 0;
	_seconds = _this select 1;
	if (noVoiceResetTimer select _chatIndex == 0) then {
		noVoiceResetTimer set [_chatIndex, time];
	};
	
	_resetTimer = noVoiceResetTimer select _chatIndex;
	
	if ((_resetTimer != 0) && {(_resetTimer - time) > A3W_VoiceKickTimeout}) then {
		noVoiceDisconnectMe set [_chatIndex, -1];
		noVoiceWarnOne set [_chatIndex, false];
		noVoiceWarnFinal set [_chatIndex, false];
		noVoiceResetTimer set [_chatIndex, 0];
	};
	
	if (noVoiceDisconnectMe select _chatIndex < 0) then {
		noVoiceDisconnectMe set [_chatIndex, 0];
	} else {
		noVoiceDisconnectMe set [_chatIndex, (noVoiceDisconnectMe select _chatIndex) + _checkInterval];
	};
	
	if (noVoiceDisconnectMe select _chatIndex == 0) then {
		if (!(noVoiceWarnOne select _chatIndex)) then {
			noVoiceWarnOne set [_chatIndex, true];
			systemChat (format ["Please do not use voice on %1, this is your first and final warning. Switch channel with , and . and create a group to talk with your buddies.", (_chat select _chatIndex)]);
			[] spawn _DS_slap_them;
			["Alarm"] spawn _DS_really_loud_sounds;
			[format ["NO VOICE ON %1", (_chat select _chatIndex)]] spawn _DS_double_cut;
			axeDiagLog = format ["%1 got warned for talking on %2", name player, (_chat select _chatIndex)];
			publicVariable "axeDiagLog";
		};
	};
	if (noVoiceDisconnectMe select _chatIndex >= _seconds) then {//kick after x seconds of talking
		if (!(noVoiceWarnFinal select _chatIndex)) then {
			noVoiceWarnFinal set [_chatIndex, true];
			_chatIndex call _voiceBanAction;
			axeDiagLog = format ["%1 got kicked for talking on %2", name player, (_chat select _chatIndex)];
			publicVariable "axeDiagLog";
			playMusic ["PitchWhine",0];
			[] spawn _DS_slap_them;
			["Alarm"] spawn _DS_really_loud_sounds;
			["We warned you..."] spawn _DS_double_cut;
			sleep 0.5;
			1 fademusic 10;
			1 fadesound 10;
			endMission (format ["Don't talk in %1!", (_chat select _chatIndex)]);
		};
	};
} call mf_compile;

while {true} do {
	waitUntil {
		sleep _checkInterval;
		((!isNull findDisplay 63) && (!isNull findDisplay 55))
	};
	if (ctrlText ((findDisplay 55) displayCtrl 101) == "\A3\ui_f\data\igui\rscingameui\rscdisplayvoicechat\microphone_ca.paa") then {
		switch (true) do
		{
			case ((_globalSeconds > 0) && (ctrlText ((findDisplay 63) displayCtrl 101) == (_chat select 0))):
			{
				[0, _globalSeconds] call _checkVoiceChat;
			};
			case ((_sideSeconds > 0) && (ctrlText ((findDisplay 63) displayCtrl 101) == (_chat select 1))):
			{
				[1, _sideSeconds] call _checkVoiceChat;
			};
			case ((_commandSeconds > 0) && (ctrlText ((findDisplay 63) displayCtrl 101) == (_chat select 2))):
			{
				[2, _commandSeconds] call _checkVoiceChat;
			};
		};
	};
	sleep _checkInterval;
};