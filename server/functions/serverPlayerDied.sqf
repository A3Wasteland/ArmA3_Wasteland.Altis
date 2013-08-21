//	@file Version: 1.0
//	@file Name: serverPlayerDied.sqf
//	@file Author: [404] Pulse
//	@file Created: 20/11/2012 05:19
#include "setup.sqf"
if(!X_Server) exitWith {};

private["_newObject"];
_newObject = _this select 0;
#ifdef __A2NET__
_newObject setVariable["processedDeath",netTime];
#else
_newObject setVariable["processedDeath",time];
#endif
