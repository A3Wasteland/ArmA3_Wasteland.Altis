// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_addManagedAction.sqf
//	@file Author: AgentRev

// A managed action is simply an action from which the condition evaluation is deferred to evalManagedActions,
// and the actual condition feeded to addAction is a public variable that contains the result caculated by evalManagedActions.

// This is so that conditions are only evaluated twice per second instead of every frame, in order to boost FPS.

if (!hasInterface) exitWith {-1};

private ["_obj", "_params", "_condition", "_conditionPvar", "_id"];
_obj = _this select 0;
_params = _this select 1;

if (isNull _obj) exitWith {-1};

if (count _params > 7) then
{
	_params = +_params;
	_condition = _params select 7;

	if (!isNil "_condition") then
	{
		while {isNil "_conditionPvar" || {!isNil {missionNamespace getVariable _conditionPvar}}} do
		{
			_conditionPvar = "managedAction_pvar_" + call A3W_fnc_generateKey;
		};

		missionNamespace setVariable [_conditionPvar, false];
		_params set [7, _conditionPvar];
	};
};

_id = _obj addAction _params;

if (_id != -1 && !isNil "_condition") then
{
	_condition = switch (toUpper typeName _condition) do
	{
		case "CODE":   { _condition };
		case "STRING": { compile _condition };
		default        { compile str _condition };
	};

	waitUntil {!isNil "managedActions_arrayCleanup" && {!managedActions_arrayCleanup}};
	managedActions_array pushBack [_obj, _id, _conditionPvar, _condition];
};

_id
