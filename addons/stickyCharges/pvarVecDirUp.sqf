// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: pvarVecDirUp.sqf
//	@file Author: AgentRev

#include "defines.sqf"

(_this select 1) params [["_bomb",objNull,[objNull]], ["_vecDir",[],[[]]], ["_vecUp",[],[[]]]];

if (!mineActive _bomb) exitWith {};

_bomb setVectorDirAndUp [_vecDir,_vecUp];
_bomb setVectorUp _vecUp; // vectorUp must be set again for the bomb to be oriented correctly when attached
