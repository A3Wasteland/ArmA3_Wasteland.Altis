// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: initPlayerLocal.sqf
//	@file Author: AgentRev

#include "addons\logo\logo.sqf"

if (!isServer) then
{
	"BIS_fnc_MP_packet" addPublicVariableEventHandler compileFinal preprocessFileLineNumbers "server\antihack\filterExecAttempt.sqf";
};
