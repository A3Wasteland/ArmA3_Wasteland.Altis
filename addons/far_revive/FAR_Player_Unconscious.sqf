// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_Player_Unconscious.sqf
//	@file Author: Farooq, AgentRev

#include "FAR_defines.sqf"
#include "gui_defines.hpp"

disableSerialization;

private ["_unit", "_killer", "_names"];
_unit = _this select 0;
//_killer = _this select 1;

_unit setCaptive true;

_unit spawn
{
	_unit = _this;

	while {UNCONSCIOUS(_unit)} do
	{
		if (vehicle _unit == _unit) then
		{
			_draggedBy = DRAGGED_BY(_unit);
			_anim = animationState _unit;

			if (isWeaponDeployed _unit || isWeaponRested _unit) then
			{
				_unit playMove "";
			};

			if ((getPos _unit select 2 < 0.5 && vectorMagnitude velocity _unit < 5) || {alive _draggedBy && !UNCONSCIOUS(_draggedBy)}) then
			{
				// Anim is stuck due to stance change in progress during injury
				if (_anim == "AinjPpneMstpSnonWrflDnon_rolltofront") then
				{
					_unit switchMove "";
					sleep 0.01;
					waitUntil {count animationState _unit <= 24}; // > 24 usually means the anim is still in transition
					[_unit, "AinjPpneMstpSnonWrflDnon"] call switchMoveGlobal;
					_anim = animationState _unit;
				};

				if !((toLower _anim) in ["ainjppnemstpsnonwrfldnon","unconscious"]) then
				{
					[_unit, "AinjPpneMstpSnonWrflDnon"] call switchMoveGlobal;
				};
			}
			else
			{
				if (_anim == "AinjPpneMstpSnonWrflDnon") then
				{
					[_unit, ""] call switchMoveGlobal;
				};
			};
		};

		sleep 0.2;
	};
};

if (_unit == player) then
{
	if (createDialog "ReviveBlankGUI") then
	{
		//(findDisplay ReviveBlankGUI_IDD) displayAddEventHandler ["KeyDown", "_this select 1 == 1"]; // blocks Esc to prevent closing
	};

	[100] call BIS_fnc_bloodEffect;
	FAR_cutTextLayer cutText ["", "BLACK OUT"];
};

// Suspect timeout
_unit spawn
{
	_unit = _this;
	sleep 1;

	if (UNCONSCIOUS(_unit) && isNil {_unit getVariable "FAR_killerSuspects"}) then
	{
		_unit setVariable ["FAR_killerSuspects", []];
	};
};

waitUntil {!isNil {_unit getVariable "FAR_killerSuspects"}};

_unit allowDamage true;
_unit setDamage 0.5;

if (!isPlayer _unit) then
{
	{ _unit disableAI _x } forEach ["MOVE","FSM","TARGET","AUTOTARGET"];
};

// Find killer
_killer = _unit call FAR_findKiller;
_unit setVariable ["FAR_killerPrimeSuspect", _killer];

// Injury message
if (FAR_EnableDeathMessages && difficultyEnabled "deathMessages" && !isNil "_killer") then
{
	[_unit, _killer] spawn
	{
		_unit = _this select 0;
		_killer = _this select 1;

		if (isPlayer _unit || FAR_Debugging) then
		{
			_names = [toArray name _unit];

			if (!isNull _killer && {(isPlayer _killer || FAR_Debugging) && (_killer != _unit) && (vehicle _killer != vehicle _unit)}) then
			{
				_names set [1, toArray name _killer];
			};

			FAR_deathMessage = [_names, netId _unit];
			publicVariable "FAR_deathMessage";
			["FAR_deathMessage", FAR_deathMessage] call FAR_public_EH;
		};
	};
};

if (!alive vehicle _unit) exitWith
{
	_unit setDamage 1;
	FAR_cutTextLayer cutText ["", "PLAIN"];
};

