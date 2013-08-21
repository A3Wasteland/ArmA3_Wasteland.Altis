//	@file Version: 1.0
//	@file Name: playerSpawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_side"];

playerSpawning = true;
playerUID = getPlayerUID(player);
townSearch = 0;
beaconSearch = 0;

doKickTeamKiller = false;
doKickTeamSwitcher = false;

//Check Teamkiller
{
	if(_x select 0 == playerUID) then {
        
		if((_x select 1) >= 2) then {
			if(playerSide in [west, east]) then {
				doKickTeamKiller = true;
			};
		};
	};
} forEach pvar_teamKillList;

//Check Teamswitcher
{
	if(_x select 0 == playerUID) then
    {
        if(playerSide != (_x select 1) && !(playerSide in [INDEPENDENT,sideEnemy])) then{
        	doKickTeamSwitcher = true;
			_side = str(_x select 1);
        };	
	};
} forEach pvar_teamSwitchList;

//Kick to lobby for appropriate reason
//Teamkiller Kick
if(doKickTeamKiller) exitWith {
	titleText ["", "BLACK IN", 0];
	titleText [localize "STR_WL_Loading_Teamkiller", "black"]; titleFadeOut 9999;
	[] spawn {sleep 20; endMission "LOSER";};
};

//Teamswitcher Kick
if(doKickTeamSwitcher) exitWith {
	titleText ["", "BLACK IN", 0];
	titleText [format[localize "STR_WL_Loading_Teamswitched", localize format ["STR_WL_Gen_Team%1_2", _side]], "black"]; titleFadeOut 9999;
	[] spawn {sleep 20; endMission "LOSER";};
};

//Send player to debug to stop fake spawn locations.
player setPos [3755.94,7945.76,0.00160313];

titleText ["Loading...", "BLACK OUT", 0.00001];

private ["_handle"];
true spawn client_respawnDialog;

waitUntil {respawnDialogActive};

while {respawnDialogActive} do {
	titleText ["", "BLACK OUT", 0.00001];
};
sleep 0.1;
titleText ["", "BLACK IN", 0.00001];
playerSpawning = false;