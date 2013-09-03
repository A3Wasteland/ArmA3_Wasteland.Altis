//	@file Version: 1.0
//	@file Name: broadcaster.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

if(!X_Server) exitWith {};

#include "setup.sqf"
#ifdef __A2NET__
call arma2NetTime;
waituntil{netTime > 0};
missionStartTime = netTime;
#endif

while {true} do {
	#ifdef __A2NET__
	//update the arma2Net time (needs to be done about every second)
	call arma2NetTime;
	#endif
	
    //To broadcast clientRaderMarkers to clients from the server due to clients not being able to broadcast server wide variables with eventhandlers.	
	publicVariable "currentInvites";
    publicVariable "clientRadarMarkers";
	serverFPS = str(diag_fpsmin);
	publicVariable "serverFPS";
    sleep 1; 
};
