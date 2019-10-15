// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: firedEvent.sqf
//	@file Author: AgentRev

#include "defines.sqf"

if (_this select 1 == "Put") then
{
	params ["_unit", "","","", "_ammo", "_mag", "_bomb"];

	_disallowedType = ({_mag == _x} count STICKY_CHARGE_ALLOWED_TYPES == 0);

	if (isNil "A3W_serverSetupComplete" && _disallowedType) exitWith {}; // confirm mag validation here if not A3Wasteland

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

	// usage of dummy object is needed to guaranted pos & dir syncing and use setVariable, thanks to BIS for not fixing this in 10 damn years!!!!
	_dummy = createVehicle [STICKY_CHARGE_DUMMY_OBJ, [-1e5,-1e5,1e5], [], 0, "NONE"];
	_dummy setVariable ["A3W_stickyCharges_isDummy", true, true];
	_dummy setObjectTextureGlobal [0,""];
	_dummy allowDamage false;
	_dummy attachTo [_bomb, [0,0,0]];

	_dummy setVariable ["A3W_stickyCharges_linkedBomb", _bomb, true];
	_dummy setVariable ["A3W_stickyCharges_ownerUnit", _unit];
	_dummy setVariable ["A3W_stickyCharges_side", side group _unit, true];

	if (isPlayer _unit) then
	{
		_dummy setVariable ["A3W_stickyCharges_ownerUID", getPlayerUID _unit, true];
	};

	if (!isNil "A3W_serverSetupComplete" && _disallowedType) exitWith {}; // confirm mag validation here if A3Wasteland

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
	_rootObj = _bomb;

	_allowDamage = _target getVariable ["allowDamage", true]; // "allowedDamage" command doesn't exist yet...
	if !(_allowDamage isEqualType true) then { _allowDamage = true };

	// Only attach to vehicles or indestructible structures, otherwise just setPosWorld to surface
	if (getObjectType _target isEqualTo 8 && simulationEnabled _target && !(_target isKindOf "TimeBombCore") &&
	    {_target isKindOf "AllVehicles" || !_allowDamage ||
	     {!((toLower getText (_targetCfg >> "destrType")) in ["destructbuilding","destructtent","destructtree","destructwall"]) &&
	      configProperties [_targetCfg >> "DestructionEffects", "isClass _x && {getText (_x >> 'simulation') == 'ruin'}"] isEqualTo []}}) then
	{
		_bomb attachTo [_target, _target worldToModelVisual ASLtoAGL _posASL];
		_vecUp = _target worldToModelVisual ASLtoAGL ((AGLtoASL (_target modelToWorldVisual [0,0,0])) vectorAdd _normal);
		//systemChat format ["%1 attached to [%2]", _ammo, _target];
	}
	else
	{
		detach _dummy;
		_bomb attachTo [_dummy, [0,0,0]];
		_dummy setPosWorld _posASL;
		_rootObj = _dummy;
		//systemChat format ["%1 placed on [%2]", _ammo, _target];
	};

	_vecDir = [0,0,1];

	if (abs (_vecUp select 0) < 0.01 && abs (_vecUp select 1) < 0.01) then
	{
		_vecDir = (_lookPos vectorDiff _eyePos) vectorMultiply (_vecUp select 2);
	};

	_rootObj setVectorDirAndUp [_vecDir,_vecUp];
	_rootObj setVectorUp _vecUp; // vectorUp must be set again for the bomb to be oriented correctly when attached

	if (_rootObj == _bomb) then
	{
		_dummy setVariable ["A3W_stickyCharges_vecDirUp", [_vecDir,_vecUp], true];

		pvar_A3W_stickyCharges_vecDirUp = [_bomb, _vecDir, _vecUp];
		publicVariable "pvar_A3W_stickyCharges_vecDirUp";
	};
};
