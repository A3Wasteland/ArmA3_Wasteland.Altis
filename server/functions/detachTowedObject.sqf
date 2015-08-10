// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: detachTowedObject.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 14:54

private ["_object", "_tower", "_airdrop", "_pos", "_altitude", "_vel"];

_object = param [0, objNull, [objNull,""]];

if (typeName _object == "STRING") then { _object = objectFromNetId _object };

if (local _object) then
{
	_tower = attachedTo _object;
	_airdrop = param [1, false, [false]];

	_object enableSimulation true; // FPS fix safeguard
	_tower enableSimulation true;

	sleep 0.3;

	if (_airdrop) then
	{
		_vel = velocity _object;
		detach _object;
		_object setVelocity _vel;
	}
	else
	{
		_pos = getPos _object;
		_altitude = (getPosATL _object) select 2;
		detach _object;
		if (_tower isKindOf "Helicopter") then { _object setVectorUp [0,0,1] };
		_object setPosATL [_pos select 0, _pos select 1, (_altitude - (_pos select 2)) + 0.1];
		_object setVelocity [0,0,0.01];
	};

	_object lockDriver false;
	_object enableCopilot true;
};
