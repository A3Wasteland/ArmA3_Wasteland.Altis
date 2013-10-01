//	@file Version: 1.0
//	@file Name: detachTowedObject.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 14:54

private ["_object", "_airdrop", "_pos", "_vel"];

if (typeName _this != "ARRAY") then { _this = [_this] };

_object = objectFromNetId (_this select 0);
_airdrop = if (count _this > 1) then { _this select 1 } else { false };

_object enableSimulation true; // FPS fix safeguard

if (_airdrop) then
{
	_vel = velocity _object;
	detach _object;
	_object setVelocity _vel;
}
else
{
	_pos = getPos _object;
	detach _object;
	_object setPos [_pos select 0, _pos select 1, 0.01];	
	_object setVelocity [0,0,0.01];
};
