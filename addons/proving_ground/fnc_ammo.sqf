#include "defs.hpp"
#define GET_DISPLAY (uiNameSpace getVariable "balca_debug_hint")
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
if PG_get(AMMO) then {
	PG_set(AMMO,false);
	hint "Infinite ammo disabled";
}else{
	hint "Infinite ammo enabled";
	PG_set(AMMO,true);
	[] spawn {
		while {PG_get(AMMO)} do {
			sleep 0.5;
			{
				if !(_x in weapons player) exitWith {
					[_x] call PG_get(fnc_add_weapon);
				};
			}forEach PG_get(weapons);
			{
				if !(_x in magazines player) exitWith {
					sleep .1;
					player addMagazine _x;
				};
			}forEach PG_get(mags);
			sleep 0.1;
			{
				(vehicle _x) setVehicleAmmo 1;
			}forEach units group player;
		};
	};
};


