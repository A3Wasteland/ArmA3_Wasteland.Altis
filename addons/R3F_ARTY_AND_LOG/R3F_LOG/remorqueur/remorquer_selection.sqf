/**
 * Remorque l'objet sélectionné (R3F_LOG_objet_selectionne) à un véhicule
 * 
 * @param 0 le remorqueur
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
	
	private ["_objet", "_remorqueur"];
	
	_objet = R3F_LOG_objet_selectionne;
	_remorqueur = _this select 0;
	
	if (!(isNull _objet) && (alive _objet) && !(_objet getVariable "R3F_LOG_disabled")) then
	{
		if (isNull (_objet getVariable "R3F_LOG_est_transporte_par") && (isNull (_objet getVariable "R3F_LOG_est_deplace_par") || (!alive (_objet getVariable "R3F_LOG_est_deplace_par")))) then
		{
			if (_objet distance _remorqueur <= 30) then
			{
             	//The vehicle that is driving.   
                _tempobj = _remorqueur;		_countTransportedBy = 1;
				while{!isNull(_tempobj getVariable["R3F_LOG_est_transporte_par", objNull])} do {_countTransportedBy = _countTransportedBy + 1; _tempobj = _tempobj getVariable["R3F_LOG_est_transporte_par", objNull];};
				
                //The vehicle that is being towed.
				_tempobj = _objet;		_countTowedVehicles = 1;
				while{!isNull(_tempobj getVariable["R3F_LOG_remorque", objNull])} do {_countTowedVehicles = _countTowedVehicles + 1; _tempobj = _tempobj getVariable["R3F_LOG_remorque", objNull];};
                
                if(_countTransportedBy + _countTowedVehicles <= 2) then
                {
                	// On mémorise sur le réseau que le véhicule remorque quelque chose
					_remorqueur setVariable ["R3F_LOG_remorque", _objet, true];
					// On mémorise aussi sur le réseau que le canon est attaché en remorque
					_objet setVariable ["R3F_LOG_est_transporte_par", _remorqueur, true];
					
					// On place le joueur sur le côté du véhicule, ce qui permet d'éviter les blessure et rend l'animation plus réaliste
					player attachTo [_remorqueur, [
						(boundingBox _remorqueur select 1 select 0),
						(boundingBox _remorqueur select 0 select 1) + 1,
						(boundingBox _remorqueur select 0 select 2) - (boundingBox player select 0 select 2)
					]];
					
					player setDir 270;
					player setPos (getPos player);
					
					player playMove "AinvPknlMstpSlayWrflDnon_medic";
					sleep 2;
					
					// Attacher à l'arrière du véhicule au ras du sol
					_objet attachTo [_remorqueur, [
						0,
						(boundingBox _remorqueur select 0 select 1) + (boundingBox _objet select 0 select 1) + 3,
						(boundingBox _remorqueur select 0 select 2) - (boundingBox _objet select 0 select 2)
					]];
					
					R3F_LOG_objet_selectionne = objNull;
					
					detach player;
					
					// Si l'objet est une arme statique, on corrige l'orientation en fonction de la direction du canon
					if (_objet isKindOf "StaticWeapon") then
					{
						private ["_azimut_canon"];
						
						_azimut_canon = ((_objet weaponDirection (weapons _objet select 0)) select 0) atan2 ((_objet weaponDirection (weapons _objet select 0)) select 1);
						
						// Seul le D30 a le canon pointant vers le véhicule
						if !(_objet isKindOf "D30_Base") then
						{
							_azimut_canon = _azimut_canon + 180;
						};
						
						// On est obligé de demander au serveur de tourner l'objet pour nous
						R3F_ARTY_AND_LOG_PUBVAR_setDir = [_objet, (getDir _objet)-_azimut_canon];
						if (isServer) then
						{
							["R3F_ARTY_AND_LOG_PUBVAR_setDir", R3F_ARTY_AND_LOG_PUBVAR_setDir] spawn R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir;
						}
						else
						{
							publicVariable "R3F_ARTY_AND_LOG_PUBVAR_setDir";
						};
					};
					
					sleep 5;    
                } else {
                	player globalChat "You can't tow more than one vehicle.";    
                };
			}
			else
			{
				player globalChat format [STR_R3F_LOG_action_remorquer_selection_trop_loin, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
			};
		}
		else
		{
			player globalChat format [STR_R3F_LOG_action_remorquer_selection_objet_transporte, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};