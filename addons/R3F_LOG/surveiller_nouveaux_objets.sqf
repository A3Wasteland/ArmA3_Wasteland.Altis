/**
 * Recherche périodiquement les nouveaux objets pour leur ajouter les fonctionnalités de logistique si besoin
 * Script à faire tourner dans un fil d'exécution dédié
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

sleep 4;

private
[
	"_compteur_cyclique", "_liste_nouveaux_objets", "_liste_vehicules_connus", "_liste_statiques", "_liste_nouveaux_statiques",
	"_liste_statiques_connus", 	"_liste_statiques_cycle_precedent", "_count_liste_objets", "_i", "_objet", "_fonctionnalites",
	"_liste_purge", "_seuil_nb_statiques_avant_purge", "_seuil_nb_vehicules_avant_purge"
];

// Contiendra la liste des objets déjà parcourus récupérés avec la commande "vehicles"
_liste_vehicules_connus = [];
// Contiendra la liste des objets dérivant de "Static" (caisse de mun, drapeau, ...) déjà parcourus récupérés avec la commande "nearestObjects"
_liste_statiques_connus = [];
// Contiendra la liste des objets "Static" récupérés lors du tour de boucle précécent (optimisation des opérations sur les tableaux)
_liste_statiques_cycle_precedent = [];

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

// Période de recherche des objets dérivant de "Static"
#define __tempo 3
// Utiliser la commande vehicles une fois tout les X cycles de période __tempo
#define __nb_cycles_commande_vehicles 4

_compteur_cyclique = 0;
_seuil_nb_statiques_avant_purge = 150;
_seuil_nb_vehicules_avant_purge = 150;

while {true} do
{
	if (!isNull player) then
	{
		// Tout les __nb_cycles_commande_vehicles ou sur ordre, on récupère les nouveaux véhicules du jeu
		if (_compteur_cyclique == 0 || R3F_LOG_PUBVAR_nouvel_objet_a_initialiser) then
		{
			R3F_LOG_PUBVAR_nouvel_objet_a_initialiser = false; // Acquittement local
			
			// Purge de _liste_vehicules_connus quand nécessaire
			if (count _liste_vehicules_connus > _seuil_nb_vehicules_avant_purge) then
			{
				_liste_purge = [];
				{
					if (!isNull _x) then
					{
						_liste_purge pushBack _x;
					};
				} forEach _liste_vehicules_connus;
				
				_liste_vehicules_connus = _liste_purge;
				_seuil_nb_vehicules_avant_purge = count _liste_vehicules_connus + 75;
			};
			
			// Purge de _liste_statiques_connus quand nécessaire
			if (count _liste_statiques_connus > _seuil_nb_statiques_avant_purge) then
			{
				_liste_purge = [];
				{
					if (!isNull _x &&
						{
							!isNil {_x getVariable "R3F_LOG_fonctionnalites"} ||
							(_x getVariable ["R3F_LOG_CF_depuis_usine", false])
						}
					) then
					{
						_liste_purge pushBack _x;
					};
				} forEach _liste_statiques_connus;
				
				_liste_statiques_connus = _liste_purge;
				_seuil_nb_statiques_avant_purge = count _liste_statiques_connus + 150;
			};
			
			// Récupération des nouveaux véhicules
			_liste_nouveaux_objets = vehicles - _liste_vehicules_connus;
			_liste_vehicules_connus = _liste_vehicules_connus + _liste_nouveaux_objets;
		}
		else
		{
			_liste_nouveaux_objets = [];
		};
		_compteur_cyclique = (_compteur_cyclique + 1) mod __nb_cycles_commande_vehicles;
		
		// En plus des nouveaux véhicules, on récupère les statiques (caisse de mun, drapeau, ...) proches du joueur non connus
		// Optimisation "_liste_statiques_cycle_precedent" : et qui n'étaient pas proches du joueur au cycle précédent
		_liste_statiques = nearestObjects [player, ["Static"], 25];
		if (count _liste_statiques != 0) then
		{
			_liste_nouveaux_statiques = _liste_statiques - _liste_statiques_cycle_precedent - _liste_statiques_connus;
			_liste_statiques_connus = _liste_statiques_connus + _liste_nouveaux_statiques;
			_liste_statiques_cycle_precedent = _liste_statiques;
		}
		else
		{
			_liste_nouveaux_statiques = [];
			_liste_statiques_cycle_precedent = [];
		};
		
		_liste_nouveaux_objets = _liste_nouveaux_objets + _liste_nouveaux_statiques;
		_count_liste_objets = count _liste_nouveaux_objets;
		
		if (_count_liste_objets > 0) then
		{
			// On parcoure tous les nouveaux objets en __tempo secondes
			for [{_i = 0}, {_i < _count_liste_objets}, {_i = _i + 1}] do
			{
				_objet = _liste_nouveaux_objets select _i;
				_fonctionnalites = [typeOf _objet] call R3F_LOG_FNCT_determiner_fonctionnalites_logistique;
				
				// Si au moins une fonctionnalité
				if (
					_fonctionnalites select __can_be_depl_heli_remorq_transp ||
					_fonctionnalites select __can_lift ||
					_fonctionnalites select __can_tow ||
					_fonctionnalites select __can_transport_cargo
				) then
				{
					_objet setVariable ["R3F_LOG_fonctionnalites", _fonctionnalites, false];
					
					if (isNil {_objet getVariable "R3F_LOG_disabled"}) then
					{
						_objet setVariable ["R3F_LOG_disabled", R3F_LOG_CFG_disabled_by_default, false];
					};
					
					// Si l'objet est un objet déplaçable/héliportable/remorquable/transportable
					if (_fonctionnalites select __can_be_depl_heli_remorq_transp) then
					{
						[_objet] call R3F_LOG_FNCT_objet_init;
					};
					
					// Si l'objet est un véhicule héliporteur
					if (_fonctionnalites select __can_lift) then
					{
						[_objet] call R3F_LOG_FNCT_heliporteur_init;
					};
					
					// Si l'objet est un véhicule remorqueur
					if (_fonctionnalites select __can_tow) then
					{
						[_objet] call R3F_LOG_FNCT_remorqueur_init;
					};
					
					// Si l'objet est un véhicule transporteur
					if (_fonctionnalites select __can_transport_cargo) then
					{
						[_objet] call R3F_LOG_FNCT_transporteur_init;
					};
				};
				
				// Si l'objet a été créé depuis une usine, on ajoute la possibilité de revendre à l'usine, quelque soit ses fonctionnalités logistiques
				if (_objet getVariable ["R3F_LOG_CF_depuis_usine", false]) then
				{
					_objet addAction [("<t color=""#ff9600"">" + format [STR_R3F_LOG_action_revendre_usine_direct, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")] + "</t>"), {_this call R3F_LOG_FNCT_usine_revendre_direct}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_verrou && R3F_LOG_objet_addAction == _target && R3F_LOG_action_revendre_usine_direct_valide"];
				};
				
				sleep (0.07 max (__tempo / _count_liste_objets));
			};
		}
		else
		{
			sleep __tempo;
		};
	}
	else
	{
		sleep 2;
	};
};