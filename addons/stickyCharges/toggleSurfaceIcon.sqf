// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: toggleSurfaceIcon.sqf
//	@file Author: AgentRev

#include "defines.sqf"

private _success = (_this || !(player getVariable ["A3W_stickyCharges_isStaticIcon", false]));

if (_success) then
{
	with missionNamespace do
	{
		if (!isNil "A3W_stickyCharges_drawSurfaceIcon_ID") then { removeMissionEventHandler ["Draw3D", A3W_stickyCharges_drawSurfaceIcon_ID] };

		if (_this) then
		{
			player setVariable ["A3W_stickyCharges_isStaticIcon", false];
			A3W_stickyCharges_showSurfaceIcon_tickTime = diag_tickTime;
			A3W_stickyCharges_drawSurfaceIcon_ID = addMissionEventHandler ["Draw3D", A3W_fnc_stickyCharges_drawSurfaceIcon];
		}
		else
		{
			A3W_stickyCharges_drawSurfaceIcon_ID = nil;
		};

		A3W_stickyCharges_showSurfaceIcon = _this;
	};
};

_success
