//	@file Name: getInVehicle.sqf
//	@file Author: AgentRev

private "_veh";
_veh = _this select 0;

if (isNil {_veh getVariable "A3W_handleDamageEH"}) then
{
	_veh setVariable ["A3W_handleDamageEH", _veh addEventHandler ["HandleDamage", vehicleHandleDamage]];
};

if (isNil {_veh getVariable "A3W_unconsciousEngineEH"}) then
{
	_veh setVariable ["A3W_unconsciousEngineEH", _veh addEventHandler ["Engine",
	{
		_veh = _this select 0;
		_turnedOn = _this select 1;
		
		if (local _veh && {_turnedOn && (driver _veh) getVariable ["FAR_isUnconscious", 0] == 1}) then
		{
			(driver _veh) action ["EngineOff", _veh];
			_veh engineOn false;
		};
	}]];
};
