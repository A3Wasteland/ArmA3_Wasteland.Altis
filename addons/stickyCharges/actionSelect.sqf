// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: actionSelect.sqf
//	@file Author: AgentRev

#include "defines.sqf"

params ["", "_unit", "", "_action", "_text"];

if (_unit isEqualTo player && !(_unit getVariable ["A3W_stickyCharges_isPlacing", false])) then
{
	(_action == "UseMagazine" && {_text call A3W_fnc_stickyCharges_magNameAllowed}) call A3W_fnc_stickyCharges_toggleSurfaceIcon;
};

false
