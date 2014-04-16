/**
 * Initialise un véhicule remorqueur
 * 
 * @param 0 le remorqueur
 */

private ["_remorqueur", "_est_desactive", "_remorque"];

_remorqueur = _this select 0;

_est_desactive = _remorqueur getVariable "R3F_LOG_disabled";
if (isNil "_est_desactive") then
{
	_remorqueur setVariable ["R3F_LOG_disabled", false];
};

// Définition locale de la variable si elle n'est pas définie sur le réseau
_remorque = _remorqueur getVariable "R3F_LOG_remorque";
if (isNil "_remorque") then
{
	_remorqueur setVariable ["R3F_LOG_remorque", objNull, false];
};

_remorqueur addAction [("<img image='client\icons\r3f_tow.paa' color='#ffff00'/> <t color='#ffff00'>" + STR_R3F_LOG_action_remorquer_deplace + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\remorqueur\remorquer_deplace.sqf", nil, 6, true, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_remorquer_deplace_valide"];

_remorqueur addAction [("<img image='client\icons\r3f_tow.paa' color='#ffff00'/> <t color='#ffff00'>" + STR_R3F_LOG_action_remorquer_selection + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\remorqueur\remorquer_selection.sqf", nil, 6, true, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_remorquer_selection_valide"];

_remorqueur addAction [("<img image='client\icons\r3f_tow.paa' color='#ffff00'/> <t color='#ffff00'>" + STR_R3F_LOG_action_cancel_remorquer + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\remorqueur\cancel_remorquer.sqf", nil, 6, true, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_remorquer_selection_valide"];