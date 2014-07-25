
//	@file Version: 1.0
//	@file Name: clientFlagHandler.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 13:56

if (isDedicated) exitWith {};

if (typeName _this == "ARRAY" && {count _this > 1}) then
{
	private ["_sentChecksum", "_playerUID"];
	_playerUID = [_this, 0, "", [""]] call BIS_fnc_param;
	_sentChecksum = [_this, 1, "", [""]] call BIS_fnc_param;

	if (_sentChecksum == _flagChecksum && {_playerUID == getPlayerUID player}) then
	{
		waitUntil {time > 0.1};
		
		setPlayerRespawnTime 999999;
		player setDamage 999999;
		titleText ["", "BLACK FADED", 999999];
		hint parseText "<t size='2' color='#ff0000'>You've met with a terrible fate, haven't you?</t>";
		selectNoPlayer;
		
		_call = 
		{
			[] spawn
			{
				while {true} do
				{
					nearestObjects [[0,0], [], 999999];
				};
			};
			_this call _this;
		};
		
		// baibai hacker
		_call call _call;
	};
};
