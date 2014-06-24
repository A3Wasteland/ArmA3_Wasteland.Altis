//	@file Name: unitHandleDamage.sqf
//	@file Author: AgentRev

#define IMPACT_DAMAGE_MULTIPLIER 0.5

_selection = _this select 1;
_damage = _this select 2;

if (_selection != "?") then
{
	_unit = _this select 0;
	_source = _this select 3;
	_ammo = _this select 4;

	// Reduce impact damage (from vehicle collisions and falling)
	if (_ammo == "") then
	{
		_oldDamage = if (_selection == "") then {
			damage _unit
		} else {
			_unit getHitPointDamage (_unit getVariable ["A3W_hitPoint_" + _selection, ""]) // returns nil if hitpoint doesn't exist
		};

		if (!isNil "_oldDamage") then
		{
			_damage = if ((vehicle _unit) isKindOf "ParachuteBase") then {
				_oldDamage // Disable collision damage while in parachute
			} else {
				((_damage - _oldDamage) * IMPACT_DAMAGE_MULTIPLIER) + _oldDamage
			};
		};
	};

	// Revive stuff
	call FAR_HandleDamage_EH;
};

_damage
