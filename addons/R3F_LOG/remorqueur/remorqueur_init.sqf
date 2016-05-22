/**
 * Initialise un véhicule remorqueur
 * 
 * @param 0 le remorqueur
 */

private ["_remorqueur"];

_remorqueur = _this select 0;

// Définition locale de la variable si elle n'est pas définie sur le réseau
if (isNil {_remorqueur getVariable "R3F_LOG_remorque"}) then
{
	_remorqueur setVariable ["R3F_LOG_remorque", objNull, false];
};

_remorqueur addAction [("<img image='client\icons\r3f_tow.paa' color='#00dd00'/> <t color=""#00dd00"">" + STR_R3F_LOG_action_remorquer_deplace + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_remorquer_deplace}, nil, 7, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_joueur_deplace_objet != _target && R3F_LOG_action_remorquer_deplace_valide"];