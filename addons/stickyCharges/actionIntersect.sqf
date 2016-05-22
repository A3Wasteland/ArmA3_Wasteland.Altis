// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: actionIntersect.sqf
//	@file Author: AgentRev

#include "defines.sqf"

params ["_unit", ["_indirect",false,[false]]];

private _surfacePos = [];
private _target = objNull;
private ["_eyePos", "_eyeDir"];

if (_indirect) then
{
	_eyePos = _unit getVariable "A3W_stickyCharges_eyePos";
	_eyeDir = _unit getVariable "A3W_stickyCharges_eyeDir";
};

if (isNil "_eyePos") then { _eyePos = eyePos _unit };
if (isNil "_eyeDir") then { _eyeDir = getCameraViewDirection _unit };

private _lookPos = _eyePos vectorAdd (_eyeDir vectorMultiply STICKY_CHARGE_MAX_DIST);
private _points = LINE_INTERSECT_BOMB(_eyePos,_lookPos,objNull);
private _normal = [];

if !(_points isEqualTo []) then
{
	private _point = _points select 0;
	_surfacePos = _point select 0;
	_normal = _point select 1;
	_target = _point select 2;

	if (_target isKindOf "TimeBombCore") then
	{
		private _targetTmp = attachedTo _target;
		if (!isNull _targetTmp) then { _target = _targetTmp };
	};
};

[_surfacePos, _target, _eyePos, _eyeDir, _lookPos, _normal]
