// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: toggleSurfaceIcon.sqf
//	@file Author: AgentRev

#include "defines.sqf"

private _success = (_this || !(player getVariable ["A3W_stickyCharges_isStaticIcon", false]));

if (_success) then
{
	missionNamespace setVariable ["A3W_stickyCharges_showSurfaceIcon", _this];

	if (_this) then
	{
		missionNamespace setVariable ["A3W_stickyCharges_showSurfaceIcon_tickTime", diag_tickTime];
		player setVariable ["A3W_stickyCharges_isStaticIcon", false];
	};
};

_success
