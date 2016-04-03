// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getInVehicle.sqf
//	@file Author: AgentRev

scopeName "getInVehicle";
private "_veh";
_veh = _this select 0;

if (isNil {_veh getVariable "A3W_hitPointSelections"}) then
{
	{
		_veh setVariable ["A3W_hitPoint_" + getText (_x >> "name"), configName _x, true];
	} forEach ((typeOf _veh) call getHitPoints);

	_veh setVariable ["A3W_hitPointSelections", true, true];
};

if (isNil {_veh getVariable "A3W_handleDamageEH"}) then
{
	_veh setVariable ["A3W_handleDamageEH", _veh addEventHandler ["HandleDamage", vehicleHandleDamage]];
};

if (isNil {_veh getVariable "A3W_dammagedEH"}) then
{
	_veh setVariable ["A3W_dammagedEH", _veh addEventHandler ["Dammaged", vehicleDammagedEvent]];
};

if (isNil {_veh getVariable "A3W_engineEH"}) then
{
	_veh setVariable ["A3W_engineEH", _veh addEventHandler ["Engine", vehicleEngineEvent]];
};

// Eject Independents of vehicle if it is already used by another group
if !(playerSide in [BLUFOR,OPFOR]) then
{
	{
		if (isPlayer _x && alive _x && group _x != group player) exitWith 
		{
			moveOut player;
			["You can't enter vehicles being used by enemy groups.", 5] call mf_notify_client;
			breakOut "getInVehicle";
		};
	} forEach crew _veh;
};

if (_veh isKindOf "Offroad_01_repair_base_F" && isNil {_veh getVariable "A3W_serviceBeaconActions"}) then
{
	_veh setVariable ["A3W_serviceBeaconActions",
	[
		_veh addAction ["Beacons on", { (_this select 0) animate ["BeaconsServicesStart", 1] }, [], 1.5, false, true, "", "driver _target == player && _target animationPhase 'BeaconsServicesStart' < 1"],
		_veh addAction ["Beacons off", { (_this select 0) animate ["BeaconsServicesStart", 0] }, [], 1.5, false, true, "", "driver _target == player && _target animationPhase 'BeaconsServicesStart' >= 1"]
	]];
};

player setVariable ["lastVehicleRidden", netId _veh];

// FAR injured unit vehicle loading
[_veh] call FAR_Drag_Load_Vehicle;