_unit spawn
{
	_unit = _this;
	_unlimitedStamina = ["A3W_unlimitedStamina"] call isConfigOn;

	sleep 1;

	while {UNCONSCIOUS(_unit)} do
	{
		if (_unit == player && cameraView != "INTERNAL") then
		{
			(vehicle player) switchCamera "INTERNAL";
		};

		if (!STABILIZED(_unit)) then
		{
			if (_unlimitedStamina) then
			{
				_unit setFatigue 0.4;
			}
			else
			{
				_unit setFatigue (0.4 max getFatigue _unit);
			};
		};

		uiSleep 0.25;
	};

	if (_unit == player && !alive player) then
	{
		(vehicle player) switchCamera "EXTERNAL";
	};
};

// Eject unit if inside immobile vehicle
_unit spawn
{
	private "_unconscious";
	_unit = _this;
	_veh = vehicle _unit;

	if (_veh != _unit) then
	{
		if (_veh isKindOf "Helicopter_Base_F" && isCopilotEnabled _veh) then
		{
			_pilot = driver _veh;
			_copilot = _veh turretUnit [0];

			if (_unit in [_pilot, _copilot]) then
			{
				if (!isNull _pilot && !isNull _copilot && _pilot != _copilot) then
				{
					// Give control to copilot if appropriate
					if (_pilot == _unit) then
					{
						_unit action ["UnlockVehicleControl", _veh];
						[[_copilot, netId _veh], "A3W_fnc_copilotTakeControl", _copilot] call A3W_fnc_MP;
					};

					// Give control back to pilot if appropriate
					if (_copilot == _unit) then
					{
						_unit action ["SuspendVehicleControl", _veh];
					};
				}
				else
				{
					_veh engineOn false;
				};
			};
		}
		else
		{
			if (driver _veh == _unit) then
			{
				_veh engineOn false;
			};
		};
	};

	waitUntil
	{
		sleep 0.1;
		_veh = vehicle _unit;
		_unconscious = UNCONSCIOUS(_unit);
		((isTouchingGround _veh || (getPos _veh) select 2 < 1) && {vectorMagnitude velocity _unit < 1}) || !_unconscious
	};

	if (_unconscious && _veh != _unit) then
	{
		unassignVehicle _unit;
		moveOut _unit;
	};
};

sleep 2;

if (isPlayer _unit) then
{
	if (_unit == player) then
	{
		FAR_cutTextLayer cutText ["", "BLACK IN"];
		closeDialog ReviveBlankGUI_IDD;

		if (createDialog "ReviveGUI") then
		{
			(findDisplay ReviveGUI_IDD) displayAddEventHandler ["KeyDown", "_this select 1 == 1"]; // blocks Esc to prevent closing
		};
	};

	// Mute ACRE
	_unit setVariable ["ace_sys_wounds_uncon", true];
};

_unit spawn
{
	_unit = _this;

	for "_i" from 1 to FAR_BleedOut step 3 do
	{
		if (!UNCONSCIOUS(_unit) || STABILIZED(_unit)) exitWith {};

		[((_i / FAR_BleedOut) * 20) + 80] spawn BIS_fnc_bloodEffect;
		sleep 3;
	};
};

_bleedStart = diag_tickTime;
_bleedOut = _bleedStart + FAR_BleedOut;

private ["_reviveGUI", "_progBar", "_progText", "_reviveText", "_bleedPause", "_treatedBy"];

if (_unit == player) then
{
	_reviveGUI = findDisplay ReviveGUI_IDD;
	_progBar = _reviveGUI displayCtrl RevProgBar_IDC;
	_progText = _reviveGUI displayCtrl RevBarText_IDC;
	_reviveText = _reviveGUI displayCtrl RevText_IDC;
};

