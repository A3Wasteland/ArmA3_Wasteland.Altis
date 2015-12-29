//	@file Version:
//	@file Name:
//	@file Author: Cael817, all credit to Killzone Kid
//	@file Created:

{
	if (!local _x) then
	{
		private ["_setOwner_time"];
		_setOwner_time = time;
		[_x, "setOwnerTo", player] call R3F_LOG_FNCT_exec_commande_MP; // Requires R3F 3.1
		waitUntil {local _x || time > _setOwner_time + 1.5};
	};

	_x setHit ["light_1_hitpoint", 0];
	_x setHit ["light_2_hitpoint", 0];
	_x setHit ["light_3_hitpoint", 0];
	_x setHit ["light_4_hitpoint", 0];
	_x setHit ["light_1_hit", 0];
	_x setHit ["light_2_hit", 0];
	_x setHit ["light_3_hit", 0];
	_x setHit ["light_4_hit", 0];
	_x setVariable ["lights", "on", true];
} forEach nearestObjects [player, [
	"Lamps_base_F",
	"PowerLines_base_F",
	"PowerLines_Small_base_F",
	"Land_Device_assembled_F"
], 30];

hint "Lights ON";