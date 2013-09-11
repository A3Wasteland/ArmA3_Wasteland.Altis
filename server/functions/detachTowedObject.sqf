//	@file Version: 1.0
//	@file Name: detachTowedObject.sqf
//	@file Author: AgentRev
//	@file Created: 014/07/2013 14:54

private ["_object", "_pos"];

_object = objectFromNetId (_this select 0);
_pos = getPos _object;
detach _object;

_object setPos [_pos select 0, _pos select 1, 0];
