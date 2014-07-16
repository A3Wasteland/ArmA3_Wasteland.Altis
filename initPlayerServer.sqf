//	@file Name: initPlayerServer.sqf
//	@file Author: AgentRev

_this spawn
{
	waitUntil {!isNil "handleCorpseOnLeave"};
	(_this select 0) call handleCorpseOnLeave;
};

_this spawn
{
	waitUntil {!isNil "updateConnectingClients"};
	_this call updateConnectingClients;
};
