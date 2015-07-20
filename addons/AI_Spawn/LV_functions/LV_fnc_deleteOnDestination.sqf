//ARMA3Alpha function LV_fnc_deleteOnDestination v0.3 - by SPUn / lostvar
//deletes unit after reaching its destination, used by LV_fnc_removeAC.sqf

private ["_unit","_destination","_stPos"];

_unit = _this select 0;
_destination = _this select 1;
_unit setSkill ["courage",1.0];

while{alive _unit}do{
	//I cant figure out why, but sometimes some infantry units gets stuck on crouch repeating "weapon up - weapon down"
	// -animation, and until I find out why, this _stPos check is here to kill units which has been 25secs at the same position
	_stPos = (_unit getVariable "stPos0");
	if(isNil("_stPos"))then{_unit setVariable ["stPos0", (getPos _unit), false];}else{ 
		//hint format["%1 vs %2",_stPos,(getPos _unit)];
		if(str(_stPos) == str(getPos _unit))then{ 
			_unit setDamage 1;
			//hint "unit killed becouse of getting stuck";
		}else{
			_unit setVariable ["stPos0", (getPos _unit), false];
		};
	};

	if((_unit distance _destination)<200)then{
		//hint format["deleted unit:%1",_unit];
		if(vehicle _unit != _unit)then{deleteVehicle (vehicle _unit);};
		deleteVehicle _unit;
	};
	sleep 25;
};