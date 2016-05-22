/**
* Vérifie périodiquement que les objets à protéger et ne pas perdre aient besoin d'être déchargés/téléportés.
* Script à faire tourner dans un fil d'exécution dédié sur le serveur.
* 
* Copyright (C) 2014 Team ~R3F~
* 
* This program is free software under the terms of the GNU General Public License version 3.
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

while {true} do
{
	// Pour chaque objet à protéger
	{
		private ["_objet", "_bbox_dim", "_pos_respawn", "_pos_degagee", "_rayon"];
		
		_objet = _x;
		
		if (!isNull _objet) then
		{
			// Si l'objet est transporté/héliporté/remorqué
			if !(isNull (_objet getVariable ["R3F_LOG_est_transporte_par", objNull])) then
			{
				// Mais que le transporteur est détruit/héliporté/remorqué
				if !(alive (_objet getVariable "R3F_LOG_est_transporte_par")) then
				{
					// Récupération de la position de respawn en accord avec le paramètre passé dans "do_not_lose_it"
					if (typeName (_objet getVariable "R3F_LOG_pos_respawn") == "ARRAY") then
					{
						_pos_respawn = _objet getVariable "R3F_LOG_pos_respawn";
					}
					else
					{
						if (_objet getVariable "R3F_LOG_pos_respawn" == "cargo_pos") then
						{
							_pos_respawn = getPos (_objet getVariable "R3F_LOG_est_transporte_par");
						}
						else
						{
							_pos_respawn = getMarkerPos (_objet getVariable "R3F_LOG_pos_respawn");
						};
					};
					
					_bbox_dim = (vectorMagnitude (boundingBoxReal _objet select 0)) max (vectorMagnitude (boundingBoxReal _objet select 1));
					
					// Si mode de respawn != "exact_spawn_pos"
					if (isNil {_objet getVariable "R3F_LOG_dir_respawn"}) then
					{
						// Recherche d'une position dégagée (on augmente progressivement le rayon jusqu'à trouver une position)
						for [{_rayon = 5 max (2*_bbox_dim); _pos_degagee = [];}, {count _pos_degagee == 0 && _rayon <= 100 + (8*_bbox_dim)}, {_rayon = _rayon + 20 + (5*_bbox_dim)}] do
						{
							_pos_degagee = [
								_bbox_dim,
								_pos_respawn,
								_rayon,
								100 min (5 + _rayon^1.2)
							] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
						};
						
						// En cas d'échec de la recherche de position dégagée
						if (count _pos_degagee == 0) then {_pos_degagee = _pos_respawn;};
						
						// On ramène l'objet sur la position
						detach _objet;
						_objet setPos _pos_degagee;
					}
					else
					{
						// On ramène l'objet sur la position
						detach _objet;
						_objet setPosASL _pos_respawn;
						_objet setDir (_objet getVariable "R3F_LOG_dir_respawn");
					};
					
					// On retire l'objet du contenu du véhicule (s'il est dedans)
					_objets_charges = (_objet getVariable "R3F_LOG_est_transporte_par") getVariable ["R3F_LOG_objets_charges", []];
					if (_objet in _objets_charges) then
					{
						_objets_charges = _objets_charges - [_objet];
						(_objet getVariable "R3F_LOG_est_transporte_par") setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
					};
					
					_objet setVariable ["R3F_LOG_est_transporte_par", objNull, true];
					
					sleep 4;
				};
			};
		};
	} forEach R3F_LOG_liste_objets_a_proteger;
	
	sleep 90;
};