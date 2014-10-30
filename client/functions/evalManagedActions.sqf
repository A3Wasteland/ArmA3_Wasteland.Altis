// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: evalManagedActions.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {};

scriptName "evalManagedActions";
waitUntil {!isNull player};

managedActions_array = [];
managedActions_arrayCleanup = false;
managedActions_arrayEval = false;

while {true} do
{
	// Only evaluate conditions if map and pause menu are not open
	_doEval = !visibleMap && isNull findDisplay 49 && alive player;

	_cleanup = false;
	_evalSleepTime = 0.25;
	_actionsCount = count managedActions_array;

	if (_actionsCount > 0) then
	{
		managedActions_arrayEval = true;

		_evalSleepTime = (_evalSleepTime / _actionsCount) max 0.01;

		{
			if !(_x isEqualTo -1) then
			{
				_target = _x select 0;

				if (isNull _target) then
				{
					_cleanup = true;
				}
				else
				{
					if (_doEval) then
					{
						_pvar = _x select 2;
						_cond = _x select 3;

						if (!isNil _pvar) then
						{
							missionNamespace setVariable [_pvar, player call _cond];
						};
					};
				};
			};

			uiSleep _evalSleepTime;
		} forEach managedActions_array;

		managedActions_arrayEval = false;
	}
	else
	{
		uiSleep _evalSleepTime;
	};

	if (_cleanup) then
	{
		[] spawn
		{
			managedActions_arrayCleanup = true;

			_cleanPvars = [];
			_oldArray = managedActions_array;

			{
				if (!(_x isEqualTo -1) && {isNull (_x select 0)}) then
				{
					_cleanPvars pushBack (_x select 2);
					_oldArray set [_forEachIndex, -1];
				};
			} forEach _oldArray;

			managedActions_array = _oldArray - [-1];
			managedActions_arrayCleanup = false;

			waitUntil {!managedActions_arrayEval};

			{ missionNamespace setVariable [_x, nil] } forEach _cleanPvars;
		};
	};

	uiSleep 0.25;
};
