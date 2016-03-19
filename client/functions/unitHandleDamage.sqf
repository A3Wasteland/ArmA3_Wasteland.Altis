// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: unitHandleDamage.sqf
//	@file Author: AgentRev

#define IMPACT_DAMAGE_MULTIPLIER 0.5

_unit = _this select 0;

if (_unit getVariable ["playerSpawning", false]) exitWith {0};

_selection = toLower (_this select 1);
_damage = _this select 2;

if (_selection != "?") then
{
	_source = _this select 3;
	_ammo = _this select 4;

	// Reduce impact damage (from vehicle collisions and falling)
	if (_ammo == "" && (isNull _source || _source == player)) then
	{
		_oldDamage = if (_selection == "") then { damage _unit } else { _unit getHit _selection };

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

	//diag_log str [_unit, _selection, _damage, typeOf _source, _ammo];
};

_damage
