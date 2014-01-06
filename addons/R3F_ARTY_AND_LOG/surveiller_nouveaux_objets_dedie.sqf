/**
 * Recherche périodiquement les nouveaux objets pour leur ajouter les fonctionnalités d'artillerie et de logistique si besoin
 * Script à faire tourner dans un fil d'exécution dédié
 * Version allégée pour un serveur dédié uniquement
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "R3F_ARTY_disable_enable.sqf"

// A l'heure actuelle ce fil d'exécution n'est utile que si l'artillerie est activée
#ifdef R3F_ARTY_enable

// Attente fin briefing
sleep 0.1;

private ["_liste_vehicules", "_count_liste_vehicules", "_i", "_objet"];

// Contiendra la liste des véhicules (et objets) déjà initialisés
_liste_vehicules_connus = [];

while {true} do
{
	// Récupération des tout les nouveaux véhicules de la carte SAUF les objets dérivant de "Static" non récupérable par "vehicles"
	_liste_vehicules = vehicles;
	_count_liste_vehicules = count _liste_vehicules;
	
	if (_count_liste_vehicules > 0) then
	{
		// On parcoure tout les véhicules présents dans le jeu en 18 secondes
		{
			if !(_objet getVariable ["R3F_LOG_init_dedie_done", false]) then
			{
				_objet = _x;
				
				//#ifdef R3F_ARTY_enable // Déjà présent plus haut dans la version actuelle
				// Si l'objet est un pièce d'artillerie d'un type à gérer
				if ({_objet isKindOf _x} count R3F_ARTY_CFG_pieces_artillerie > 0) then
				{
					[_objet] spawn R3F_ARTY_FNCT_piece_init_dedie;
				};
				//#endif
				
				_objet setVariable ["R3F_LOG_init_dedie_done", true];
			}
			
			sleep (18/_count_liste_vehicules);
		} forEach _liste_vehicules;
	}
	else
	{
		sleep 18;
	};
};

#endif