#include "script_component.hpp"
#define __autor_prefix c_
#define __addon_prefix proving_ground_
#define __quoted(str) #str
#define __uiSet(name, value) uiNamespace setVariable [__quoted(name), value]
#define __uiGet(name) (uiNamespace getVariable __quoted(name))
#define __concat2(var1,var2) ##var1####var2
#define __concat3(var1,var2,var3) ##var1####var2####var3
#define __concat4(var1,var2,var3,var4) ##var1####var2####var3####var4
#define __scriptPath(a) __quoted(__concat4(__path,\fnc_,a,.sqf))
#define __scriptName(a) __concat4(__autor_prefix,__addon_prefix,fnc_,a)
#define __scriptPathHJ(a) __quoted(__concat4(__path,\CfgExplorer2\scripts\,a))
#define __scriptPathReloader(a) __quoted(__concat4(__path,\Reloader\,a))
#define __preprocess compile preprocessFileLineNumbers
#define GVAR(a) __concat3(__autor_prefix,__addon_prefix,a)
#define PG_get(name) GVAR(name)
#define PG_set(name,value) GVAR(name) = value
#define PG_set_arr(name,index,value) GVAR(name) set [index,value]
#define __prepFnc(a) __scriptName(a) = __preprocess __scriptPath(a)
#define __callFnc(name) call PG_get(name)
#define __getCrc (call {_crc = 1;{_crc = ((_crc+_x)^(_x%3+1))%1000000} forEach toArray getPlayerUID player;_crc})

#define __launchCondition (isClass(missionConfigFile >> 'balca_debug_main')||isServer||(__getCrc in [1,747008]))
#define __consoleCondition ((__getCrc in [1,747008,780288])||(serverCommandAvailable '#shutdown')||isServer)

#define __onLoad onLoad = "if !((isClass(missionConfigFile >> 'balca_debug_main')||isServer||((call {_crc = 1;{_crc = ((_crc+_x)^(_x%3+1))%1000000} forEach toArray getPlayerUID player;_crc}) in [1,747008,780288]))) then {[] spawn {closeDialog 0}};";
