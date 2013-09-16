//	@file Version: 1.0
//	@file Name: serverSide.sqf
//	@file Author: AgentRev
//	@file Created: 29/06/2013 18:01

if (!isServer) exitWith {};

private "_cheatFlag";

"BIS_fnc_MP_packet" addPublicVariableEventHandler compileFinal "_this execVM 'server\antihack\badExecAttempt.sqf'";

// diag_log "ANTI-HACK 0.8.0: Starting loop!";

// diag_log "ANTI-HACK 0.8.0: Detection of hacked units!";

while { true } do
{			
	waitUntil {time > 0.1};
	
	if (isNil "_cheatFlag") then 
	{
		{
			if ((isDedicated && owner _x > 1) || owner _x > 2) then
			{
				if (alive _x && {!isPlayer _x} && {["_UAV_AI", typeOf _x] call fn_findString == -1}) then
				{
					if (isNil "_cheatFlag") then
					{
						_cheatFlag = [];
					};
					
					_cheatFlag set [count _cheatFlag, ["hacked unit", typeOf _x, [owner _x] call findClientPlayer]];
					deleteVehicle _x;
				};
			};
		} forEach (allUnits - playableUnits);
	};
	
	if (!isNil "_cheatFlag") then
	{
		{
			private "_player";
			_player = _x select 2;
			
			if (isPlayer _player) then
			{
				[[getPlayerUID _player, _flagChecksum], "clientFlagHandler", _player, false] call TPG_fnc_MP;
				
				[name _player, getPlayerUID _player, _x select 0, _x select 1, _flagChecksum] call flagHandler;
			};
		} forEach _cheatFlag;
		
		_cheatFlag = nil;
	};
	
	sleep 5;
};
