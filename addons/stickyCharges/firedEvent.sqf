// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: firedEvent.sqf
//	@file Author: AgentRev

#include "defines.sqf"

if (_this select 1 == "Put") then
{
	params ["_unit", "","","", "_ammo", "_mag", "_bomb"];

	if ({_mag == _x} count STICKY_CHARGE_ALLOWED_TYPES == 0) exitWith {};

	_unit setVariable ["A3W_stickyCharges_isPlacing", false];

	if (_unit getVariable ["A3W_stickyCharges_isStaticIcon", false]) then
	{
		_unit setVariable ["A3W_stickyCharges_isStaticIcon", false];

		if (_unit isEqualTo player) then
		{
			false call A3W_fnc_stickyCharges_toggleSurfaceIcon;
		};
	};

	if (!mineActive _bomb) exitWith {};

	_firstTarget = _unit getVariable ["A3W_stickyCharges_target", objNull];
	_eyePos = _unit getVariable ["A3W_stickyCharges_eyePos", []];
	_lookPos = _unit getVariable ["A3W_stickyCharges_lookPos", []];

	if (isNull _firstTarget || _eyePos isEqualTo [] || _lookPos isEqualTo []) exitWith {};

	_points = LINE_INTERSECT_BOMB(_eyePos,_lookPos,_bomb);

	if (_points isEqualTo []) exitWith {};

	(_points select 0) params ["_posASL", "_normal", "_target", "_parent"];

	if (_target isKindOf "TimeBombCore") then
	{
		private _targetTmp = attachedTo _target;
		if (!isNull _targetTmp) then { _target = _targetTmp };
	};

	if (_target != _firstTarget || !(_target call A3W_fnc_stickyCharges_targetAllowed)) exitWith {};

	_targetCfg = configFile >> "CfgVehicles" >> typeOf _target;
	_vecUp = _normal;

	// Only attach to vehicles or indestructible structures, otherwise just setPosWorld to surface
	if (!isClass _targetCfg || !simulationEnabled _target || _target isKindOf "TimeBombCore" || 
	    (!(_target isKindOf "AllVehicles") && _target getVariable ["allowDamage", true] &&
		 {(toLower getText (_targetCfg >> "destrType")) in ["destructbuilding","destructtent","destructtree","destructwall"] ||
		  !(("getText (_x >> 'simulation') == 'ruin'" configClasses (_targetCfg >> "DestructionEffects")) isEqualTo [])})) then
	{
		_bomb setPosWorld _posASL;
		//systemChat format ["%1 placed on [%2]", _ammo, _target];
	}
	else
	{

		_bomb attachTo [_target, _target worldToModelVisual ASLtoAGL _posASL];
		_vecUp = _target worldToModelVisual ASLtoAGL ((AGLtoASL (_target modelToWorldVisual [0,0,0])) vectorAdd _normal);
		//systemChat format ["%1 attached to [%2]", _ammo, _target];
	};

	_vecDir = [0,0,1];

	if (_vecUp select [0,2] isEqualTo [0,0]) then
	{
		_vecDir = (vectorNormalized (_lookPos vectorDiff _eyePos)) vectorMultiply (_vecUp select 2);
	};

	_bomb setVectorDirAndUp [_vecDir, _vecUp];
	_bomb setVectorUp _vecUp; // vectorUp must be set again for the bomb to be oriented correctly when attached
};
