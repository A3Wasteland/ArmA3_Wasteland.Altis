/**
 * Décharger un objet d'un transporteur - appelé deuis l'interface listant le contenu du transporteur
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
	
	#include "dlg_constantes.h"
	private ["_transporteur", "_objets_charges", "_type_objet_a_decharger", "_objet_a_decharger", "_action_confirmee", "_est_deplacable"];
	
	_transporteur = uiNamespace getVariable "R3F_LOG_dlg_CV_transporteur";
	_objets_charges = _transporteur getVariable ["R3F_LOG_objets_charges", []];
	
	if (lbCurSel R3F_LOG_IDC_dlg_CV_liste_contenu == -1) exitWith {R3F_LOG_mutex_local_verrou = false;};
	
	_type_objet_a_decharger = lbData [R3F_LOG_IDC_dlg_CV_liste_contenu, lbCurSel R3F_LOG_IDC_dlg_CV_liste_contenu];
	
	_est_deplacable = ([_type_objet_a_decharger] call R3F_LOG_FNCT_determiner_fonctionnalites_logistique) select R3F_LOG_IDX_can_be_moved_by_player;
	
	if (!(_type_objet_a_decharger isKindOf "AllVehicles") && !_est_deplacable) then
	{
		_action_confirmee = [STR_R3F_LOG_action_decharger_deplacable_exceptionnel, "Warning", true, true] call BIS_fnc_GUImessage;
	}
	else
	{
		_action_confirmee = true;
	};
	
	if (_action_confirmee) then
	{
		closeDialog 0;
		
		// Recherche d'un objet du type demandé
		_objet_a_decharger = objNull;
		{
			if (typeOf _x == _type_objet_a_decharger) exitWith
			{
				_objet_a_decharger = _x;
			};
		} forEach _objets_charges;
		
		if !(isNull _objet_a_decharger) then
		{
			[_objet_a_decharger, player] call R3F_LOG_FNCT_definir_proprietaire_verrou;
			
			// On mémorise sur le réseau le nouveau contenu du transporteur (càd avec cet objet en moins)
			_objets_charges = _transporteur getVariable ["R3F_LOG_objets_charges", []];
			_objets_charges = _objets_charges - [_objet_a_decharger];
			_transporteur setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
			
			_objet_a_decharger setVariable ["R3F_LOG_est_transporte_par", objNull, true];
			
			// Airdrop base addition
			_objet_a_decharger setVariable ["R3F_LOG_Disabled", false, true];
			
			// Prise en compte de l'objet dans l'environnement du joueur (accélérer le retour des addActions)
			_objet_a_decharger spawn
			{
				sleep 4;
				R3F_LOG_PUBVAR_reveler_au_joueur = _this;
				publicVariable "R3F_LOG_PUBVAR_reveler_au_joueur";
				["R3F_LOG_PUBVAR_reveler_au_joueur", R3F_LOG_PUBVAR_reveler_au_joueur] spawn R3F_LOG_FNCT_PUBVAR_reveler_au_joueur;
			};
			
			if (!(_objet_a_decharger isKindOf "AllVehicles") || _est_deplacable) then
			{
				R3F_LOG_mutex_local_verrou = false;
				[_objet_a_decharger, player, 0, true] spawn R3F_LOG_FNCT_objet_deplacer;
			}
			else
			{
				private ["_bbox_dim", "_pos_degagee", "_rayon"];
				
				systemChat STR_R3F_LOG_action_decharger_en_cours;
				
				_bbox_dim = (vectorMagnitude (boundingBoxReal _objet_a_decharger select 0)) max (vectorMagnitude (boundingBoxReal _objet_a_decharger select 1));
				
				sleep 1;
				
				// Recherche d'une position dégagée (on augmente progressivement le rayon jusqu'à trouver une position)
				for [{_rayon = 5 max (2*_bbox_dim); _pos_degagee = [];}, {count _pos_degagee == 0 && _rayon <= 30 + (8*_bbox_dim)}, {_rayon = _rayon + 10 + (2*_bbox_dim)}] do
				{
					_pos_degagee = [
						_bbox_dim,
						_transporteur modelToWorld [0, if (_transporteur isKindOf "AllVehicles") then {(boundingBoxReal _transporteur select 0 select 1) - 2 - 0.3*_rayon} else {0}, 0],
						_rayon,
						100 min (5 + _rayon^1.2)
					] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
				};
				
				if (count _pos_degagee > 0) then
				{
					detach _objet_a_decharger;
					_objet_a_decharger setPos _pos_degagee;
					_objet_a_decharger setVectorDirAndUp [[-cos getDir _transporteur, sin getDir _transporteur, 0] vectorCrossProduct surfaceNormal _pos_degagee, surfaceNormal _pos_degagee];
					_objet_a_decharger setVelocity [0, 0, 0];
					
					sleep 0.4; // Car la nouvelle position n'est pas prise en compte instantannément
					
					// Si l'objet a été créé assez loin, on indique sa position relative
					if (_objet_a_decharger distance _transporteur > 40) then
					{
						systemChat format [STR_R3F_LOG_action_decharger_fait + " (%2)",
							getText (configFile >> "CfgVehicles" >> (typeOf _objet_a_decharger) >> "displayName"),
							format ["%1m %2deg", round (_objet_a_decharger distance _transporteur), round ([_transporteur, _objet_a_decharger] call BIS_fnc_dirTo)]
						];
					}
					else
					{
						systemChat format [STR_R3F_LOG_action_decharger_fait, getText (configFile >> "CfgVehicles" >> (typeOf _objet_a_decharger) >> "displayName")];
					};
					R3F_LOG_mutex_local_verrou = false;
				}
				// Si échec recherche position dégagée, on décharge l'objet comme un déplaçable
				else
				{
					systemChat "WARNING : no free position found.";
					
					R3F_LOG_mutex_local_verrou = false;
					[_objet_a_decharger, player, 0, true] spawn R3F_LOG_FNCT_objet_deplacer;
				};
			};
		}
		else
		{
			hintC STR_R3F_LOG_action_decharger_deja_fait;
			R3F_LOG_mutex_local_verrou = false;
		};
	}
	else
	{
		R3F_LOG_mutex_local_verrou = false;
	};
};