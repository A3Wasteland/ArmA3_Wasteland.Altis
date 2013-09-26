//	@file Version: 1.0
//	@file Name: ownerManager.sqf
//	@file Author: AgentRev
//	@file Created: 23/09/2013 22:57

// This script must be called, spawned, or execVM'd once upon every vehicle created on the server. Ex.: _vehicle execVM "addons\fpsFix\ownerManager.sqf"
// For A3Wasteland, it is execVM'd in "server\functions\vehicleSetup.sqf"

// If you decide to use this script in another mission, a little mention in the credits would be appreciated :) - AgentRev

_this addEventHandler ["GetOut",
{
	// Transfer ownership of the vehicle back to the server when the driver gets out
	
	_this spawn
	{
		private ["_veh", "_grp", "_unit"];
		_veh = _this select 0;
		
		if !(_veh getVariable ["fpsFix_getOutEvent", false]) then
		{
			_veh setVariable ["fpsFix_getOutEvent", true];
			sleep 5;
			
			if (!local _veh && {isNull driver _veh}) then
			{
				_grp = createGroup sideLogic;
				_unit = _grp createUnit ["I_UAV_AI", getPos _veh, [], 0, "CAN_COLLIDE"]; // UAV AI units are invisible
				
				waitUntil 
				{
					_unit moveInDriver _veh;
					vehicle _unit == _veh
				};
				
				_unit leaveVehicle _veh;
				moveOut _unit;
				deleteVehicle _unit;
				deleteGroup _grp;
			};
			
			_veh setVariable ["fpsFix_getOutEvent", false];
		};
	};
}];
