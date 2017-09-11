// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************

// credits to Killzone Kid
onEachFrame
{
	private _missionDisplays = allDisplays select [allDisplays find findDisplay 46, count allDisplays];
	reverse _missionDisplays;
	{ _x closeDisplay 0 } forEach _missionDisplays;

	onEachFrame {

	findDisplay 50 closeDisplay 0; // RscDisplayDebriefing
	findDisplay 70 closeDisplay 0; // RscDisplayMultiplayerSetup
	findDisplay 18 closeDisplay 0; // RscDisplayClient

	onEachFrame {

	[localize "str_mp_kicked_client", "", true, false, findDisplay 8] spawn BIS_fnc_guiMessage; // RscDisplayMultiplayer

	onEachFrame {};
}}};

// just in case
0 spawn
{
	sleep 0.5;
	preprocessFile "client\functions\quit.hpp"; // soft CTD via missing include
	endMission "LOSER";
};
