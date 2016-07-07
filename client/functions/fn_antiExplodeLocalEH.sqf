// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2016 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_antiExplodeLocalEH.sqf
//	@file Author: AgentRev

params ["_veh", "_local"];

if !(_local && {(isTouchingGround _veh || (getPos _veh) select 2 < 0.1) && vectorMagnitude velocity _veh < 1}) exitWith {};

_veh allowDamage false;
_veh setPosWorld ((getPosWorld _veh) vectorAdd [0, 0, 0.1]);

_veh spawn
{
	sleep 0.01;
	_this allowDamage ((_this getVariable ["allowDamage", true]) param [0,true,[false]]);
};
