/**
 * Charger automatiquement un ou plusieurs objets/noms de classe dans un transporteur
 * 
 * @param 0 le transporteur
 * @param 1 tableau d'objets et/ou noms de classe, pouvant être un mélange des formats suivants :
 *              objet
 *              nom de classe, dans ce cas, l'objet sera créé avant d'être chargé
 *              tableau ["nom de classe", quantité] à créer avant d'être chargé
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// Attendre le mutex
waitUntil
{
	if (R3F_LOG_mutex_local_verrou) then
	{
		false
	}
	else
	{
		R3F_LOG_mutex_local_verrou = true;
		true
	}
};

private ["_transporteur", "_liste_a_charger", "_chargement", "_chargement_actuel", "_chargement_maxi", "_objets_charges", "_cout_chargement_objet"];
private ["_objet_ou_classe", "_quantite", "_objet", "_classe", "_bbox", "_bbox_dim", "_pos_degagee", "_fonctionnalites", "_i"];

_transporteur = _this select 0;
_liste_a_charger = _this select 1;

_chargement = [_transporteur] call R3F_LOG_FNCT_calculer_chargement_vehicule;
_chargement_actuel = _chargement select 0;
_chargement_maxi = _chargement select 1;
_objets_charges = _transporteur getVariable ["R3F_LOG_objets_charges", []];

// Pour chaque élément de la liste à charger
{
	if (typeName _x == "ARRAY" && {count _x > 0}) then
	{
		_objet_ou_classe = _x select 0;
		
		if (typeName _objet_ou_classe == "STRING" && count _x > 1) then
		{
			_quantite = _x select 1;
		}
		else
		{
			_quantite = 1;
		};
	}
	else
	{
		_objet_ou_classe = _x;
		_quantite = 1;
	};
	
	if (typeName _objet_ou_classe == "STRING") then
	{
		_classe = _objet_ou_classe;
		_bbox = [_classe] call R3F_LOG_FNCT_3D_get_bounding_box_depuis_classname;
		_bbox_dim = (vectorMagnitude (_bbox select 0)) max (vectorMagnitude (_bbox select 1));
		
		// Recherche d'une position dégagée. Les véhicules doivent être créé au niveau du sol sinon ils ne peuvent être utilisés.
		if (_classe isKindOf "AllVehicles") then
		{
			_pos_degagee = [_bbox_dim, getPos _transporteur, 200, 50] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
		}
		else
		{
			_pos_degagee = [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel;
		};
		
		if (count _pos_degagee == 0) then {_pos_degagee = getPosATL _transporteur;};
	}
	else
	{
		_classe = typeOf _objet_ou_classe;
	};
	
	_fonctionnalites = [_classe] call R3F_LOG_FNCT_determiner_fonctionnalites_logistique;
	_cout_chargement_objet = _fonctionnalites select R3F_LOG_IDX_can_be_transported_cargo_cout;
	
	// S'assurer que le type d'objet à charger est transportable
	if !(_fonctionnalites select R3F_LOG_IDX_can_be_transported_cargo) then
	{
		diag_log format ["[Auto-load ""%1"" in ""%2""] : %3",
			getText (configFile >> "CfgVehicles" >> _classe >> "displayName"),
			getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName"),
			"The object is not a transporable class."];
		
		systemChat format ["[Auto-load ""%1"" in ""%2""] : %3",
			getText (configFile >> "CfgVehicles" >> _classe >> "displayName"),
			getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName"),
			"The object is not a transporable class."];
	}
	else
	{
		for [{_i = 0}, {_i < _quantite}, {_i = _i+1}] do
		{
			// Si l'objet à charger est donné en tant que nom de classe, on le crée
			if (typeName _objet_ou_classe == "STRING") then
			{
				// Recherche d'une position dégagée. Les véhicules doivent être créé au niveau du sol sinon ils ne peuvent être utilisés.
				if (_classe isKindOf "AllVehicles") then
				{
					_objet = _classe createVehicle _pos_degagee;
					_objet setVectorDirAndUp [[-cos getDir _transporteur, sin getDir _transporteur, 0] vectorCrossProduct surfaceNormal _pos_degagee, surfaceNormal _pos_degagee];
					_objet setVelocity [0, 0, 0];
					
					// Airdrop addition
					if (_transporteur isKindOf "Land_Pod_Heli_Transport_04_box_F" && {!(_objet isKindOf "ReammoBox_F")}) then // || _objet isKindOf "Land_InfoStand_V2_F")}) then
					{
						_objet setVariable ["allowDamage", true, true];
					};
				}
				else
				{
					_objet = _classe createVehicle _pos_degagee;
					
					// Airdrop addition
					if (_transporteur isKindOf "Land_Pod_Heli_Transport_04_box_F" && {!(_objet isKindOf "ReammoBox_F")}) then // || _objet isKindOf "Land_InfoStand_V2_F")}) then
					{
						_objet setVariable ["allowDamage", true, true];
					};
				};
			}
			else
			{
				_objet = _objet_ou_classe;
			};
			
			if (!isNull _objet) then
			{
				// Vérifier qu'il n'est pas déjà transporté
				if (isNull (_objet getVariable ["R3F_LOG_est_transporte_par", objNull]) &&
					(isNull (_objet getVariable ["R3F_LOG_est_deplace_par", objNull]) || (!alive (_objet getVariable ["R3F_LOG_est_deplace_par", objNull])) || (!isPlayer (_objet getVariable ["R3F_LOG_est_deplace_par", objNull])))
				) then
				{
					if (isNull (_objet getVariable ["R3F_LOG_remorque", objNull])) then
					{
						// Si l'objet loge dans le véhicule
						if (_chargement_actuel + _cout_chargement_objet <= _chargement_maxi) then
						{
							_chargement_actuel = _chargement_actuel + _cout_chargement_objet;
							_objets_charges pushBack _objet;
							
							_objet setVariable ["R3F_LOG_est_transporte_par", _transporteur, true];
							_objet attachTo [R3F_LOG_PUBVAR_point_attache, [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel];
						}
						else
						{
							diag_log format ["[Auto-load ""%1"" in ""%2""] : %3",
								getText (configFile >> "CfgVehicles" >> _classe >> "displayName"),
								getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName"),
								STR_R3F_LOG_action_charger_pas_assez_de_place];
							
							systemChat format ["[Auto-load ""%1"" in ""%2""] : %3",
								getText (configFile >> "CfgVehicles" >> _classe >> "displayName"),
								getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName"),
								STR_R3F_LOG_action_charger_pas_assez_de_place];
							
							if (typeName _objet_ou_classe == "STRING") then
							{
								deleteVehicle _objet;
							};
						};
					}
					else
					{
						diag_log format [STR_R3F_LOG_objet_remorque_en_cours, getText (configFile >> "CfgVehicles" >> _classe >> "displayName")];
						systemChat format [STR_R3F_LOG_objet_remorque_en_cours, getText (configFile >> "CfgVehicles" >> _classe >> "displayName")];
					};
				}
				else
				{
					diag_log format [STR_R3F_LOG_objet_en_cours_transport, getText (configFile >> "CfgVehicles" >> _classe >> "displayName")];
					systemChat format [STR_R3F_LOG_objet_en_cours_transport, getText (configFile >> "CfgVehicles" >> _classe >> "displayName")];
				};
			};
		};
	};
} forEach _liste_a_charger;

// On mémorise sur le réseau le nouveau contenu du véhicule
_transporteur setVariable ["R3F_LOG_objets_charges", _objets_charges, true];

R3F_LOG_mutex_local_verrou = false;