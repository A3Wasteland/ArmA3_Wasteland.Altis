
//	@file Version: 1.0
//	@file Name: switchButtonNames.sqf
//	@file Author: [404] Costlyy
//	@file Created: 08/12/2012 18:30
//	@file Args: [int(0 = show towns | 1 = show beacons)]

_selectedButton = _this select 0;

if(_selectedButton == 0) then {
	// Spawn in town buttons show
	showBeacons = false;
} else {
	// Spawn at beacon buttons show
	showBeacons = true;
};