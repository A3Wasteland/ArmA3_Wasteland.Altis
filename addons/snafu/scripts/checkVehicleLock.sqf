//	@file Name: checkVehicleLock.sqf
//	@file Author: Cael817 (Original Author NiiV)

private ["_cTarget","_isOk","_display","_inVehicle","_lockState"];
disableSerialization;
while {true} do {
	waitUntil {!isnull (findDisplay 602)};
	_display = findDisplay 602;
	_inVehicle = (vehicle player) != player;
	_cTarget = cursorTarget;
	_lockState = locked cursorTarget >= 2;

	if(((vehicle player) distance _cTarget) < 12) then {
		switch (_lockState && !isNull cursorTarget && { alive cursorTarget && { cursorTarget isKindOf _x }count ['LandVehicle', 'Ship', 'Air'] > 0 } ) do {

			case false:{ // UNLOCKED
			
			};
			case true:{ // LOCKED
				titleText ["Cannot access gear in a locked vehicle.","PLAIN DOWN"]; titleFadeOut 2;
				_display closeDisplay 1;
			};
			case "0":{ // UNLOCKED
			
			};
			case "1":{ // LOCKED
				titleText ["Cannot access gear in a locked vehicle.","PLAIN DOWN"]; titleFadeOut 2;
				_display closeDisplay 1;
			};
		};
	};
};
