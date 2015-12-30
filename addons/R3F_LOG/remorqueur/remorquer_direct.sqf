/**
 * Remorque l'objet pointé au véhicule remorqueur valide le plus proche
 * 
 * @param 0 l'objet à remorquer
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
	
	private ["_objet", "_remorqueur", "_offset_attach_y"];
	
	_objet = _this select 0;
	
	// Recherche du remorqueur valide le plus proche
	_remorqueur = objNull;
	{
		if (
			_x != _objet && (_x getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select R3F_LOG_IDX_can_tow) &&
			alive _x && isNull (_x getVariable "R3F_LOG_est_transporte_par") &&
			isNull (_x getVariable "R3F_LOG_remorque") && (vectorMagnitude velocity _x < 6) &&
			!([_x, player] call R3F_LOG_FNCT_objet_est_verrouille) && !(_x getVariable "R3F_LOG_disabled") &&
			{
				private ["_delta_pos"];
				
				_delta_pos =
				(
					_objet modelToWorld
					[
						boundingCenter _objet select 0,
						boundingBoxReal _objet select 1 select 1,
						boundingBoxReal _objet select 0 select 2
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
		) exitWith {_remorqueur = _x;};
	} forEach (nearestObjects [_objet, ["All"], 30]);
	
	if (!isNull _remorqueur) then
	{
		if (isNull (_objet getVariable "R3F_LOG_est_transporte_par") && (isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par")) || (!isPlayer (_objet getVariable "R3F_LOG_est_deplace_par")))) then
		{
			[_remorqueur, player] call R3F_LOG_FNCT_definir_proprietaire_verrou;
			
			_remorqueur setVariable ["R3F_LOG_remorque", _objet, true];
			_objet setVariable ["R3F_LOG_est_transporte_par", _remorqueur, true];

			if (local _objet) then
			{
				["disableDriving", _objet] call A3W_fnc_towingHelper;
			}
			else
			{
				[["disableDriving", netId _objet], "A3W_fnc_towingHelper", _objet] call A3W_fnc_MP;
			};
					
			player switchMove "AinvPknlMstpSlayWrflDnon_medic";
			
			_towerBB = _remorqueur call fn_boundingBoxReal;
			_towerMinBB = _towerBB select 0;
			_towerMaxBB = _towerBB select 1;

			_objectBB = _objet call fn_boundingBoxReal;
			_objectMinBB = _objectBB select 0;
			_objectMaxBB = _objectBB select 1;

			_towerCenterX = (_towerMinBB select 0) + (((_towerMaxBB select 0) - (_towerMinBB select 0)) / 2);
			_objectCenterX = (_objectMinBB select 0) + (((_objectMaxBB select 0) - (_objectMinBB select 0)) / 2);
			
			_towerGroundPos = _remorqueur worldToModel (_remorqueur call fn_getPos3D);
			
			if ((getPosASL player) select 2 > 0) then
			{
				// On place le joueur sur le côté du véhicule, ce qui permet d'éviter les blessure et rend l'animation plus réaliste
				player attachTo [_remorqueur,
				[
					(_towerMinBB select 0) - 0.25,
					(_towerMinBB select 1) - 0.25,
					_towerMinBB select 2
				]];

				player setDir 90;
				player setPos (getPos player);
				sleep 0.05;
				detach player;
			};

			sleep 2;

			// Quelques corrections visuelles pour des classes spécifiques
			if (typeOf _remorqueur == "B_Truck_01_mover_F") then {_offset_attach_y = 1.0;}
			else {_offset_attach_y = 0.2;};
			
			// Attacher à l'arrière du véhicule au ras du sol
			_objet attachTo [_remorqueur,
			[
				_towerCenterX - _objectCenterX,
				(_towerMinBB select 1) - (_objectMaxBB select 1) - 0.5,
				(_towerGroundPos select 2) - (_objectMinBB select 2) + 0.1
			]];
			
			R3F_LOG_objet_selectionne = objNull;
			
			detach player;
			
			// Si l'objet est une arme statique, on corrige l'orientation en fonction de la direction du canon
			if (_objet isKindOf "StaticWeapon") then
			{
				private ["_azimut_canon"];
				
				_azimut_canon = ((_objet weaponDirection (weapons _objet select 0)) select 0) atan2 ((_objet weaponDirection (weapons _objet select 0)) select 1);
				
				// Seul le D30 a le canon pointant vers le véhicule
				if !(_objet isKindOf "D30_Base") then // All in Arma
				{
					_azimut_canon = _azimut_canon + 180;
				};
				
				[_objet, "setDir", (getDir _objet)-_azimut_canon] call R3F_LOG_FNCT_exec_commande_MP;
			};
			
			sleep 7;
		}
		else
		{
			hintC format [STR_R3F_LOG_objet_en_cours_transport, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};