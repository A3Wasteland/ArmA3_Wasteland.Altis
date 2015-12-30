[] execVM "addons\cctv\config.sqf";

{
  private["_h"];
  _h = [] execVM format["addons\cctv\%1_functions.sqf", _x];
  waitUntil {scriptDone _h};
} forEach ["laptop_flat_menu", "cctv_menu", "cctv"]
