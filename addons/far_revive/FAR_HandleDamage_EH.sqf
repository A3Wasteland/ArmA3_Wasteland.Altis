//	@file Name: FAR_HandleDamage_EH.sqf
//	@file Author: Farooq, AgentRev

#include "FAR_defines.sqf"

//private ["_unit", "_selection", "_damage", "_source", "_dead", "_killerVehicle", "_oldDamage"];

//_unit = _this select 0;
//_selection = _this select 1;
//_damage = _this select 2;
//_source = _this select 3;
//_ammo = _this select 4;

_criticalHit = (_selection in ["","body","head"]);
_dead = (_damage >= 1 && alive _unit && _criticalHit);

// Find suspects
if (((_dead && !isNull _source) || (_criticalHit && UNCONSCIOUS(_unit))) && isNil {_unit getVariable "FAR_killerVehicle"}) then
{
	_unit setVariable ["FAR_killerVehicle", _source];

	_suspects = [];

	if !(_source isKindOf "CAManBase") then
	{
		{
			_suspect = _x;
			_role = assignedVehicleRole _suspect;
			
			if (count _role > 0) then
			{
				_seat = _role select 0;

				if (_seat == "Driver") then
				{
					_suspects set [count _suspects, [_suspect, _source magazinesTurret [-1]]];
				}
				else
				{
					if (_seat == "Turret") then
					{
						_suspects set [count _suspects, [_suspect, _source magazinesTurret (_role select 1)]];
					};
				};
			};
		} forEach crew _source;
	};

	_unit setVariable ["FAR_killerAmmo", _ammo];
	_unit setVariable ["FAR_killerSuspects", _suspects];
};

if (UNCONSCIOUS(_unit)) then
{
	//if (_selection != "?") then
	//{
		_oldDamage = if (_selection == "") then {
			damage _unit
		} else {
			_unit getHitPointDamage (_unit getVariable ["A3W_hitPoint_" + _selection, ""]) // returns nil if hitpoint doesn't exist
		};

		if (!isNil "_oldDamage") then
		{
			_damage = ((_damage - _oldDamage) * FAR_DamageMultiplier) + _oldDamage;

			if (_criticalHit) then
			{
				_unit setDamage _damage;
			};
		};
	//};
}
else
{
	// Allow revive if unit is dead and not in exploded vehicle
	if (_dead && alive vehicle _unit) then
	{
		_unit setVariable ["FAR_isUnconscious", 1, true];
		[] spawn fn_deletePlayerData;

		_unit allowDamage false;
		[_unit, "AinjPpneMstpSnonWrflDnon"] call switchMoveGlobal;
		_unit enableFatigue true;
		_unit setFatigue 1;

		if (isNil "FAR_Player_Unconscious_thread" || {scriptDone FAR_Player_Unconscious_thread}) then
		{
			FAR_Player_Unconscious_thread = [_unit, _source] spawn FAR_Player_Unconscious;
		};

		_damage = 0.5;
	};
};

diag_log format ["yYy %1", _this];

//_damage
