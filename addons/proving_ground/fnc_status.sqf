#include "defs.hpp"
#define GET_DISPLAY (uiNameSpace getVariable "balca_debug_hint")
#define GET_CTRL(a) (GET_DISPLAY displayCtrl ##a)
if (PG_get(STATUS)) then {
	PG_set(STATUS,false);
//	hint "Status display disabled";
}else{
	hint "Status display enabled";
	PG_set(STATUS,true);
	[] spawn {
		while {PG_get(STATUS)} do {
			sleep 0.5;
			_cursortarget = cursorTarget;
			if ((alive _cursortarget)) then {
				cutRsc ["balca_debug_hint","PLAIN"];
				_crew = crew _cursortarget;
				GET_CTRL(balca_hint_text_IDC) ctrlSetText format ["%1 Damage: %2",typeOf _cursortarget, round((damage _cursortarget)*100)/100];
				if (((count _crew) > 0)and!(_cursortarget isKindOf "CAManBase")) then {
					_crew_stat = [];
					{_crew_stat set [count _crew_stat, round((damage _x)*100)/100]} forEach _crew;
					GET_CTRL(balca_hint_text2_IDC) ctrlSetText format ["Crew status: %1",_crew_stat];
				};
			};
		};
	};
};


