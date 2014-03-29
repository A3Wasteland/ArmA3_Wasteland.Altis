//	@file Version: 1.0
//	@file Name: updateTeamKiller.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19

if (playerSide in [BLUFOR,OPFOR]) then
{
	{
		if (_x select 0 == getPlayerUID player && {_x select 1 > 1}) exitWith
		{
			_text = localize "STR_WL_Loading_Teamkiller";
			9999 cutText [_text, "BLACK"];
			titleText [_text, "BLACK"];
			removeAllWeapons player;
			
			[] spawn
			{
				sleep 20;
				endMission "LOSER";
			};
		};
	} forEach pvar_teamKillList;
};
