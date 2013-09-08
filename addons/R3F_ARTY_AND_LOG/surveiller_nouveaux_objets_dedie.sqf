/**
 * Recherche p�riodiquement les nouveaux objets pour leur ajouter les fonctionnalit�s d'artillerie et de logistique si besoin
 * Script � faire tourner dans un fil d'ex�cution d�di�
 * Version all�g�e pour un serveur d�di� uniquement
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "R3F_ARTY_disable_enable.sqf"

// A l'heure actuelle ce fil d'ex�cution n'est utile que si l'artillerie est activ�e
#ifdef R3F_ARTY_enable

// Attente fin briefing
sleep 0.1;

private ["_liste_vehicules_connus", "_liste_vehicules", "_count_liste_vehicules", "_i", "_objet"];

// Contiendra la liste des v�hicules (et objets) d�j� initialis�s
_liste_vehicules_connus = [];

while {true} do
{
	// R�cup�ration des tout les nouveaux v�hicules de la carte SAUF les objets d�rivant de "Static" non r�cup�rable par "vehicles"
	_liste_vehicules = vehicles - _liste_vehicules_connus;
	_count_liste_vehicules = count _liste_vehicules;
	
	if (_count_liste_vehicules > 0) then
	{
		// On parcoure tout les v�hicules pr�sents dans le jeu en 18 secondes
		for [{_i = 0}, {_i < _count_liste_vehicules}, {_i = _i + 1}] do
		{
			_objet = _liste_vehicules select _i;
			
			//#ifdef R3F_ARTY_enable // D�j� pr�sent plus haut dans la version actuelle
			// Si l'objet est un pi�ce d'artillerie d'un type � g�rer
			if ({_objet isKindOf _x} count R3F_ARTY_CFG_pieces_artillerie > 0) then
			{
				[_objet] spawn R3F_ARTY_FNCT_piece_init_dedie;
			};
			//#endif
			
			sleep (18/_count_liste_vehicules);
		};
		
		// Les objets ont �t� initialis�s, on les m�morise pour ne plus les r�-initialiser
		_liste_vehicules_connus = _liste_vehicules_connus + _liste_vehicules;
	}
	else
	{
		sleep 18;
	};
};

#endif