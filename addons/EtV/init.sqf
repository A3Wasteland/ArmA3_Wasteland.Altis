waitUntil {time > 0};
execVM "addons\EtV\EtV.sqf";
waitUntil {!isNil "EtVInitialized"};
[player] call EtV_Actions;