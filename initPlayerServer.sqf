// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: initPlayerServer.sqf
//	@file Author: AgentRev

if (!isNil "updateConnectingClients") then
{
	_this spawn updateConnectingClients;
};
