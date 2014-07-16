//	@file Name: handleCorpseOnLeave.sqf
//	@file Author: AgentRev

// If player saving enabled, deletes corpse created by the game when an alive player disconnects

if !(["A3W_playerSaving"] call isConfigOn) exitWith {};

_this setVariable ["corpseLocalEH", _this addEventHandler ["Local",
{
	_unit = _this select 0;
	_local = _this select 1;

	if (!isPlayer _unit && !alive _unit && _local) then
	{
		deleteVehicle _unit;
	};
}]];
