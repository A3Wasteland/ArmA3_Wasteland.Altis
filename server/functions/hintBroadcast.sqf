//	@file Version: 1.0
//	@file Name: hintBroadcast.sqf
//	@file Author: AgentRev
//	@file Created: 01/07/2013 15:52

messageSystem = _this select 0;
publicVariable "messageSystem";

if (!isDedicated) then
{
	waitUntil {!isNil "playerCompiledScripts" && {playerCompiledScripts}};
	[] spawn updateMissionsMarkers;
	[] spawn serverMessage;
};
