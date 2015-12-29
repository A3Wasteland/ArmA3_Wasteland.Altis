/**
 * Initialise un objet déplaçable/héliportable/remorquable/transportable
 * 
 * @param 0 l'objet
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_objet", "_doLock", "_doUnlock", "_config", "_nom", "_fonctionnalites"];

_objet = _this select 0;

_doLock = 0;
_doUnlock = 1;

_config = configFile >> "CfgVehicles" >> (typeOf _objet);
_nom = getText (_config >> "displayName");

if (isNil {_objet getVariable "R3F_LOG_disabled"}) then
{
	_objet setVariable ["R3F_LOG_disabled", false];  //on altis its smarter to only enable deplacement on objects we WANT players to move so if it doesnt find an r3f tag, it disables r3f on the object
};

// Définition locale de la variable si elle n'est pas définie sur le réseau
if (isNil {_objet getVariable "R3F_LOG_est_transporte_par"}) then
{
	_objet setVariable ["R3F_LOG_est_transporte_par", objNull, false];
};

// Définition locale de la variable si elle n'est pas définie sur le réseau
if (isNil {_objet getVariable "R3F_LOG_est_deplace_par"}) then
{
	_objet setVariable ["R3F_LOG_est_deplace_par", objNull, false];
};

// Définition locale de la variable si elle n'est pas définie sur le réseau
if (isNil {_objet getVariable "R3F_LOG_proprietaire_verrou"}) then
{
	// En mode de lock side : uniquement si l'objet appartient initialement à une side militaire
	if (R3F_LOG_CFG_lock_objects_mode == "side") then
	{
		switch (getNumber (_config >> "side")) do
		{
			case 0: {_objet setVariable ["R3F_LOG_proprietaire_verrou", east, false];};
			case 1: {_objet setVariable ["R3F_LOG_proprietaire_verrou", west, false];};
			case 2: {_objet setVariable ["R3F_LOG_proprietaire_verrou", independent, false];};
		};
	}
	else
	{
		// En mode de lock faction : uniquement si l'objet appartient initialement à une side militaire
		if (R3F_LOG_CFG_lock_objects_mode == "faction") then
		{
			switch (getNumber (_config >> "side")) do
			{
				case 0; case 1; case 2:
				{_objet setVariable ["R3F_LOG_proprietaire_verrou", getText (_config >> "faction"), false];};
			};
		};
	};
};

// Si on peut embarquer dans l'objet
if (isNumber (_config >> "preciseGetInOut")) then
{
	// Ne pas monter dans un véhicule qui est en cours de transport
	_objet addEventHandler ["GetIn", R3F_LOG_FNCT_EH_GetIn];
};

// Indices du tableau des fonctionnalités retourné par R3F_LOG_FNCT_determiner_fonctionnalites_logistique
#define __can_be_depl_heli_remorq_transp 0
#define __can_be_moved_by_player 1
#define __can_lift 2
#define __can_be_lifted 3
#define __can_tow 4
#define __can_be_towed 5
#define __can_transport_cargo 6
#define __can_transport_cargo_cout 7
#define __can_be_transported_cargo 8
#define __can_be_transported_cargo_cout 9

_fonctionnalites = _objet getVariable "R3F_LOG_fonctionnalites";

if (R3F_LOG_CFG_unlock_objects_timer != -1) then
{
	_objet addAction [("<t color=""#ee0000"">" + format [STR_R3F_LOG_action_deverrouiller, _nom] + "</t>"), {_this call R3F_LOG_FNCT_deverrouiller_objet}, false, 11, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deverrouiller_valide"];
}
else
{
	_objet addAction [("<t color=""#ee0000"">" + STR_R3F_LOG_action_deverrouiller_impossible + "</t>"), {hintC STR_R3F_LOG_action_deverrouiller_impossible;}, false, 11, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deverrouiller_valide"];
};

if (_fonctionnalites select __can_be_moved_by_player) then
{
	_objet addAction [("<img image='client\icons\r3f_lift.paa' color='#00eeff'/> <t color=""#00eeff"">" + format [STR_R3F_LOG_action_deplacer_objet, _nom] + "</t>"), {_this call R3F_LOG_FNCT_objet_deplacer}, false, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_deplacer_objet_valide && !(_target getVariable ['objectLocked', false])"];
	_objet addAction [("<img image='client\icons\r3f_lock.paa' color='#ff0000'/> <t color='#ff0000'>" + STR_LOCK_OBJECT + "</t>"), "addons\R3F_LOG\objet_deplacable\objectLockStateMachine.sqf", _doLock, -5, false, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_deplacer_objet_valide && Object_canLock && (!(_target isKindOf 'AllVehicles') || {_target isKindOf 'StaticWeapon'})"];
	_objet addAction [("<img image='client\icons\r3f_unlock.paa' color='#06ef00'/> <t color='#06ef00'>" + STR_UNLOCK_OBJECT + "</t>"), "addons\R3F_LOG\objet_deplacable\objectLockStateMachine.sqf", _doUnlock, -5, false, true, "", "R3F_LOG_objet_addAction == _target && R3F_LOG_action_deplacer_objet_valide && !Object_canLock"];
};

if (_fonctionnalites select __can_be_towed) then
{
	if (_fonctionnalites select __can_be_moved_by_player) then
	{
		_objet addAction [("<img image='client\icons\r3f_tow.paa' color='#00dd00'/> <t color=""#00dd00"">" + STR_R3F_LOG_action_remorquer_deplace + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_remorquer_deplace}, nil, 6, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_joueur_deplace_objet == _target && R3F_LOG_action_remorquer_deplace_valide"];
	};
	
	_objet addAction [("<img image='client\icons\r3f_tow.paa' color='#00dd00'/> <t color=""#00dd00"">" + format [STR_R3F_LOG_action_remorquer_direct, _nom] + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_remorquer_direct}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_remorquer_direct_valide && Object_canLock"];
	
	_objet addAction [("<img image='client\icons\r3f_untow.paa' color='#00dd00'/> <t color=""#00dd00"">" + STR_R3F_LOG_action_detacher + "</t>"), {_this call R3F_LOG_FNCT_remorqueur_detacher}, nil, 6, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_detacher_valide"];
};

if (_fonctionnalites select __can_be_transported_cargo) then
{
	if (_fonctionnalites select __can_be_moved_by_player) then
	{
		_objet addAction [("<img image='client\icons\r3f_loadin.paa' color='#dddd00'/> <t color=""#dddd00"">" + STR_R3F_LOG_action_charger_deplace + "</t>"), {_this call R3F_LOG_FNCT_transporteur_charger_deplace}, nil, 8, true, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_joueur_deplace_objet == _target && R3F_LOG_action_charger_deplace_valide"];
	};
	
	_objet addAction [("<img image='client\icons\r3f_loadin.paa' color='#dddd00'/> <t color=""#dddd00"">" + format [STR_R3F_LOG_action_selectionner_objet_charge, _nom] + "</t>"), {_this call R3F_LOG_FNCT_transporteur_selectionner_objet}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_selectionner_objet_charge_valide && Object_canLock"];
};

if (_fonctionnalites select __can_be_moved_by_player) then
{
	_objet addAction [("<t color=""#ff9600"">" + STR_R3F_LOG_action_revendre_usine_deplace + "</t>"), {_this call R3F_LOG_FNCT_usine_revendre_deplace}, nil, 7, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_revendre_usine_deplace_valide"];
};