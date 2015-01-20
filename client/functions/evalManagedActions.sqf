// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: evalManagedActions.sqf
//	@file Author: AgentRev

if (!hasInterface) exitWith {};

#define MAIN_LOOP_INTERVAL 0.333
#define START_LOOP_QTY_PER_FRAME 2
#define MAX_LOOP_QTY_PER_FRAME 10

scriptName "evalManagedActions";
waitUntil {!isNull player};

managedActions_array = [];
managedActions_arrayCleanup = false;
managedActions_arrayEval = false;
managedActions_doCleanup = false;

_loopQty = START_LOOP_QTY_PER_FRAME;
_oldCount = 0;
_totalTime = 0;

while {true} do
{
	_startTime = diag_tickTime;

	// Only evaluate conditions if no menus or dialogs are open
	managedActions_doEval = (!visibleMap && isNull findDisplay 49 && !dialog && alive player);
	managedActions_doCleanup = false;

	_actionsCount = count managedActions_array;

	if (_actionsCount > 0) then
	{
		managedActions_arrayEval = true;

		_loopQty = 
		[{
			if !(_this isEqualTo -1) then
			{
				_target = _this select 0;

				if (isNull _target) then
				{
					managedActions_doCleanup = true;
				}
				else
				{
					if (managedActions_doEval) then
					{
						_pvar = _this select 2;
						_cond = _this select 3;

						if (!isNil _pvar) then
						{
							missionNamespace setVariable [_pvar, player call _cond];
						};
					};
				};
			};
		}, managedActions_array, MAIN_LOOP_INTERVAL, _oldCount, _totalTime, _loopQty, false, MAX_LOOP_QTY_PER_FRAME] call fn_loopSpread;

		managedActions_arrayEval = false;
	};

	_oldCount = _actionsCount;

	if (managedActions_doCleanup) then
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

	_totalTime = diag_tickTime - _startTime;
	uiSleep (MAIN_LOOP_INTERVAL - _totalTime);
};
