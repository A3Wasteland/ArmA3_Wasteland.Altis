/**
 * Initialise un véhicule transporteur
 * 
 * @param 0 le transporteur
 */

private ["_transporteur"];

_transporteur = _this select 0;

// Définition locale de la variable si elle n'est pas définie sur le réseau
if (isNil {_transporteur getVariable "R3F_LOG_objets_charges"}) then
{
	_transporteur setVariable ["R3F_LOG_objets_charges", [], false];
};

_transporteur addAction [("<img image='client\icons\r3f_loadin.paa' color='#dddd00'/> <t color=""#dddd00"">" + STR_R3F_LOG_action_charger_deplace + "</t>"), {_this call R3F_LOG_FNCT_transporteur_charger_deplace}, nil, 8, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_joueur_deplace_objet != _target && R3F_LOG_action_charger_deplace_valide"];

_transporteur addAction [("<img image='client\icons\r3f_loadin.paa' color='#dddd00'/> <t color=""#dddd00"">" + format [STR_R3F_LOG_action_charger_selection, getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName")] + "</t>"), {_this call R3F_LOG_FNCT_transporteur_charger_selection}, nil, 7, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_charger_selection_valide"];

_transporteur addAction [("<img image='client\icons\r3f_contents.paa' color='#dddd00'/> <t color=""#dddd00"">" + STR_R3F_LOG_action_contenu_vehicule + "</t>"), {_this call R3F_LOG_FNCT_transporteur_voir_contenu_vehicule}, nil, 4, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_contenu_vehicule_valide"];