/**
 * Initialise un véhicule héliporteur
 * 
 * @param 0 l'héliporteur
 */

private ["_heliporteur", "_est_desactive", "_heliporte"];

_heliporteur = _this select 0;

_est_desactive = _heliporteur getVariable "R3F_LOG_disabled";
if (isNil "_est_desactive") then
{
	_heliporteur setVariable ["R3F_LOG_disabled", false];
};

// Définition locale de la variable si elle n'est pas définie sur le réseau
_heliporte = _heliporteur getVariable "R3F_LOG_heliporte";
if (isNil "_heliporte") then
{
	_heliporteur setVariable ["R3F_LOG_heliporte", objNull, false];
};

_heliporteur addAction [("<img image='client\icons\r3f_tow.paa' color='#ffff00'/> <t color='#ffff00'>" + STR_R3F_LOG_action_heliporter + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\heliporteur\heliporter.sqf", nil, 6, true, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_heliporter_valide"];

_heliporteur addAction [("<img image='client\icons\r3f_release.paa' color='#06ef00'/> <t color='#06ef00'>" + STR_R3F_LOG_action_heliport_larguer + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\heliporteur\larguer.sqf", nil, 6, true, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_heliport_larguer_valide"];
