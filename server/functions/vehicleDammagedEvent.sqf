// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleDammagedEvent.sqf
//	@file Author: AgentRev

_veh = _this select 0;

if (local _veh) then
{
	_dmg = _veh getHitPointDamage "HitEngine";

	if (!isNil "_dmg" && {_dmg >= 0.9}) then
	{
		_veh engineOn false;

		_driver = (crew _veh) select 0;

		if (!isNil "_driver") then
		{
			_driver action ["EngineOff", _veh];
		};

		_dmg = _veh getHitPointDamage "HitHull";

		if (!isNil "_dmg" && {_dmg < 0.5}) then
		{
			_veh setHitPointDamage ["HitHull", 0.5];
		};
	};
};
