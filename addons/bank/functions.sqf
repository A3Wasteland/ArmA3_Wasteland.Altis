[] execVM "addons\bank\config.sqf";

{
  private["_h"];
  _h = [] execVM format["addons\bank\%1_functions.sqf", _x];
  waitUntil {scriptDone _h};
} forEach ["misc", "bank_menu", "bank", "cash", "interact", "atm"]
