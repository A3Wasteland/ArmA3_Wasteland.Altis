waitUntil {time > 0};
execVM "addons\Explosives-To-Vehicle\EtV.sqf";
waitUntil {!isNil "EtVInitialized"};
[player] call EtV_Actions;