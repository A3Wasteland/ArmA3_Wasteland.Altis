//	@file Version: 1.0
//	@file Name: onPause.sqf
//	@file Author: AgentRev
//	@file Created: 22/12/2013 15:48

disableSerialization;

with missionNamespace do
{
	waitUntil { sleep 0.1; !isNull findDisplay 49 }; // 49 = Esc menu

	if (alive player &&
	   {!isNil "isConfigOn"} && 
	   {["A3W_playerSaving"] call isConfigOn} &&
	   {["playerSetupComplete", false] call getPublicVar} &&
	   {["respawnDialogActive", false] call getPublicVar == false}) then
	{
		[true] spawn fn_savePlayerData;
	};
};
