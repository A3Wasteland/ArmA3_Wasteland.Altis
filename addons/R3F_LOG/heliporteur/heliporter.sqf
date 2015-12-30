/**
 * Héliporte un objet avec un héliporteur
 * 
 * @param 0 l'héliporteur
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
	
	private ["_heliporteur", "_objet"];
	
	_heliporteur = _this select 0;
	
	// Recherche de l'objet à héliporter
	_objet = objNull;
	{
		if (
			(_x getVariable ["R3F_LOG_fonctionnalites", R3F_LOG_CST_zero_log] select R3F_LOG_IDX_can_be_lifted) &&
			_x != _heliporteur && !(_x getVariable "R3F_LOG_disabled") &&
			((getPosASL _heliporteur select 2) - (getPosASL _x select 2) > 2 && (getPosASL _heliporteur select 2) - (getPosASL _x select 2) < 15)
		) exitWith {_objet = _x;};
	} forEach (nearestObjects [_heliporteur, ["All"], 20]);
	
	if (!isNull _objet) then
	{
		if !(_objet getVariable "R3F_LOG_disabled") then
		{
			if (isNull (_objet getVariable "R3F_LOG_est_transporte_par") && (isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par")) || (!isPlayer (_objet getVariable "R3F_LOG_est_deplace_par")))) then
			{
				// Finalement on autorise l'héliport d'un véhicule avec du personnel à bord
				//if (count crew _objet == 0 || getNumber (configFile >> "CfgVehicles" >> (typeOf _objet) >> "isUav") == 1) then
				//{
					// Ne pas héliporter quelque chose qui remorque autre chose
					if (isNull (_objet getVariable ["R3F_LOG_remorque", objNull])) then
					{
						private ["_duree", "_ctrl_titre", "_ctrl_fond", "_ctrl_jauge", "_time_debut", "_attente_valide", "_pas_de_hook"];
						
						_duree = 0;
						
						#define _JAUGE_Y 0.7
						#define _JAUGE_W 0.4
						#define _JAUGE_H 0.025
						
						disableSerialization;
						
						_time_debut = time;
						_attente_valide = true;
						
						while {_attente_valide && time - _time_debut < _duree} do
						{
							//_ctrl_titre ctrlSetText format [STR_R3F_LOG_action_heliport_attente, ceil (_duree - (time - _time_debut))];
							
							// A partir des versions > 1.32, on interdit le lift si le hook de BIS est utilisé
							if (productVersion select 2 > 132) then
							{
								// Call compile car la commande getSlingLoad n'existe pas en 1.32
								_pas_de_hook = _heliporteur call compile format ["isNull getSlingLoad _this"];
							}
							else
							{
								_pas_de_hook = true;
							};
							
							// Pour valider l'héliportage, il faut rester en stationnaire au dessus de l'objet pendant le compte-à-rebours
							if !(
								alive player && vehicle player == _heliporteur && !(_heliporteur getVariable "R3F_LOG_disabled") && _pas_de_hook &&
								isNull (_heliporteur getVariable "R3F_LOG_heliporte") && (vectorMagnitude velocity _heliporteur < 6) && (_heliporteur distance _objet < 15) &&
								!(_objet getVariable "R3F_LOG_disabled") && isNull (_objet getVariable "R3F_LOG_est_transporte_par") &&
								(isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par")) || (!isPlayer (_objet getVariable "R3F_LOG_est_deplace_par"))) &&
								((getPosASL _heliporteur select 2) - (getPosASL _objet select 2) > 2 && (getPosASL _heliporteur select 2) - (getPosASL _objet select 2) < 15)
							) then
							{
								_attente_valide = false;
							};
							
							sleep 0.1;
						};
						
						// On effecture l'héliportage
						if (_attente_valide) then
						{
							_heliporteur setVariable ["R3F_LOG_heliporte", _objet, true];
							_objet setVariable ["R3F_LOG_est_transporte_par", _heliporteur, true];
							
							_heliBB = _heliporteur call fn_boundingBoxReal;
							_heliMinBB = _heliBB select 0;
							_heliMaxBB = _heliBB select 1;

							_objectBB = _objet call fn_boundingBoxReal;
							_objectMinBB = _objectBB select 0;
							_objectMaxBB = _objectBB select 1;

							_objectCenterX = (_objectMinBB select 0) + (((_objectMaxBB select 0) - (_objectMinBB select 0)) / 2);
							_objectCenterY = (_objectMinBB select 1) + (((_objectMaxBB select 1) - (_objectMinBB select 1)) / 2);

							_heliPos = _heliporteur modelToWorld [0,0,0];
							_objectPos = _objet modelToWorld [0,0,0];

							_minZ = (_heliMinBB select 2) - (_objectMaxBB select 2) - 0.5;

							// Attacher sous l'héliporteur au ras du sol
							[_objet, true] call fn_enableSimulationGlobal;
							_objet attachTo [_heliporteur,
							[
								0 - _objectCenterX,
								0 - _objectCenterY,
								((_objectPos select 2) - (_heliPos select 2) + 2) min _minZ
							]];
							
							systemChat format [STR_R3F_LOG_action_heliporter_fait, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
							
							// Boucle de contrôle pendant l'héliportage
							[_heliporteur, _objet] spawn
							{
								private ["_heliporteur", "_objet", "_a_ete_souleve"];
								
								_heliporteur = _this select 0;
								_objet = _this select 1;
								
								_a_ete_souleve = false;
								
								while {_heliporteur getVariable "R3F_LOG_heliporte" == _objet} do
								{
									// Mémoriser si l'objet a déjà été soulevé (cables tendus)
									if (!_a_ete_souleve && getPos _objet select 2 > 3) then
									{
										_a_ete_souleve = true;
									};
									
									// Si l'hélico se fait détruire ou si l'objet héliporté entre en contact avec le sol, on largue l'objet
									if (!alive _heliporteur || (_a_ete_souleve && getPos _objet select 2 < 0)) exitWith
									{
										_heliporteur setVariable ["R3F_LOG_heliporte", objNull, true];
										_objet setVariable ["R3F_LOG_est_transporte_par", objNull, true];
										
										// Détacher l'objet et lui appliquer la vitesse de l'héliporteur (inertie)
										[_objet, "detachSetVelocity", velocity _heliporteur] call R3F_LOG_FNCT_exec_commande_MP;
										
										systemChat format [STR_R3F_LOG_action_heliport_larguer_fait, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
									};
									
									sleep 0.1;
								};
							};
						}
						else
						{
							systemChat STR_R3F_LOG_action_heliport_echec_attente;
						};
					}
					else
					{
						systemChat format [STR_R3F_LOG_objet_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
					};
			}
			else
			{
				systemChat format [STR_R3F_LOG_objet_en_cours_transport, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
			};
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};