/**
 * Script principal qui initialise les systèmes d'artillerie réaliste et de logistique
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Nouveau fil d'exécution pour assurer une compatibilité ascendante (v1.0 à v1.2).
 * Ces versions préconisaient un #include plutôt que execVM pour appeler ce script.
 * A partir de la v1.3 l'exécution par execVM prend l'avantage pour 3 raisons :
 *     - permettre des appels conditionnels optimisés (ex : seulement pour des slots particuliers)
 *     - l'execVM est mieux connu et compris par l'éditeur de mission
 *     - l'init client de l'arty devient bloquant : il attend une PUBVAR du serveur (le point d'attache)
 */
[] spawn
{
	#include "config.sqf"
	#include "R3F_ARTY_disable_enable.sqf"
	#include "R3F_LOG_disable_enable.sqf"
	
	// Chargement du fichier de langage
	call compile preprocessFile format ["addons\R3F_ARTY_AND_LOG\%1_strings_lang.sqf", R3F_ARTY_AND_LOG_CFG_langage];
	
	if (isServer) then
	{
		// Service offert par le serveur : orienter un objet (car setDir est à argument local)
		R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir =
		{
			private ["_objet", "_direction"];
			_objet = _this select 1 select 0;
			_direction = _this select 1 select 1;
			
			// Orienter l'objet et broadcaster l'effet
			_objet setDir _direction;
			_objet setPos (getPos _objet);
		};
		"R3F_ARTY_AND_LOG_PUBVAR_setDir" addPublicVariableEventHandler R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir;
	};
	
	#ifdef R3F_ARTY_enable
		#include "R3F_ARTY\init.sqf"
		R3F_ARTY_active = true;
	#endif
	
	#ifdef R3F_LOG_enable
		#include "R3F_LOG\init.sqf"
		R3F_LOG_active = true;
	#else
		// Pour les actions du PC d'arti
		R3F_LOG_joueur_deplace_objet = objNull;
	#endif
	
	// Auto-détection permanente des objets sur le jeu
	if (isDedicated) then
	{
		// Version allégée pour le serveur dédié
		//execVM "addons\R3F_ARTY_AND_LOG\surveiller_nouveaux_objets_dedie.sqf";
	}
	else
	{
		execVM "addons\R3F_ARTY_AND_LOG\surveiller_nouveaux_objets.sqf";
		
		// Disable R3F on map objects that are not network-synced
		//{
		//	_x setVariable ["R3F_LOG_disabled", true];
		//} forEach ((nearestObjects [[0,0], R3F_LOG_CFG_objets_deplacables, 99999]) - (allMissionObjects "All"));
	};
};
