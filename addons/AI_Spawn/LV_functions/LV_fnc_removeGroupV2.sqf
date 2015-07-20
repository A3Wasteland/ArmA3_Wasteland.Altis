//ARMA3Alpha function LV_fnc_removeGroup v0.2 - by SPUn / lostvar, REMAKE by kemor
//removes fillHouse or militarize units 
//Syntax: nul = [LVgroup*] execVM "addons\AI_Spawn\LV_functions\LV_fnc_removeGroupV2.sqf";
// * = id number (which is defined in fillHouse or militarize, so if ID is 10 = LVgroup10)
private["_grp"];

_grp = _this select 0;

{
	if(vehicle _x != _x)then
	{
		_veh = vehicle _x;		
		{
            //getting rid of the frikkin gunners!
			_x assignAsDriver _veh;
			unassignVehicle _x;
			moveOut _x;
			_x setPos [0,0,0];
			deleteVehicle _x;
		}forEach crew _veh;
		deleteVehicle _veh;	
	}
	else
	{
		deleteVehicle _x;
	};
}forEach units _grp;