// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_HandleDamage_EH.sqf
//	@file Author: Farooq, AgentRev

#include "FAR_defines.sqf"
#include "gui_defines.hpp"

_skipRevive = FAR_DisableRevive; // set to true if you want to completely disable revive

//private ["_unit", "_selection", "_damage", "_source", "_fatalHit", "_killerVehicle", "_oldDamage"];

params ["_unit", "", "", "_source", "_ammo", "", "_instigator"];

// a critical hit is if this type of selection can trigger death upon suffering damage >= 1 (usually all of them except "hands", "arms", "legs", "?")
// this is intercepted to prevent engine-triggered death and put the unit in revive mode instead; behavior and selections can change with game updates
_criticalHit = _selection in ["","body","head","spine1","spine2","spine3","pelvis","neck","face_hub"];
_fatalHit = {_damage >= 1 && alive _unit && _criticalHit}; // do not remove curly braces

_killerUnit = _unit getVariable "FAR_killerUnit";
_killerEmptyUID = _unit getVariable ["FAR_killerUID",""] isEqualTo "";

_setKillerInfo =
{
	params ["_unconsciousDmg"];

	// the _unconsciousDmg condition allows player X to be credited for killing Y if Y was initially injured by something other than player Z
	if ((!isNull _source || !isNull _instigator) && _fatalHit && (isNil "_killerUnit" || {_unconsciousDmg && !isNull _killerUnit && (_killerUnit in [_unit,_source,_instigator] || _killerEmptyUID)})) then
	{
		[_unit, _source, _ammo, _instigator] call FAR_setKillerInfo;

		// show "X killed Y" on final death instead of "Y bled out" if _skipRevive or if Y was initially injured by something other than player Z
		if (_skipRevive || _unconsciousDmg) then { _unit setVariable ["A3W_deathCause_local", ["kill"]] };
	};
};

false call _setKillerInfo;

//diag_log format ["FAR_HandleDamage_EH %1 - alive: %2", [_unit, _selection, _damage, _source, _ammo], alive _unit];

_reviveReady = _unit getVariable ["FAR_reviveModeReady", false];

if (UNCONSCIOUS(_unit) && !_skipRevive) then
{
	if (!_reviveReady) exitWith { _damage = 0.5 }; // block additional damage while transitioning to revive mode; allowDamage false prevents proper tracking of lethal headshots

	//if (_selection != "?") then
	//{
		_oldDamage = if (_selection == "") then { damage _unit } else { _unit getHit _selection };

		if (!isNil "_oldDamage") then
		{
			// Apply part of the damage without multiplier when below the stabilization threshold of 50% damage
			if (_criticalHit && {STABILIZED(_unit) && (FAR_DamageMultiplier min 0.1) < 1}) then
			{
				_oldDamage = _damage min 0.5;
			};

			_damage = ((_damage - _oldDamage) * (FAR_DamageMultiplier min 0.1)) min 0.2 + _oldDamage; // max damage inflicted per hit is capped (via min 0.2) to prevent insta-bleedout - 0.2 is 40% of 0.5
		};
	//};

	true call _setKillerInfo;
}
else
{
	// Allow revive if unit is dead and not in exploded vehicle
	if (alive vehicle _unit && _fatalHit) then
	{
		if (_unit == player && !isNil "fn_deletePlayerData") then { call fn_deletePlayerData };

		if (!_skipRevive) then
		{
			_unit setVariable ["FAR_isUnconscious", 1, true];
			//_unit allowDamage false;
			_unit setFatigue 1;
		};

		terminate (_unit getVariable ["FAR_Player_Unconscious_thread", scriptNull]);

		if (_unit == player) then
		{
			(findDisplay ReviveBlankGUI_IDD) closeDisplay 0;
			//(findDisplay ReviveGUI_IDD) closeDisplay 0;
			(uiNamespace getVariable ["ReviveGUI", displayNull]) closeDisplay 0;
		};

		if (_skipRevive) exitWith {};

		_unit setVariable ["FAR_Player_Unconscious_thread", [_unit, _source] spawn FAR_Player_Unconscious];

		if (_unit == player) then
		{
			true call mf_inventory_list;
		};

		_damage = 0.5;
	};
};

/*if (UNCONSCIOUS(_unit) && !_reviveReady) then
{
	_headshotQueue = _unit getVariable "FAR_headshotHitPartEH_queued";

	if (!isNil "_headshotQueue") then
	{
		_headshotQueue params [["_time",0], ["_hitPart",[]]];

		if (time - _time < 0.25) then
		{
			_hitPart call FAR_headshotHitPartEH;
		};

		_unit setVariable ["FAR_headshotHitPartEH_queued", nil];
	};
};*/

//_damage
