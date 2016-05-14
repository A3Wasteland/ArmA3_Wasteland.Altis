// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: keyDown.sqf
//	@file Author: AgentRev

#include "defines.sqf"

params ["", "_key"];

if (_key in actionKeys "CloseContext") then
{
	false call A3W_fnc_stickyCharges_toggleSurfaceIcon;
};

false
