#include "defs.hpp"
switch true do {
	case (_this == "bulletcam"): {
		if PG_get(bulletcam) then {
			switch PG_get(bullettime) do {
				case 1: {PG_set(bullettime,0.5); hint "AccTime 0.5"};
				case 0.5: {PG_set(bullettime,0.1); hint "AccTime 0.1"};
				default {
					PG_set(bullettime,1);
					PG_set(bulletcam,false);
					hint "Bulletcam disabled";
				};
			};
		}else{
			hint "Bulletcam enabled";
			PG_set(bulletcam,true);
		};
	};
	case (_this == "hitmarker"): {
		if PG_get(hitmarker) then {
			PG_set(hitmarker,false);
			{deleteMarkerLocal _x} forEach PG_get(hitmarkers);
			hint "Hitmarker disabled";
		}else{
			PG_set(hitmarker,true);
			hint "Hitmarker enabled";
		};
	};
};



