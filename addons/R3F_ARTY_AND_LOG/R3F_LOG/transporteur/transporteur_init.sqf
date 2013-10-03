/**
 * Initialise un véhicule transporteur
 * 
 * @param 0 le transporteur
 */

private ["_transporteur", "_est_desactive", "_objets_charges"];

_transporteur = _this select 0;

_est_desactive = _transporteur getVariable "R3F_LOG_disabled";
if (isNil "_est_desactive") then
{
	_transporteur setVariable ["R3F_LOG_disabled", false];
};

// Définition locale de la variable si elle n'est pas définie sur le réseau
_objets_charges = _transporteur getVariable "R3F_LOG_objets_charges";
if (isNil "_objets_charges") then
{
	_transporteur setVariable ["R3F_LOG_objets_charges", [], false];
};

_transporteur addAction [("<img image='client\icons\r3f_loadin.paa' color='#06ef00'/> <t color='#06ef00'>" + STR_R3F_LOG_action_charger_deplace + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\transporteur\charger_deplace.sqf", nil, 6, true, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_charger_deplace_valide"];

_transporteur addAction [("<img image='client\icons\r3f_loadin.paa' color='#06ef00'/> <t color='#06ef00'>" + STR_R3F_LOG_action_charger_selection + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\transporteur\charger_selection.sqf", nil, 6, true, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_charger_selection_valide"];

_transporteur addAction [("<img image='client\icons\r3f_contents.paa' color='#ffff00'/> <t color='#ffff00'>" + STR_R3F_LOG_action_contenu_vehicule + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\transporteur\voir_contenu_vehicule.sqf", nil, 5, false, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_contenu_vehicule_valide"];