while {UNCONSCIOUS(_unit) && diag_tickTime < _bleedOut} do
{
	if (!alive vehicle _unit || (getPosASL _unit) select 2 < -1.5) exitWith
	{
		_unit setDamage 1;
		FAR_cutTextLayer cutText ["", "PLAIN"];
	};

	_dmg = damage _unit;

	if (_unit getVariable ["FAR_handleStabilize", false]) then
	{
		_unit setDamage 0.25;
		_unit setVariable ["FAR_handleStabilize", nil, true];
		_unit setVariable ["FAR_treatedBy", nil, true];
		_treatedBy = nil;
	}
	else
	{
		_currentlyTreatedBy = _unit getVariable ["FAR_treatedBy", objNull];

		if (alive _currentlyTreatedBy) then
		{
			if (isNil "_treatedBy") then
			{
				_treatedBy = _currentlyTreatedBy;
				_bleedPause = diag_tickTime - _bleedStart;

				if (_unit == player) then
				{
					_progText ctrlSetText "Being treated...";
				};
			};

			_bleedStart = diag_tickTime - _bleedPause;
		}
		else
		{
			if (!isNil "_treatedBy") then
			{
				_treatedBy = nil;
				_bleedPause = nil;
				_unit setVariable ["FAR_treatedBy", nil, true];
			};
		};
	};

	if (ceil (_dmg * 100) < 50) then // assume healing by medic
	{
		if (!STABILIZED(_unit)) then
		{
			_unit setVariable ["FAR_isStabilized", 1, true];
			_unit setVariable ["FAR_iconBlink", nil, true];

			if (isPlayer _unit) then
			{
				//Unit has been stabilized. Disregard bleedout timer and umute player
				_unit setVariable ["ace_sys_wounds_uncon", false];
			};
		};

		if (_unit == player) then
		{
			_progBar progressSetPosition 1;

			if (isNil "_treatedBy") then
			{
				_progText ctrlSetText "Stabilized";
			};

			//(FAR_cutTextLayer + 1) cutText [format ["\n\nYou have been stabilized\n\n%1", call FAR_CheckFriendlies], "PLAIN DOWN", 0.01];
		};

		_bleedStart = diag_tickTime;
	};

	_bleedOut = _bleedStart + (FAR_BleedOut * ((1 - (_dmg max 0.5)) / 0.5));

	if (_unit == player) then
	{
		if (_dmg >= 0.5 && isNil "_treatedBy") then
		{
			_time = (_bleedOut - diag_tickTime) call fn_formatTimer;

			_progBar progressSetPosition ((_bleedOut - diag_tickTime) / FAR_BleedOut);
			_progText ctrlSetText _time;

			//(FAR_cutTextLayer + 1) cutText [format ["\n\nBleedout in %1\n\n%2", _time, call FAR_CheckFriendlies], "PLAIN DOWN"];
		};

		_reviveText ctrlSetStructuredText parseText (call FAR_CheckFriendlies);
	};

	_draggedBy = DRAGGED_BY(_unit);

	if (!isNull _draggedBy && {!alive _draggedBy || UNCONSCIOUS(_draggedBy)}) then
	{
		if (attachedTo _unit == _draggedBy) then
		{
			detach _unit;
			sleep 0.01;
		};

		if (!isPlayer attachedTo _unit) then
		{
			_unit setVariable ["FAR_draggedBy", nil, true];
		};
	};

	sleep 0.1;
};

if (alive _unit && !UNCONSCIOUS(_unit)) then // Player got revived
{
	_unit setDamage 0;
	_unit setVariable ["FAR_killerPrimeSuspect", nil];
	_unit setVariable ["FAR_killerVehicle", nil];
	_unit setVariable ["FAR_killerAmmo", nil];
	_unit setVariable ["FAR_killerSuspects", nil];
	_unit setVariable ["FAR_isStabilized", 0, true];
	_unit setVariable ["FAR_iconBlink", nil, true];
	_unit setCaptive false;

	if (isPlayer _unit) then
	{
		if (["A3W_playerSaving"] call isConfigOn) then
		{
			[] spawn fn_savePlayerData;
		};

		// Unmute ACRE
		_unit setVariable ["ace_sys_wounds_uncon", false];

		if (["A3W_unlimitedStamina"] call isConfigOn) then
		{
			_unit enableFatigue false;
		};
	}
	else
	{
		{ _unit enableAI _x } forEach ["MOVE","FSM","TARGET","AUTOTARGET"];
	};

	_unit playMove format ["AmovPpneMstpSrasW%1Dnon", _unit call getMoveWeapon];
}
else // Player bled out
{
	_unit setDamage 1;

	if (!isPlayer _unit) then
	{
		_unit setVariable ["FAR_isUnconscious", 0, true];
		_unit setVariable ["FAR_draggedBy", nil, true];
		_unit setVariable ["FAR_treatedBy", nil, true];
	};
};

if (_unit == player) then
{
	closeDialog ReviveGUI_IDD;
};
