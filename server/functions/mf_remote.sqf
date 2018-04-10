// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mf_remote.sqf
//	@file Author: AgentRev

mf_jerrycan_fuel_amount = {
	private ["_vehicle", "_fuel_amount", "_config", "_type"];
	_vehicle = _this select 0;
	_fuel_amount = ["config_refuel_amount_default", 0.25] call getPublicVar;
	{
		_type = _x select 0;
		if (_vehicle isKindOf _type ) exitWith
		{
			_fuel_amount = _x select 1;
		};
	} forEach (["config_refuel_amounts", []] call getPublicVar);
	_fuel_amount;
} call mf_compile;

mf_remote_refuel = {
	private ["_vehicle", "_qty", "_fuel"];
	_vehicle = objectFromNetId (_this select 0);
	_fuel = fuel _vehicle + ([_vehicle] call mf_jerrycan_fuel_amount);
	_vehicle setFuel (_fuel min 1);
} call mf_compile;

mf_remote_syphon = {
	private ["_vehicle", "_qty", "_fuel"];
	_vehicle = objectFromNetId (_this select 0);
	_fuel = fuel _vehicle - ([_vehicle] call mf_jerrycan_fuel_amount);
	_vehicle setFuel (_fuel max 0);
} call mf_compile;

mf_remote_repair = {
	private "_vehicle";
	_vehicle = objectFromNetId (_this select 0);
	_vehicle setDamage 0;
	if (_vehicle isKindOf "Boat_Armed_01_base_F" && count (_vehicle magazinesTurret [0]) == 0) then { _vehicle setHitPointDamage ["HitTurret", 1] }; // disable front GMG on speedboats
	_vehicle setVariable ["FAR_killerVehicle", nil, true];
	_vehicle setVariable ["FAR_killerAmmo", nil, true];

	// reset ejection seat crap
	if (_vehicle isKindOf "Plane") then
	{
		_vehicle setVariable ["bis_ejected", nil, true];
		{ _vehicle animate [_x, 0, true] } forEach ["canopy_hide", "ejection_seat_motion", "ejection_seat_hide"];
	};
} call mf_compile;
