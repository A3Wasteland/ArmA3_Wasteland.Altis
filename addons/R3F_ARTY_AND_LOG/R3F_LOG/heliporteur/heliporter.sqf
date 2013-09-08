/**
 * Héliporte un objet avec un héliporteur
 * 
 * @param 0 l'héliporteur
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (R3F_LOG_mutex_local_verrou) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	private ["_heliporteur", "_objet"];
	
	_heliporteur = _this select 0;
	_objet = nearestObjects [_heliporteur, R3F_LOG_CFG_objets_heliportables, 20];
	// Parce que l'héliporteur peut être un objet héliportable
	_objet = _objet - [_heliporteur];
	
	if (count _objet > 0) then
	{
		_objet = _objet select 0;
		
		if !(_objet getVariable "R3F_LOG_disabled") then
		{
			if (isNull (_objet getVariable "R3F_LOG_est_transporte_par")) then
			{
				if (count crew _objet == 0) then
				{
					// Si l'objet n'est pas en train d'être déplacé par un joueur
					if (isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par"))) then
					{
						private ["_ne_remorque_pas", "_remorque"];
						// Ne pas héliporter quelque chose qui remorque autre chose
						_ne_remorque_pas = true;
						_remorque = _objet getVariable "R3F_LOG_remorque";
						if !(isNil "_remorque") then
						{
							if !(isNull _remorque) then
							{
								_ne_remorque_pas = false;
							};
						};
						
						if (_ne_remorque_pas) then
						{
							// On mémorise sur le réseau que l'héliporteur remorque quelque chose
							_heliporteur setVariable ["R3F_LOG_heliporte", _objet, true];
							// On mémorise aussi sur le réseau que l'objet est attaché à un véhicule
							_objet setVariable ["R3F_LOG_est_transporte_par", _heliporteur, true];
							
							// Attacher sous l'héliporteur au ras du sol
							_objet attachTo [_heliporteur, [
								0,
								0,
								(boundingBox _heliporteur select 0 select 2) - (boundingBox _objet select 0 select 2) - (getPos _heliporteur select 2) + 0.5
							]];
							
							player globalChat format [STR_R3F_LOG_action_heliporter_fait, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
						}
						else
						{
							player globalChat format [STR_R3F_LOG_action_heliporter_objet_remorque, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
						};
					}
					else
					{
						player globalChat format [STR_R3F_LOG_action_heliporter_deplace_par_joueur, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
					};
				}
				else
				{
					player globalChat format [STR_R3F_LOG_action_heliporter_joueur_dans_objet, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
				};
			}
			else
			{
				player globalChat format [STR_R3F_LOG_action_heliporter_deja_transporte, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
			};
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};