//	@file Name: initPlayerServer.sqf
//	@file Author: AgentRev

_this spawn
{
	waitUntil {sleep 0.1; !isNil "A3W_serverSetupComplete"};
	(_this select 0) call handleCorpseOnLeave;
	_this call updateConnectingClients;
};