//	@file Version: 1.0
//	@file Name: serverTimeSync.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19

if (!isServer) exitWith {};

while {true} do
{
	currentDate = date;
	publicVariable "currentDate";
	sleep 30;
};
