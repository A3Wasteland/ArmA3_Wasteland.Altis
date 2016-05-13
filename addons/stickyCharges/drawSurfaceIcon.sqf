// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: drawSurfaceIcon.sqf
//	@file Author: AgentRev

#include "defines.sqf"

if (missionNamespace getVariable ["A3W_stickyCharges_showSurfaceIcon", false]) then
{
	// commanding menu open, or action menu activated more than 10 seconds ago, means the action menu is closed
	_exit = if (commandingMenu != "" || diag_tickTime - (missionNamespace getVariable ["A3W_stickyCharges_showSurfaceIcon_tickTime", 0]) > 10) then
	{
		false call A3W_fnc_stickyCharges_toggleSurfaceIcon
	}
	else { false };

	if (_exit) exitWith {};

	_staticIcon = player getVariable ["A3W_stickyCharges_isStaticIcon", false];
	_firstTarget = player getVariable ["A3W_stickyCharges_target", objNull];

	_intersect = [player, _staticIcon] call A3W_fnc_stickyCharges_actionIntersect;
	_surfacePos = _intersect select 0;
	_target = _intersect select 1;
	_normal = _intersect select 5;

	if (!(_surfacePos isEqualTo []) && (!_staticIcon || _target isEqualTo _firstTarget) && {_target call A3W_fnc_stickyCharges_targetAllowed})then
	{
		_size = 2 / ((AGLtoASL positionCameraToWorld [0,0,0]) vectorDistance _surfacePos);
		_iconPos = ASLtoAGL _surfacePos;

		drawIcon3D [A3W_stickyCharges_surfaceIcon, STICKY_CHARGE_ICON_COLOR, _iconPos, _size, _size, 180, "", 2];

		if (!isNil "_normal") then
		{
			drawLine3D [_iconPos, ASLtoAGL (_surfacePos vectorAdd (_normal vectorMultiply 0.1)), STICKY_CHARGE_ICON_COLOR];
		};
	};
};
