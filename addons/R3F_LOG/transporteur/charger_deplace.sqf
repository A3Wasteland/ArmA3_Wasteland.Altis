/**
 * Charger l'objet déplacé par le joueur dans un transporteur
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (R3F_LOG_mutex_local_verrou) then
{
	hintC STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	private ["_objet", "_transporteur"];
	
	_objet = R3F_LOG_joueur_deplace_objet;
	_transporteur = [_objet, 5] call R3F_LOG_FNCT_3D_cursorTarget_virtuel;
	
	if (!isNull _transporteur && {
		_transporteur getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select R3F_LOG_IDX_can_transport_cargo &&
		alive _transporteur && (vectorMagnitude velocity _transporteur < 6) && !(_transporteur getVariable "R3F_LOG_disabled") &&
		(abs ((getPosASL _transporteur select 2) - (getPosASL player select 2)) < 2.5)
	}) then
	{
		if (isNull (_objet getVariable ["R3F_LOG_remorque", objNull])) then
		{
			private ["_objets_charges", "_chargement", "_cout_chargement_objet"];
			
			_chargement = [_transporteur] call R3F_LOG_FNCT_calculer_chargement_vehicule;
			_cout_chargement_objet = _objet getVariable "R3F_LOG_fonctionnalites" select R3F_LOG_IDX_can_be_transported_cargo_cout;
			
			// Si l'objet loge dans le véhicule
			if ((_chargement select 0) + _cout_chargement_objet <= (_chargement select 1)) then
			{
				[_transporteur, player] call R3F_LOG_FNCT_definir_proprietaire_verrou;
				
				// On mémorise sur le réseau le nouveau contenu du véhicule
				_objets_charges = _transporteur getVariable ["R3F_LOG_objets_charges", []];
				_objets_charges = _objets_charges + [_objet];
				_transporteur setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
				
				_objet setVariable ["R3F_LOG_est_transporte_par", _transporteur, true];
				
				// Faire relacher l'objet au joueur
				R3F_LOG_joueur_deplace_objet = objNull;
				waitUntil {_objet getVariable "R3F_LOG_est_deplace_par" != player};
				
				_objet attachTo [R3F_LOG_PUBVAR_point_attache, [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel];
				
				systemChat format [STR_R3F_LOG_action_charger_fait,
					getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName"),
					getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName")];
			}
			else
			{
				hintC STR_R3F_LOG_action_charger_pas_assez_de_place;
			};
		}
		else
		{
			hintC format [STR_R3F_LOG_objet_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};