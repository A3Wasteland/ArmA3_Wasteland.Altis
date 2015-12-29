//	@file Version: 1
//	@file Name: BoS_repairLocker.sqf
//	@file Author: LouD (based on objectLockStateMachine.sqf by [404] Costlyy)
//	@file Created: 28 march 2015

if(mutexScriptInProgress) exitWith {
	player globalChat "The current operation isn't finished !";
};

private["_totalDuration", "_checks", "_success"];

mutexScriptInProgress = true;
_totalDuration = 60;

_checks =
{
	private ["_progress", "_failed"];
	_progress = _this select 0;
	_failed = true;


	switch (true) do
	{
		case ((player distance cursorTarget) > 5): { _text = "Repair cancelled!" };
		case (doCancelAction): { doCancelAction = false; _text = "Repair cancelled!" };
		case (vehicle player != player): { _text = "Action failed! You can't do this in a vehicle" };
		default
		{
			_failed = false;
			_text = format ["Repair %1%2 complete", floor (_progress * 100), "%"];
		};
	};
	
	[_failed, _text];
};

_success = [_totalDuration, "AinvPknlMstpSlayWrflDnon_medic", _checks, [cursorTarget]] call a3w_actions_start;

if (_success) then
{
	private["_reLockers", "_repair"];
	_reLockers = nearestObjects [player, ["Land_Device_assembled_F"], 5];
	_repair = _reLockers select 0;
	_repair setDamage 0;
	["Base Re-Locker is Repaired.", 5] call mf_notify_client;
};

mutexScriptInProgress = false;


if (mutexScriptInProgress) then {
	mutexScriptInProgress = false;
	diag_log format["WASTELAND DEBUG: An error has occured in BoS_repairLocker.sqf. Mutex lock was not reset. Mutex lock state actual: %1", mutexScriptInProgress];
};