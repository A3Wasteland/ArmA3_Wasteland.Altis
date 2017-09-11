// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: unitHandleDamage.sqf
//	@file Author: AgentRev

#define IMPACT_DAMAGE_MULTIPLIER 0.5
#define IMPACT_DAMAGE_SEATED_MULTIPLIER 0.1

params ["_unit", "_selection", "_damage", "_source", "_ammo"];

if (_unit getVariable ["playerSpawning", false]) exitWith {0};

if (_selection != "?") then
{
	// Vehicle collisions and falling damage
	if (_ammo == "" && (vehicle _source) in [vehicle _unit, objNull]) then
	{
		_oldDamage = [_unit getHit _selection, damage _unit] select (_selection isEqualTo "");

		_damage = switch (true) do
		{
			case (isNil "_oldDamage"):                         { _damage };
			case ((vehicle _unit) isKindOf "ParachuteBase"):   { _oldDamage }; // Disable self-collision damage while in parachute
			case (!isNull objectParent _unit):                 { ((_damage - _oldDamage) * IMPACT_DAMAGE_SEATED_MULTIPLIER) + _oldDamage }; // Greatly reduce in-vehicle unit self-impact damage
			default                                            { ((_damage - _oldDamage) * IMPACT_DAMAGE_MULTIPLIER) + _oldDamage }; // Reduce on-foot self-impact and falling damage
		};
	};

	// Revive stuff
	call FAR_HandleDamage_EH;

	//diag_log str [_unit, _selection, _damage, typeOf _source, _ammo];
};

_damage
