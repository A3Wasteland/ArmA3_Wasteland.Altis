//	@file Version: 1.0
//	@file Name: broadcaster.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer) exitWith {};

while {true} do
{
	serverFPS = diag_fps;
	publicVariable "serverFPS";
	sleep 1;
};
