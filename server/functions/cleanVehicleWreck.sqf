//	@file Version: 1.0
//	@file Name: cleanVehicleWreck.sqf
//	@file Author: AgentRev
//	@file Created: 16/06/2013 19:57

while {alive _this} do
{
	sleep 10;
};

sleep 600;
deleteVehicle _this;
