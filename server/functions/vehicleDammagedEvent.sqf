// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleDammagedEvent.sqf
//	@file Author: AgentRev

params ["_veh"];

if (local _veh) then
{
	_engine1 = _veh getHitPointDamage "HitEngine";
	_engine2 = _veh getHitPointDamage "HitEngine2";

	if (!isNil "_engine1" && {_engine1 > 0.9 && (isNil "_engine2" || {_engine2 > 0.9})}) then
	{
		_veh engineOn false;
	};
};
