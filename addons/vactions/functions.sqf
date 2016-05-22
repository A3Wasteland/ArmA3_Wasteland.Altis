call compile preprocessFileLineNumbers "addons\vactions\config.sqf";

{
  call compile preprocessFileLineNumbers format["addons\vactions\%1_functions.sqf", _x];
} forEach ["misc", "vector", "va"];
