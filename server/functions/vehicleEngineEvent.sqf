// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: vehicleEngineEvent.sqf
//	@file Author: AgentRev

params ["_veh", "_running"];

if (local _veh && _running) then
{
	_driver = _veh call fn_findPilot;
	_engine1 = _veh getHitPointDamage "HitEngine";
	_engine2 = _veh getHitPointDamage "HitEngine2";

	if (_driver call A3W_fnc_isUnconscious || (!isNil "_engine1" && {_engine1 > 0.9 && (isNil "_engine2" || {_engine2 > 0.9})})) then
	{
		_veh engineOn false;
	};
};
