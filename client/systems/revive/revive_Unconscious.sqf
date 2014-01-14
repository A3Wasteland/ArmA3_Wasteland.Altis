/*
	File: revive_Unconscious.sqf
	Orignal Author: Farooq
	Modified by Torndeco

	Description:
	Code is taken / based of FAAR Revive.

	TODO:
	Add Optional Settings
	Add + test higher cutoff for Damage values, so lethal non-head shots will kill players straight away.
*/

private["_unit", "_killer", "_bleedOut", "_display", "_reviveText"];

#define revive_dialog_text 3601

_unit = _this select 0;
_killer = _this select 1;

disableSerialization;
disableUserInput true;
titleText ["", "BLACK FADED"];

if (vehicle _unit != _unit) then
{
	unAssignVehicle _unit;
	_unit action ["eject", vehicle _unit];
	sleep 2;
};

_unit allowDamage false;
_unit playMove "AinjPpneMstpSnonWrflDnon_rolltoback";
sleep 3;

titleText ["", "BLACK IN", 1];
disableUserInput false;

_unit switchMove "AinjPpneMstpSnonWrflDnon";
_unit enableSimulation false;
_unit setVariable ["revive_isUnconscious", true, true];

_bleedOut = time + 300;

createDialog "ReviveDialog";

while {((!isNull _unit) && (alive _unit))} do {
	if (time > _bleedOut) exitWith {
		_unit setDamage 1;
	};

	// Incase Player Closes Revive Dialog via Escape Key
	_display = uiNamespace getVariable "revivedialog";
	_reviveText = _display displayCtrl revive_dialog_text;

	if (!(_unit getVariable ["revive_isUnconscious", false])) exitWith {
		_reviveText ctrlSetText "You have been Revived";
		sleep 3;

		_unit enableSimulation true;
		_unit allowDamage true;
		_unit setDamage 0.4;
		_unit playMove "amovppnemstpsraswrfldnon";
		_unit playMove "";
	};
	_reviveText ctrlSetText format["Your are unconcious & bleeding out. \n U will be dead in %1 seconds", round (_bleedOut - time)];
	sleep 1;
};