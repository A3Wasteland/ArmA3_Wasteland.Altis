/**
 * Evalue régulièrement les conditions à vérifier pour autoriser les actions logistiques
 * Permet de diminuer la fréquence des vérifications des conditions normalement faites
 * dans les addAction (~60Hz) et donc de limiter la consommation CPU.
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_joueur", "_vehicule_joueur", "_cursorTarget_distance", "_objet_pointe", "_objet_pas_en_cours_de_deplacement", "_fonctionnalites", "_pas_de_hook"];
private ["_objet_deverrouille", "_objet_pointe_autre_que_deplace", "_objet_pointe_autre_que_deplace_deverrouille", "_isUav", "_usine_autorisee_client"];

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

sleep 2;

while {true} do
{
	_joueur = player;
	_vehicule_joueur = vehicle _joueur;
	
	_cursorTarget_distance = call R3F_LOG_FNCT_3D_cursorTarget_distance_bbox;
	_objet_pointe = _cursorTarget_distance select 0;
	
	if (call compile R3F_LOG_CFG_string_condition_allow_logistics_on_this_client &&
		!R3F_LOG_mutex_local_verrou && _vehicule_joueur == _joueur && !isNull _objet_pointe && _cursorTarget_distance select 1 < 3.75
	) then
	{
		R3F_LOG_objet_addAction = _objet_pointe;
		
		Object_canLock = !(_objet_pointe getVariable ['objectLocked', false]); // test
		
		_fonctionnalites = _objet_pointe getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log];
		
		_objet_pas_en_cours_de_deplacement = (isNull (_objet_pointe getVariable ["R3F_LOG_est_deplace_par", objNull]) ||
			{(!alive (_objet_pointe getVariable "R3F_LOG_est_deplace_par")) || (!isPlayer (_objet_pointe getVariable "R3F_LOG_est_deplace_par"))});
		
		_isUav =  (getNumber (configFile >> "CfgVehicles" >> (typeOf _objet_pointe) >> "isUav") == 1);
		
		_usine_autorisee_client = call compile R3F_LOG_CFG_string_condition_allow_creation_factory_on_this_client;
		
		// L'objet est-il déverrouillé
		_objet_deverrouille = !([_objet_pointe, _joueur] call R3F_LOG_FNCT_objet_est_verrouille);
		
		// Trouver l'objet pointé qui se trouve derrière l'objet en cours de déplacement
		_objet_pointe_autre_que_deplace = [R3F_LOG_joueur_deplace_objet, 3.75] call R3F_LOG_FNCT_3D_cursorTarget_virtuel;
		
		if (!isNull _objet_pointe_autre_que_deplace) then
		{
			// L'objet (pointé qui se trouve derrière l'objet en cours de déplacement) est-il déverrouillé
			_objet_pointe_autre_que_deplace_deverrouille = !([_objet_pointe_autre_que_deplace, _joueur] call R3F_LOG_FNCT_objet_est_verrouille);
		};
		
		// Si l'objet est un objet déplaçable
		if (_fonctionnalites select __can_be_moved_by_player) then
		{
			// Condition action deplacer_objet
			R3F_LOG_action_deplacer_objet_valide = (count crew _objet_pointe == 0 || _isUav) && (isNull R3F_LOG_joueur_deplace_objet) &&
				_objet_pas_en_cours_de_deplacement && isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par") &&
				_objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled");
			
			// Condition action revendre_usine_deplace
			R3F_LOG_action_revendre_usine_deplace_valide = _usine_autorisee_client && R3F_LOG_CFG_CF_sell_back_bargain_rate != -1 &&
				_objet_pointe getVariable ["R3F_LOG_CF_depuis_usine", false] && (count crew _objet_pointe == 0 || _isUav) &&
				(R3F_LOG_joueur_deplace_objet == _objet_pointe) && !(_objet_pointe getVariable "R3F_LOG_disabled") && !isNull _objet_pointe_autre_que_deplace &&
				{
					!(_objet_pointe_autre_que_deplace getVariable ["R3F_LOG_CF_disabled", true]) &&
					_objet_pointe_autre_que_deplace getVariable ["R3F_LOG_CF_side_addAction", side group _joueur] == side group _joueur &&
					(abs ((getPosASL _objet_pointe_autre_que_deplace select 2) - (getPosASL player select 2)) < 2.5) &&
					alive _objet_pointe_autre_que_deplace && (vectorMagnitude velocity _objet_pointe_autre_que_deplace < 6)
				};
		};
		
		// Si l'objet est un objet remorquable
		if (_fonctionnalites select __can_be_towed) then
		{
			// Et qu'il est déplaçable
			if (_fonctionnalites select __can_be_moved_by_player) then
			{
				// Condition action remorquer_deplace
				R3F_LOG_action_remorquer_deplace_valide = !(_objet_pointe getVariable "R3F_LOG_disabled") && (count crew _objet_pointe == 0 || _isUav) &&
					(R3F_LOG_joueur_deplace_objet == _objet_pointe) && !isNull _objet_pointe_autre_que_deplace &&
					{
						(_objet_pointe_autre_que_deplace getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select __can_tow) && alive _objet_pointe_autre_que_deplace &&
						isNull (_objet_pointe_autre_que_deplace getVariable "R3F_LOG_est_transporte_par") && isNull (_objet_pointe_autre_que_deplace getVariable "R3F_LOG_remorque") &&
						(vectorMagnitude velocity _objet_pointe_autre_que_deplace < 6) &&
						_objet_pointe_autre_que_deplace_deverrouille && !(_objet_pointe_autre_que_deplace getVariable "R3F_LOG_disabled")
					};
			};
			
			// Condition action selectionner_objet_remorque
			R3F_LOG_action_remorquer_direct_valide = (count crew _objet_pointe == 0 || _isUav) && isNull R3F_LOG_joueur_deplace_objet &&
				isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par") && isNull (_objet_pointe getVariable ["R3F_LOG_remorque", objNull]) &&
				_objet_pas_en_cours_de_deplacement && _objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled") &&
				{
					{
						_x != _objet_pointe && (_x getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select __can_tow) &&
						alive _x && isNull (_x getVariable "R3F_LOG_est_transporte_par") &&
						isNull (_x getVariable "R3F_LOG_remorque") && (vectorMagnitude velocity _x < 6) &&
						!([_x, _joueur] call R3F_LOG_FNCT_objet_est_verrouille) && !(_x getVariable "R3F_LOG_disabled") &&
						{
							private ["_delta_pos"];
							
							_delta_pos =
							(
								_objet_pointe modelToWorld
								[
									boundingCenter _objet_pointe select 0,
									boundingBoxReal _objet_pointe select 1 select 1,
									boundingBoxReal _objet_pointe select 0 select 2
								]
							) vectorDiff (
								_x modelToWorld
								[
									boundingCenter _x select 0,
									boundingBoxReal _x select 0 select 1,
									boundingBoxReal _x select 0 select 2
								]
							);
							
							// L'arrière du remorqueur est proche de l'avant de l'objet pointé
							abs (_delta_pos select 0) < 3 && abs (_delta_pos select 1) < 5
						}
					} count (nearestObjects [_objet_pointe, ["All"], 30]) != 0
				};
			
			// Condition action detacher
			R3F_LOG_action_detacher_valide = (isNull R3F_LOG_joueur_deplace_objet) &&
				!isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par") && _objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled");
		};
		
		// Si l'objet est un objet transportable
		if (_fonctionnalites select __can_be_transported_cargo) then
		{
			// Et qu'il est déplaçable
			if (_fonctionnalites select __can_be_moved_by_player) then
			{
				// Condition action charger_deplace
				R3F_LOG_action_charger_deplace_valide = (count crew _objet_pointe == 0 || _isUav) && (R3F_LOG_joueur_deplace_objet == _objet_pointe) &&
					!(_objet_pointe getVariable "R3F_LOG_disabled") && !isNull _objet_pointe_autre_que_deplace &&
					{
						(_objet_pointe_autre_que_deplace getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select __can_transport_cargo) &&
						(abs ((getPosASL _objet_pointe_autre_que_deplace select 2) - (getPosASL player select 2)) < 2.5) &&
						alive _objet_pointe_autre_que_deplace && (vectorMagnitude velocity _objet_pointe_autre_que_deplace < 6) &&
						_objet_pointe_autre_que_deplace_deverrouille && !(_objet_pointe_autre_que_deplace getVariable "R3F_LOG_disabled")
					};
			};
			
			// Condition action selectionner_objet_charge
			R3F_LOG_action_selectionner_objet_charge_valide = (count crew _objet_pointe == 0 || _isUav) && isNull R3F_LOG_joueur_deplace_objet &&
				isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par") &&
				_objet_pas_en_cours_de_deplacement && _objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled");
		};
		
		// Si l'objet est un véhicule remorqueur
		if (_fonctionnalites select __can_tow) then
		{
			// Condition action remorquer_deplace
			R3F_LOG_action_remorquer_deplace_valide = (alive _objet_pointe) && (!isNull R3F_LOG_joueur_deplace_objet) &&
				!(R3F_LOG_joueur_deplace_objet getVariable "R3F_LOG_disabled") && (R3F_LOG_joueur_deplace_objet != _objet_pointe) &&
				(R3F_LOG_joueur_deplace_objet getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select __can_be_towed) &&
				isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par") &&
				isNull (_objet_pointe getVariable "R3F_LOG_remorque") && (vectorMagnitude velocity _objet_pointe < 6) &&
				_objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled");
		};
		
		// Si l'objet est un véhicule transporteur
		if (_fonctionnalites select __can_transport_cargo) then
		{
			// Condition action charger_deplace
			R3F_LOG_action_charger_deplace_valide = alive _objet_pointe && (!isNull R3F_LOG_joueur_deplace_objet) &&
				!(R3F_LOG_joueur_deplace_objet getVariable "R3F_LOG_disabled") && (R3F_LOG_joueur_deplace_objet != _objet_pointe) &&
				(R3F_LOG_joueur_deplace_objet getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select __can_be_transported_cargo) &&
				(vectorMagnitude velocity _objet_pointe < 6) && _objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled");
			
			// Condition action charger_selection
			R3F_LOG_action_charger_selection_valide = alive _objet_pointe && (isNull R3F_LOG_joueur_deplace_objet) &&
				(!isNull R3F_LOG_objet_selectionne) && (R3F_LOG_objet_selectionne != _objet_pointe) &&
				!(R3F_LOG_objet_selectionne getVariable "R3F_LOG_disabled") &&
				(R3F_LOG_objet_selectionne getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select __can_be_transported_cargo) &&
				(vectorMagnitude velocity _objet_pointe < 6) && _objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled");
			
			// Condition action contenu_vehicule
			R3F_LOG_action_contenu_vehicule_valide = alive _objet_pointe && (isNull R3F_LOG_joueur_deplace_objet) &&
				(vectorMagnitude velocity _objet_pointe < 6) && _objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled");
		};
		
		// Condition action ouvrir_usine
		R3F_LOG_action_ouvrir_usine_valide = _usine_autorisee_client && isNull R3F_LOG_joueur_deplace_objet &&
			!(_objet_pointe getVariable "R3F_LOG_CF_disabled") && alive _objet_pointe &&
			_objet_pointe getVariable ["R3F_LOG_CF_side_addAction", side group _joueur] == side group _joueur;
		
		// Condition action revendre_usine_deplace
		R3F_LOG_action_revendre_usine_deplace_valide = _usine_autorisee_client && R3F_LOG_CFG_CF_sell_back_bargain_rate != -1 && alive _objet_pointe &&
			(!isNull R3F_LOG_joueur_deplace_objet) && R3F_LOG_joueur_deplace_objet getVariable ["R3F_LOG_CF_depuis_usine", false] &&
			!(R3F_LOG_joueur_deplace_objet getVariable "R3F_LOG_disabled") && (R3F_LOG_joueur_deplace_objet != _objet_pointe) &&
			(vectorMagnitude velocity _objet_pointe < 6) && !(_objet_pointe getVariable "R3F_LOG_CF_disabled") &&
			_objet_pointe getVariable ["R3F_LOG_CF_side_addAction", side group _joueur] == side group _joueur;
		
		// Condition action revendre_usine_selection
		R3F_LOG_action_revendre_usine_selection_valide = _usine_autorisee_client && R3F_LOG_CFG_CF_sell_back_bargain_rate != -1 && alive _objet_pointe &&
			(isNull R3F_LOG_joueur_deplace_objet) && R3F_LOG_objet_selectionne getVariable ["R3F_LOG_CF_depuis_usine", false] &&
			(!isNull R3F_LOG_objet_selectionne) && (R3F_LOG_objet_selectionne != _objet_pointe) && !(R3F_LOG_objet_selectionne getVariable "R3F_LOG_disabled") &&
			(vectorMagnitude velocity _objet_pointe < 6) && !(_objet_pointe getVariable "R3F_LOG_CF_disabled") &&
			_objet_pointe getVariable ["R3F_LOG_CF_side_addAction", side group _joueur] == side group _joueur;
		
		// Condition action revendre_usine_direct
		R3F_LOG_action_revendre_usine_direct_valide = _usine_autorisee_client && R3F_LOG_CFG_CF_sell_back_bargain_rate != -1 &&
			_objet_pointe getVariable ["R3F_LOG_CF_depuis_usine", false] && (count crew _objet_pointe == 0 || _isUav) &&
			isNull R3F_LOG_joueur_deplace_objet && isNull (_objet_pointe getVariable ["R3F_LOG_est_transporte_par", objNull]) &&
			_objet_pas_en_cours_de_deplacement &&
			{
				_objet_pointe distance _x < 20 && !(_x getVariable "R3F_LOG_CF_disabled") &&
				_x getVariable ["R3F_LOG_CF_side_addAction", side group _joueur] == side group _joueur
			} count R3F_LOG_CF_liste_usines != 0;
		
		// Condition déverrouiller objet
		R3F_LOG_action_deverrouiller_valide = _objet_pas_en_cours_de_deplacement && !_objet_deverrouille && !(_objet_pointe getVariable "R3F_LOG_disabled");
	}
	else
	{
		R3F_LOG_action_deplacer_objet_valide = false;
		R3F_LOG_action_remorquer_direct_valide = false;
		R3F_LOG_action_detacher_valide = false;
		R3F_LOG_action_selectionner_objet_charge_valide = false;
		R3F_LOG_action_remorquer_deplace_valide = false;
		R3F_LOG_action_charger_deplace_valide = false;
		R3F_LOG_action_charger_selection_valide = false;
		R3F_LOG_action_contenu_vehicule_valide = false;
		R3F_LOG_action_ouvrir_usine_valide = false;
		R3F_LOG_action_selectionner_objet_revendre_usine_valide = false;
		R3F_LOG_action_revendre_usine_direct_valide = false;
		R3F_LOG_action_revendre_usine_deplace_valide = false;
		R3F_LOG_action_revendre_usine_selection_valide = false;
		R3F_LOG_action_deverrouiller_valide = false;
	};
	
	// Si le joueur est pilote dans un héliporteur
	if (call compile R3F_LOG_CFG_string_condition_allow_logistics_on_this_client &&
		!R3F_LOG_mutex_local_verrou && _vehicule_joueur != _joueur && driver _vehicule_joueur == _joueur && {_vehicule_joueur getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select __can_lift}
	) then
	{
		R3F_LOG_objet_addAction = _vehicule_joueur;
		
		// Note : pas de restriction liée à R3F_LOG_proprietaire_verrou pour l'héliportage
		
		// A partir des versions > 1.32, on interdit le lift si le hook de BIS est utilisé
		if (productVersion select 2 > 132) then
		{
			// Call compile car la commande getSlingLoad n'existe pas en 1.32
			_pas_de_hook = _vehicule_joueur call compile format ["isNull getSlingLoad _this"];
		}
		else
		{
			_pas_de_hook = true;
		};
		
		// Condition action heliporter
		R3F_LOG_action_heliporter_valide = !(_vehicule_joueur getVariable "R3F_LOG_disabled") && _pas_de_hook &&
			isNull (_vehicule_joueur getVariable "R3F_LOG_heliporte") && (vectorMagnitude velocity _vehicule_joueur < 6) &&
			{
				{
					(_x getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select __can_be_lifted) &&
					_x != _vehicule_joueur && !(_x getVariable "R3F_LOG_disabled") &&
					((getPosASL _vehicule_joueur select 2) - (getPosASL _x select 2) > 2 && (getPosASL _vehicule_joueur select 2) - (getPosASL _x select 2) < 15)
				} count (nearestObjects [_vehicule_joueur, ["All"], 15]) != 0
			};
		
		// Condition action heliport_larguer
		R3F_LOG_action_heliport_larguer_valide = !isNull (_vehicule_joueur getVariable "R3F_LOG_heliporte") && !(_vehicule_joueur getVariable "R3F_LOG_disabled") &&
			(vectorMagnitude velocity _vehicule_joueur < 25) && ((getPosASL _vehicule_joueur select 2) - (0 max getTerrainHeightASL getPos _vehicule_joueur) >= 0);
	}
	else
	{
		R3F_LOG_action_heliporter_valide = false;
		R3F_LOG_action_heliport_larguer_valide = false;
	};
	
	sleep 0.4;
};