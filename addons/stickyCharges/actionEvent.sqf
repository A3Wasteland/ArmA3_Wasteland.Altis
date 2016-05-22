// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: actionEvent.sqf
//	@file Author: AgentRev

#include "defines.sqf"

params ["", "_unit", "", "_action", "_text", "","","","", "_perform"];
private _handled = false;

if (_action == "UseMagazine" && {_text call A3W_fnc_stickyCharges_magNameAllowed}) then
{
	if (_perform) then
	{
		if !(_unit getVariable ["A3W_stickyCharges_isPlacing", false]) then
		{
			_unit setVariable ["A3W_stickyCharges_isPlacing", true];

			(_unit call A3W_fnc_stickyCharges_actionIntersect) params ["", "_target", "_eyePos", "_eyeDir", "_lookPos"];

			_unit setVariable ["A3W_stickyCharges_target", _target];
			_unit setVariable ["A3W_stickyCharges_eyePos", _eyePos];
			_unit setVariable ["A3W_stickyCharges_eyeDir", _eyeDir];
			_unit setVariable ["A3W_stickyCharges_lookPos", _lookPos];
			_unit setVariable ["A3W_stickyCharges_isStaticIcon", true];
		}
		else
		{
			_handled = true; // prevent charge placement while another one is currently being placed
		};
	}
	else
	{
		true call A3W_fnc_stickyCharges_toggleSurfaceIcon;
	};
};

_handled
