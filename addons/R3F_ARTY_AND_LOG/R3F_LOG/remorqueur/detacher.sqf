/**
 * Détacher un objet d'un véhicule
 * 
 * @param 0 l'objet à détacher
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
	
	private ["_remorqueur", "_objet"];
	
	_objet = _this select 0;
	_remorqueur = _objet getVariable "R3F_LOG_est_transporte_par";
	
	// Ne pas permettre de décrocher un objet s'il est porté héliporté
	if ({_remorqueur isKindOf _x} count R3F_LOG_CFG_remorqueurs > 0) then
	{
		player playMove "AinvPknlMstpSlayWrflDnon_medic";
		
		player addEventHandler ["AnimDone", 
		{
			if (_this select 1 == "AinvPknlMstpSlayWrflDnon_medic") then
			{
				player switchMove "";
				player removeAllEventHandlers "AnimDone";
			};
		}];
		
		if ((getPosASL player) select 2 > 0) then
		{
			player attachTo [_remorqueur, [
					(boundingBox _remorqueur select 1 select 0),
					(boundingBox _remorqueur select 0 select 1) + 1,
					(boundingBox _remorqueur select 0 select 2) - (boundingBox player select 0 select 2)
				]];
				
			player setDir 270;
			player setPos (getPos player);
			sleep 0.05;
			detach player;
		};
		
		sleep 2;
		
		// On mémorise sur le réseau que le véhicule remorque quelque chose
		_remorqueur setVariable ["R3F_LOG_remorque", objNull, true];
		// On mémorise aussi sur le réseau que le objet est attaché en remorque
		_objet setVariable ["R3F_LOG_est_transporte_par", objNull, true];
		
		if (_objet isKindOf "Car") then
		{
			detach _objet;
			_objet setVelocity [0,0,0.01];
		}
		else
		{
			if (local _objet) then
			{
				[netId _objet] execVM "server\functions\detachTowedObject.sqf";
			}
			else
			{
				requestDetachTowedObject = netId _objet;
				publicVariable "requestDetachTowedObject";
			};
		};
		
		sleep 4;
		
		if ({_objet isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
		{
			// Si personne n'a re-remorquer l'objet pendant le sleep 6
			if (isNull (_remorqueur getVariable "R3F_LOG_remorque") &&
				(isNull (_objet getVariable "R3F_LOG_est_transporte_par")) &&
				(isNull (_objet getVariable "R3F_LOG_est_deplace_par"))
			) then
			{
				[_objet] execVM "addons\R3F_ARTY_AND_LOG\R3F_LOG\objet_deplacable\deplacer.sqf";
			};
		}
		else
		{
			player globalChat STR_R3F_LOG_action_detacher_fait;
		};
	}
	else
	{
		player globalChat STR_R3F_LOG_action_detacher_impossible_pour_ce_vehicule;
	};
	
	R3F_LOG_mutex_local_verrou = false;
};