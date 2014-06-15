//	@file Version: 1.0
//	@file Name: broadcaster.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer) exitWith {};

while {true} do
{
	//To broadcast clientRaderMarkers to clients from the server due to clients not being able to broadcast server wide variables with eventhandlers.
	//publicVariable "currentInvites";
	//publicVariable "clientRadarMarkers";
	serverFPS = diag_fpsmin;
	publicVariable "serverFPS";
	sleep 1;
};
