// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: targetAllowed.sqf
//	@file Author: AgentRev

#include "defines.sqf"

!isNull _this && {{_this isKindOf _x} count ["CAManBase","WeaponHolder","Bag_Base"] == 0}
