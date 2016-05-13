// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: mouseButtonDown.sqf
//	@file Author: AgentRev

#include "defines.sqf"

params ["_disp", "_btn"];

_btn = _btn + 65536 + ([0,128] select (_btn isEqualTo 1)); // actionKeys mouse bitflag + RMB fix
([_disp,_btn] + (_this select [4,999])) call A3W_fnc_stickyCharges_keyDown
