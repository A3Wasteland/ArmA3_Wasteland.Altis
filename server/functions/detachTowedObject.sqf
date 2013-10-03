//	@file Version: 1.0
//	@file Name: detachTowedObject.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 14:54

private ["_object", "_tower", "_airdrop", "_pos", "_vel"];

if (typeName _this != "ARRAY") then { _this = [_this] };

_object = objectFromNetId ([_this, 0, "", [""]] call BIS_fnc_param);

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
		detach _object;
		_object setPosATL [_pos select 0, _pos select 1, 0.01];	
		_object setVelocity [0,0,0.01];
	};
};
