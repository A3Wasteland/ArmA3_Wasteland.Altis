
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

// diag_log "ANTI-HACK 0.8.0: Starting loop!";

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
		
		[getPlayerUID player, _flagChecksum] call clientFlagHandler;
	};
	
	sleep 5;
};
