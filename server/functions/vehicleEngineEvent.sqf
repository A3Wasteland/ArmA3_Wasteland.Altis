// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleEngineEvent.sqf
//	@file Author: AgentRev

_veh = _this select 0;
_running = _this select 1;

if (local _veh && _running) then
{
	_driver = (crew _veh) select 0;
	if (isNil "_driver") then { _driver = objNull };
	_dmg = _veh getHitPointDamage "HitEngine";

	if (_driver call A3W_fnc_isUnconscious || (!isNil "_dmg" && {_dmg >= 0.9})) then
	{
		_veh engineOn false;
	};
};
