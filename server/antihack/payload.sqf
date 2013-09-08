
//	@file Version: 1.0
//	@file Name: payload.sqf
//	@file Author: Originally made by AXA from OpenDayZ.net, improved by AgentRev
//	@file Created: 01/06/2013 21:31

if (isDedicated) exitWith {};

private ["_cheatFlag", "_cfgPatches", "_patchClass", "_defaultRecoil", "_currentRecoil", "_recoilDifference", "_sign"];

waitUntil {!isNull player};
_defaultRecoil = unitRecoilCoefficient player;

// diag_log "ANTI-HACK 0.8.0 starting...";

_cfgPatches = configFile >> "CfgPatches";

for "_i" from 0 to (count _cfgPatches - 1) do
{
    _patchClass = _cfgPatches select _i;
	
    if (isClass _patchClass && {(toLower configName _patchClass) in ["devcon","loki_lost_key"]}) then
    {
        _cheatFlag = ["hacking addon", configName _patchClass];
    };
};

{
	if (loadFile _x != "") exitWith
	{
		// diag_log "ANTI-HACK 0.8.0: Found a hack menu!";

		_cheatFlag = ["hack menu", _x];
	};
} forEach ["used for hacking", "wuat\screen.sqf", "menu\exec.sqf", "scripts\fazeddays.sqf", "vet@folder\vet@start.sqf", "WookieMenuV5.sqf", "menu\initmenu.sqf", "scripts\WookieMenuFinal.sqf", "LystoArma3\start.sqf", "fazeddays.sqf", "ShadowyFaze\exec.sqf", "WookieMenuFinal.sqf", "wuat\exec.sqf", "crinkly\keymenu.sqf", "scripts\ajmenu.sqf", "Wookie_Beta\start.sqf", "jestersMENU\exec.sqf", "scripts\WookieMenuV5.sqf", "scripts\WookieMenu.sqf", "scr\start.sqf", "WookieMenu.sqf", "wookie_wuat\startup.sqf", "scripts\defaultmenu.sqf"];

// diag_log "ANTI-HACK 0.8.0: Starting loop!";

// diag_log "ANTI-HACK 0.8.0: Detection of hack variables started!";

while { true } do
{			
	waitUntil {time > 0.1};
	
	if (isNil "_cheatFlag") then 
	{
		// diag_log "ANTI-HACK 0.8.0: Recoil hack check started!";
		
		_currentRecoil = unitRecoilCoefficient player;
		
		if ((_currentRecoil < _defaultRecoil - 0.001 || _currentRecoil > _defaultRecoil + 0.001) && {_defaultRecoil != -1 && _currentRecoil != -1}) then
		{
			// diag_log "ANTI-HACK 0.8.0: Detected recoil hack!";
			
			_recoilDifference = ((_currentRecoil / _defaultRecoil) - 1) * 100;
			_sign = "";
			
			switch (true) do
			{
				case (_recoilDifference > 0): { _sign = "+" };
				case (_recoilDifference < 0): { _sign = "-" };
			};
			
			_cheatFlag = ["recoil hack", _sign + (str ceil abs _recoilDifference) + "% difference"];
		};
	};
	
	if (!isNil "_cheatFlag") exitWith
	{
		waitUntil {time > 0.1};
		
		diag_log str [profileName, getPlayerUID player, _cheatFlag select 0, _cheatFlag select 1];
		
		[[profileName, getPlayerUID player, _cheatFlag select 0, _cheatFlag select 1, _flagChecksum], "flagHandler", false, false] call TPG_fnc_MP;
		
		endMission "LOSER";
		
		for "_i" from 0 to 99 do
		{
			(findDisplay _i) closeDisplay 0;
		};
	};
	
	sleep 30;
};
