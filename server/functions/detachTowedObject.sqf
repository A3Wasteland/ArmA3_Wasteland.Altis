//	@file Version: 1.0
//	@file Name: detachTowedObject.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 14:54

private ["_object", "_tower", "_airdrop", "_pos", "_posZ", "_vel"];

if (typeName _this != "OBJECT") exitWith {};

_object = _this;

if (!isNull _object && {local _object}) then
{
	_tower = _object getVariable ["R3F_LOG_remorque", objNull];
	_airdrop = [_this, 1, false, [false]] call BIS_fnc_param;
	
	_object enableSimulation true; // FPS fix safeguard
	_tower enableSimulation true;
	
	if (_airdrop) then
	{
		_vel = velocity _object;
		detach _object;
		_object setVelocity _vel;
	}
	else
	{
		_pos = getPos _object;
		_posZ = (getPosATL _object) select 2;
		detach _object;
		_object setPosATL [_pos select 0, _pos select 1, (_posZ - (_pos select 2)) + 0.01];	
		_object setVelocity [0,0,0.01];
		_object lockDriver false;
		_objet enableCopilot true;
	};
};
