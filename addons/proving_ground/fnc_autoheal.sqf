#include "defs.hpp"
if PG_get(Autoheal) then {
	PG_set(Autoheal,false);
	hint "Autoheal disabled";
}else{
	hint "Autoheal enabled";
	PG_set(Autoheal,true);
	[] spawn {
		while {PG_get(Autoheal)} do {
			sleep 0.5;
			_cursortarget = cursorTarget;
			_veh = vehicle player;
			_p_hit_EH = player addEventHandler ["hit",{player setDammage 0}];
			_p_dam_EH = player addEventHandler ["dammaged",{player setDammage 0}];
			_veh_hit_EH = _veh addEventHandler ["hit",{vehicle player setDammage 0}];
			_veh_dam_EH = _veh addEventHandler ["dammaged",{vehicle player setDammage 0}];
			while {(_veh == (vehicle player))&&PG_get(Autoheal)} do {
				if (isClass(configFile >> "cfgPatches" >> "ace_main")) then {
					player setVariable ["ace_w_bleed", 0];
					player setVariable ["ace_w_pain", 0];
					player setVariable ["ace_w_state", 0, true];
					player setVariable ["ace_sys_wounds_uncon", false, true];
					player setVariable ["ace_w_unconlen", time];
					player setVariable ["ace_w_revive", -1];
					player setVariable ["ace_sys_stamina_Fatigue", 0];
				};
				player setDammage 0;
				_veh setDammage 0;
				_veh setFuel 1;
				sleep .5;
			};
			player removeEventHandler ["hit",_p_hit_EH];
			player removeEventHandler ["dammaged",_p_dam_EH];
			_veh removeEventHandler ["hit",_veh_hit_EH];
			_veh removeEventHandler ["dammaged",_veh_dam_EH];
		};
	};
};