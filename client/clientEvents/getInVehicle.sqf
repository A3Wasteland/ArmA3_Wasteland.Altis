// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: getInVehicle.sqf
//	@file Author: AgentRev

private "_veh";
_veh = _this select 0;

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

if (_veh isKindOf "Offroad_01_repair_base_F" && isNil {_veh getVariable "A3W_serviceBeaconActions"}) then
{
	_veh setVariable ["A3W_serviceBeaconActions",
	[
		_veh addAction ["Beacons on", { (_this select 0) animate ["BeaconsServicesStart", 1] }, [], 1.5, false, true, "", "driver _target == player && _target animationPhase 'BeaconsServicesStart' < 1"],
		_veh addAction ["Beacons off", { (_this select 0) animate ["BeaconsServicesStart", 0] }, [], 1.5, false, true, "", "driver _target == player && _target animationPhase 'BeaconsServicesStart' >= 1"]
	]];
};


//Kick out Indi-Player of vehicle if is is already used by other people, only run if player enters vehicle
_crew = crew _veh;
if ( (count _crew) > 1) then  //player already in vehicle when this code runs - so at least 2 people have to be in vehicle
{
	{
		if (isPlayer _x && alive _x) then  
		{
			if (!(playerSide in [BLUFOR,OPFOR]) && group _x != group player ) then //check if other ppl which where in vehicle before are in the players group
			{
				player action ["Eject", vehicle player];
				["You can't enter vehicles of other independent players without grouping first.", 5] call mf_notify_client;
			}
		};
	} forEach _crew;
		
};
