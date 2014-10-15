//	@file Name: initPlayerServer.sqf
//	@file Author: AgentRev

if (!isNil "updateConnectingClients") then
{
	_this spawn updateConnectingClients;
};
