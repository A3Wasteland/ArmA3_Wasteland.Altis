//	@file Version: 1
//	@file Name: BoS_hackBase.sqf
//	@file Author: LouD (based on objectLockStateMachine.sqf by [404] Costlyy)
//	@file Created: 22 march 2015
#define BoS_coolDownTimer (["BoS_coolDownTimer", 900] call getPublicVar)

if(mutexScriptInProgress) exitWith {
	player globalChat "The current operation isn't finished !";
};

private["_totalDuration", "_checks", "_success"];

mutexScriptInProgress = true;
_totalDuration = BoS_coolDownTimer;

_checks =
{
	private ["_progress", "_failed"];
	_progress = _this select 0;
	_failed = true;

	switch (true) do
	{
		case ((player distance cursorTarget) > 5): { _text = "Hacking cancelled!" };
		case (doCancelAction): { doCancelAction = false; _text = "Hacking cancelled!" };
		case (vehicle player != player): { _text = "Action failed! You can't do this in a vehicle" };
		default
		{
			_failed = false;
			_text = format ["Hacking %1%2 complete", floor (_progress * 100), "%"];
		};
	};
	
	[_failed, _text];
};

_success = [_totalDuration, "AinvPknlMstpSlayWrflDnon_medic", _checks, [cursorTarget]] call a3w_actions_start;

if (_success) then
{
	cursorTarget setVariable ["lockDown", false, true];
	cursorTarget setVariable ["password", "12345", true];
	["Base Re-Locker is hacked, the Lock Down is removed and the password is set to 12345.", 5] call mf_notify_client;
};

mutexScriptInProgress = false;


if (mutexScriptInProgress) then {
	mutexScriptInProgress = false;
	diag_log format["WASTELAND DEBUG: An error has occured in BoS_hackBase.sqf. Mutex lock was not reset. Mutex lock state actual: %1", mutexScriptInProgress];
};