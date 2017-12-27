/**
 * Charger l'objet sélectionné (R3F_LOG_objet_selectionne) dans un transporteur
 *
 * @param 0 le transporteur
 *
 * Copyright (C) 2010 madbull ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#define VEHICLE_UNLOCKED(VEH) (locked (VEH) < 2 || (VEH) getVariable ["ownerUID","0"] isEqualTo getPlayerUID player)

if (R3F_LOG_mutex_local_verrou) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;

	private ["_objet", "_classes_transporteurs", "_transporteur", "_i"];

	_objet = R3F_LOG_objet_selectionne;
	_transporteur = _this select 0;

	if (!(isNull _objet) && VEHICLE_UNLOCKED(_objet) && !(_objet getVariable "R3F_LOG_disabled")) then
	{
		if (isNull (_objet getVariable "R3F_LOG_est_transporte_par") && (isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par")))) then
		{
			private ["_objets_charges", "_chargement_actuel", "_cout_capacite_objet", "_chargement_maxi"];

			_objets_charges = _transporteur getVariable "R3F_LOG_objets_charges";

			// Calcul du chargement actuel
			_chargement_actuel = 0;
			{
				for [{_i = 0}, {_i < count R3F_LOG_CFG_objets_transportables}, {_i = _i + 1}] do
				{
					if (_x isKindOf (R3F_LOG_CFG_objets_transportables select _i select 0)) exitWith
					{
						_chargement_actuel = _chargement_actuel + (R3F_LOG_CFG_objets_transportables select _i select 1);
					};
				};
			} forEach _objets_charges;

			// Recherche de la capacité de l'objet
			_cout_capacite_objet = 99999;
			for [{_i = 0}, {_i < count R3F_LOG_CFG_objets_transportables}, {_i = _i + 1}] do
			{
				if (_objet isKindOf (R3F_LOG_CFG_objets_transportables select _i select 0)) exitWith
				{
					_cout_capacite_objet = (R3F_LOG_CFG_objets_transportables select _i select 1);
				};
			};

			// Recherche de la capacité maximale du transporteur
			_chargement_maxi = 0;
			for [{_i = 0}, {_i < count R3F_LOG_CFG_transporteurs}, {_i = _i + 1}] do
			{
				if (_transporteur isKindOf (R3F_LOG_CFG_transporteurs select _i select 0)) exitWith
				{
					_chargement_maxi = (R3F_LOG_CFG_transporteurs select _i select 1);
				};
			};

			// Si l'objet loge dans le véhicule
			if (_chargement_actuel + _cout_capacite_objet <= _chargement_maxi) then
			{
				if (_objet distance _transporteur <= 30) then
				{
					// On mémorise sur le réseau le nouveau contenu du véhicule
					_objets_charges = _objets_charges + [_objet];
					_transporteur setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
					_objet setVariable ["R3F_LOG_est_transporte_par", _transporteur, true];

					player globalChat STR_R3F_LOG_action_charger_selection_en_cours;

					sleep 2;

					// Choisir une position dégagée (sphère de 50m de rayon) dans le ciel dans un cube de 9km^3
					private ["_nb_tirage_pos", "_position_attache"];
					_position_attache = [random 3000, random 3000, (10000 + (random 3000))];
					_nb_tirage_pos = 1;
					while {(!isNull (nearestObject _position_attache)) && (_nb_tirage_pos < 25)} do
					{
						_position_attache = [random 3000, random 3000, (10000 + (random 3000))];
						_nb_tirage_pos = _nb_tirage_pos + 1;
					};

					[R3F_LOG_PUBVAR_point_attache, true] call fn_enableSimulationGlobal;
					[_objet, true] call fn_enableSimulationGlobal;
					_objet attachTo [R3F_LOG_PUBVAR_point_attache, _position_attache];

					R3F_LOG_objet_selectionne = objNull;

					player globalChat format [STR_R3F_LOG_action_charger_selection_fait, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
				}
				else
				{
					player globalChat format [STR_R3F_LOG_action_charger_selection_trop_loin, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
				};
			}
			else
			{
				player globalChat format [STR_R3F_LOG_action_charger_selection_pas_assez_de_place, (_chargement_maxi - _chargement_actuel), _cout_capacite_objet];
			};
		}
		else
		{
			player globalChat format [STR_R3F_LOG_action_charger_selection_objet_transporte, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		};
	};

	R3F_LOG_mutex_local_verrou = false;
};
