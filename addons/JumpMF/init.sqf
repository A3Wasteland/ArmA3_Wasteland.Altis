//////////////////////////////////////////////////////////////////
// Script File for [Arma 3] - init.sqf
// Created by: Das Attorney
// Modified by: AgentRev
//////////////////////////////////////////////////////////////////

if (!hasInterface) exitWith {};

horde_jumpmf_var_jumping = false;
horde_jumpmf_fnc_detect_key_input = "addons\JumpMF\detect_key_input.sqf" call mf_compile;

waitUntil {!isNull findDisplay 46};
(findDisplay 46) displayAddEventHandler ["KeyDown", horde_jumpmf_fnc_detect_key_input];
