/**
 * Fait déplacer un objet par le joueur. Il garde l'objet tant qu'il ne le relâche pas ou ne meurt pas.
 * L'objet est relaché quand la variable R3F_LOG_joueur_deplace_objet passe à objNull ce qui terminera le script
 * 
 * @param 0 l'objet à déplacer
 * @param 3 true si l'objet est chargé dans un véhicule
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
	
	R3F_LOG_objet_selectionne = objNull;
	
	private ["_objet", "_decharger", "_joueur", "_dir_joueur", "_arme_courante", "_muzzle_courant", "_mode_muzzle_courant", "_restaurer_arme"];
	private ["_vec_dir_rel", "_vec_dir_up", "_dernier_vec_dir_up", "_avant_dernier_vec_dir_up", "_normale_surface"];
	private ["_pos_rel_objet_initial", "_pos_rel_objet", "_dernier_pos_rel_objet", "_avant_dernier_pos_rel_objet"];
	private ["_elev_cam_initial", "_elev_cam", "_offset_hauteur_cam", "_offset_bounding_center", "_offset_hauteur_terrain"];
	private ["_offset_hauteur", "_dernier_offset_hauteur", "_avant_dernier_offset_hauteur"];
	private ["_hauteur_terrain_min_max_objet", "_offset_hauteur_terrain_min", "_offset_hauteur_terrain_max"];
	private ["_action_relacher", "_action_aligner_pente", "_action_aligner_sol", "_action_aligner_horizon", "_action_tourner", "_action_rapprocher"];
	private ["_idx_eh_fired", "_idx_eh_keyDown", "_idx_eh_keyUp", "_time_derniere_rotation", "_time_derniere_translation"];
	
	_objet = _this select 0;
	_decharger = if (count _this >= 4) then {_this select 3} else {false};
	_joueur = player;
	_dir_joueur = getDir _joueur;
	
		if(isNil {_objet getVariable "R3F_Side"}) then {
		_objet setVariable ["R3F_Side", (playerSide), true];
	};
	_tempVar = false;
	if(!isNil {_objet getVariable "R3F_Side"}) then {
		if(playerSide != (_objet getVariable "R3F_Side")) then {
			{if(side _x ==  (_objet getVariable "R3F_Side") && alive _x && _x distance _objet < 150) exitwith {_tempVar = true;};} foreach AllUnits;
		};
	};
	if(_tempVar) exitwith {
		hint format["This object belongs to %1 and they're nearby you cannot take this.", _objet getVariable "R3F_Side"]; R3F_LOG_mutex_local_verrou = false;
	};
	
	_objet setVariable ["R3F_Side", (playerSide), true];
	
	if (isNull (_objet getVariable ["R3F_LOG_est_transporte_par", objNull]) && (isNull (_objet getVariable ["R3F_LOG_est_deplace_par", objNull]) || (!alive (_objet getVariable ["R3F_LOG_est_deplace_par", objNull])) || (!isPlayer (_objet getVariable ["R3F_LOG_est_deplace_par", objNull])))) then
	{
		if (isNull (_objet getVariable ["R3F_LOG_remorque", objNull])) then
		{
			if (count crew _objet == 0 || getNumber (configFile >> "CfgVehicles" >> (typeOf _objet) >> "isUav") == 1) then
			{
				[_objet, _joueur] call R3F_LOG_FNCT_definir_proprietaire_verrou;
				
				_objet setVariable ["R3F_LOG_est_deplace_par", _joueur, true];
				
				_joueur forceWalk true;
				
				R3F_LOG_joueur_deplace_objet = _objet;
				
				if (_decharger) then
				{
					// Orienter l'objet en fonction de son profil
					if (((boundingBoxReal _objet select 1 select 1) - (boundingBoxReal _objet select 0 select 1)) != 0 && // Div par 0
						{
							((boundingBoxReal _objet select 1 select 0) - (boundingBoxReal _objet select 0 select 0)) > 3.2 &&
							((boundingBoxReal _objet select 1 select 0) - (boundingBoxReal _objet select 0 select 0)) /
							((boundingBoxReal _objet select 1 select 1) - (boundingBoxReal _objet select 0 select 1)) > 1.25
						}
					) then
					{R3F_LOG_deplace_dir_rel_objet = 90;} else {R3F_LOG_deplace_dir_rel_objet = 0;};
					
					// Calcul de la position relative, de sorte à éloigner l'objet suffisamment pour garder un bon champ de vision
					_pos_rel_objet_initial = [
						(boundingCenter _objet select 0) * cos R3F_LOG_deplace_dir_rel_objet - (boundingCenter _objet select 1) * sin R3F_LOG_deplace_dir_rel_objet,
						((-(boundingBoxReal _objet select 0 select 0) * sin R3F_LOG_deplace_dir_rel_objet) max (-(boundingBoxReal _objet select 1 select 0) * sin R3F_LOG_deplace_dir_rel_objet)) +
						((-(boundingBoxReal _objet select 0 select 1) * cos R3F_LOG_deplace_dir_rel_objet) max (-(boundingBoxReal _objet select 1 select 1) * cos R3F_LOG_deplace_dir_rel_objet)) +
						2 + 0.3 * (
							((boundingBoxReal _objet select 1 select 1)-(boundingBoxReal _objet select 0 select 1)) * abs sin R3F_LOG_deplace_dir_rel_objet +
							((boundingBoxReal _objet select 1 select 0)-(boundingBoxReal _objet select 0 select 0)) * abs cos R3F_LOG_deplace_dir_rel_objet
						),
						-(boundingBoxReal _objet select 0 select 2)
					];
					
					_elev_cam_initial = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));
					
					_pos_rel_objet_initial set [2, 0.1 + (_joueur selectionPosition "head" select 2) + (_pos_rel_objet_initial select 1) * tan (89 min (-89 max (90-_elev_cam_initial)))];
				}
				else
				{
					R3F_LOG_deplace_dir_rel_objet = (getDir _objet) - _dir_joueur;
					
					_pos_rel_objet_initial = _joueur worldToModel (_objet modelToWorld [0,0,0]);
					
					// Calcul de la position relative de l'objet, basée sur la position initiale, et sécurisée pour ne pas que l'objet rentre dans le joueur lors de la rotation
					// L'ajout de ce calcul a également rendu inutile le test avec la fonction R3F_LOG_FNCT_unite_marche_dessus lors de la prise de l'objet
					_pos_rel_objet_initial = [
						_pos_rel_objet_initial select 0,
						(_pos_rel_objet_initial select 1) max
						(
							((-(boundingBoxReal _objet select 0 select 0) * sin R3F_LOG_deplace_dir_rel_objet) max (-(boundingBoxReal _objet select 1 select 0) * sin R3F_LOG_deplace_dir_rel_objet)) +
							((-(boundingBoxReal _objet select 0 select 1) * cos R3F_LOG_deplace_dir_rel_objet) max (-(boundingBoxReal _objet select 1 select 1) * cos R3F_LOG_deplace_dir_rel_objet)) +
							1.2
						),
						_pos_rel_objet_initial select 2
					];
					
					_elev_cam_initial = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));
				};
				R3F_LOG_deplace_distance_rel_objet = _pos_rel_objet_initial select 1;
				
				// Détermination du mode d'alignement initial en fonction du type d'objet, de ses dimensions, ...
				R3F_LOG_deplace_mode_alignement = switch (true) do
				{
					case !(_objet isKindOf "Static"): {"sol"};
					// Objet statique allongé
					case (
							((boundingBoxReal _objet select 1 select 1) - (boundingBoxReal _objet select 0 select 1)) != 0 && // Div par 0
							{
								((boundingBoxReal _objet select 1 select 0) - (boundingBoxReal _objet select 0 select 0)) /
								((boundingBoxReal _objet select 1 select 1) - (boundingBoxReal _objet select 0 select 1)) > 1.75
							}
						): {"pente"};
					// Objet statique carré ou peu allongé
					default {"horizon"};
				};
				
				// On demande à ce que l'objet soit local au joueur pour réduire les latences (setDir, attachTo périodique)
				if (!local _objet) then
				{
					private ["_time_demande_setOwner"];
					_time_demande_setOwner = time;
					[_objet, "setOwnerTo", _joueur] call R3F_LOG_FNCT_exec_commande_MP;
					waitUntil {local _objet || time > _time_demande_setOwner + 1.5};
				};
				
				// On prévient tout le monde qu'un nouveau objet va être déplace pour ingorer les éventuelles blessures
				R3F_LOG_PV_nouvel_objet_en_deplacement = _objet;
				publicVariable "R3F_LOG_PV_nouvel_objet_en_deplacement";
				["R3F_LOG_PV_nouvel_objet_en_deplacement", R3F_LOG_PV_nouvel_objet_en_deplacement] call R3F_LOG_FNCT_PVEH_nouvel_objet_en_deplacement;
				
				// Mémorisation de l'arme courante et de son mode de tir
				_arme_courante = currentWeapon _joueur;
				_muzzle_courant = currentMuzzle _joueur;
				_mode_muzzle_courant = currentWeaponMode _joueur;
				
				// Sous l'eau on n'a pas le choix de l'arme
				if (!surfaceIsWater getPos _joueur) then
				{
					// Prise du PA si le joueur en a un
					if (handgunWeapon _joueur != "") then
					{
						_restaurer_arme = false;
						for [{_idx_muzzle = 0}, {currentWeapon _joueur != handgunWeapon _joueur}, {_idx_muzzle = _idx_muzzle+1}] do
						{
							_joueur action ["SWITCHWEAPON", _joueur, _joueur, _idx_muzzle];
						};
					}
					// Sinon pas d'arme dans les mains
					else
					{
						_restaurer_arme = true;
						_joueur action ["SWITCHWEAPON", _joueur, _joueur, 99999];
					};
				} else {_restaurer_arme = false;};
				
				sleep 0.5;
				
				// Vérification qu'on ai bien obtenu la main (conflit d'accès simultanés)
				if (_objet getVariable "R3F_LOG_est_deplace_par" == _joueur && isNull (_objet getVariable ["R3F_LOG_est_transporte_par", objNull])) then
				{
					R3F_LOG_deplace_force_setVector = false; // Mettre à true pour forcer la ré-otientation de l'objet, en forçant les filtres anti-flood
					R3F_LOG_deplace_force_attachTo = false; // Mettre à true pour forcer le repositionnement de l'objet, en forçant les filtres anti-flood
					
					// Ajout des actions de gestion de l'orientation
					_action_relacher = _joueur addAction [("<img image='client\icons\r3f_release.paa' color='#ee0000'/> <t color=""#ee0000"">" + format [STR_R3F_LOG_action_relacher_objet, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")] + "</t>"), {_this call R3F_LOG_FNCT_objet_relacher}, nil, 10, true, true];
					_action_aligner_pente = _joueur addAction [("<img image='client\icons\r3f_releaseh.paa' color='#00eeff'/> <t color=""#00eeff"">" + STR_R3F_LOG_action_aligner_pente + "</t>"), {R3F_LOG_deplace_mode_alignement = "pente"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""pente"""];
					_action_aligner_sol = _joueur addAction [("<img image='client\icons\r3f_releaseh.paa' color='#00eeff'/> <t color=""#00eeff"">" + STR_R3F_LOG_action_aligner_sol + "</t>"), {R3F_LOG_deplace_mode_alignement = "sol"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""sol"""];
					_action_aligner_horizon = _joueur addAction [("<img image='client\icons\r3f_releaseh.paa' color='#00eeff'/> <t color=""#00eeff"">" + STR_R3F_LOG_action_aligner_horizon + "</t>"), {R3F_LOG_deplace_mode_alignement = "horizon"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""horizon"""];
					_action_tourner = _joueur addAction [("<img image='client\icons\r3f_rotate.paa' color='#00eeff'/> <t color=""#00eeff"">" + STR_R3F_LOG_action_tourner + "</t>"), {R3F_LOG_deplace_dir_rel_objet = R3F_LOG_deplace_dir_rel_objet + 12; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, false];
					_action_rapprocher = _joueur addAction [("<img image='client\icons\r3f_rotate.paa' color='#00eeff'/> <t color=""#00eeff"">" + STR_R3F_LOG_action_rapprocher + "</t>"), {R3F_LOG_deplace_distance_rel_objet = R3F_LOG_deplace_distance_rel_objet - 0.4; R3F_LOG_deplace_force_attachTo = true;}, nil, 6, false, false];
					
					// Relâcher l'objet dès que le joueur tire. Le detach sert à rendre l'objet solide pour ne pas tirer au travers.
					_idx_eh_fired = _joueur addEventHandler ["Fired", {if (!surfaceIsWater getPos player) then {detach R3F_LOG_joueur_deplace_objet; R3F_LOG_joueur_deplace_objet = objNull;};}];
					
					// Gestion des évènements KeyDown et KeyUp pour faire tourner l'objet avec les touches X/C
					R3F_LOG_joueur_deplace_key_rotation = "";
					R3F_LOG_joueur_deplace_key_translation = "";
					_time_derniere_rotation = 0;
					_time_derniere_translation = 0;
					_idx_eh_keyDown = (findDisplay 46) displayAddEventHandler ["KeyDown",
					{
						switch (_this select 1) do
						{
							case 45: {R3F_LOG_joueur_deplace_key_rotation = "X"; true};
							case 46: {R3F_LOG_joueur_deplace_key_rotation = "C"; true};
							case 33: {R3F_LOG_joueur_deplace_key_translation = "F"; true};
							case 19: {R3F_LOG_joueur_deplace_key_translation = "R"; true};
							default {false};
						}
					}];
					_idx_eh_keyUp = (findDisplay 46) displayAddEventHandler ["KeyUp",
					{
						switch (_this select 1) do
						{
							case 45: {R3F_LOG_joueur_deplace_key_rotation = ""; true};
							case 46: {R3F_LOG_joueur_deplace_key_rotation = ""; true};
							case 33: {R3F_LOG_joueur_deplace_key_translation = ""; true};
							case 19: {R3F_LOG_joueur_deplace_key_translation = ""; true};
							default {false};
						}
					}];
					
					// Initialisation de l'historique anti-flood
					_offset_hauteur = _pos_rel_objet_initial select 2;
					_dernier_offset_hauteur = _offset_hauteur + 100;
					_avant_dernier_offset_hauteur = _dernier_offset_hauteur + 100;
					_dernier_pos_rel_objet = _pos_rel_objet_initial;
					_avant_dernier_pos_rel_objet = _dernier_pos_rel_objet;
					_vec_dir_rel = [sin R3F_LOG_deplace_dir_rel_objet, cos R3F_LOG_deplace_dir_rel_objet, 0];
					_vec_dir_up = [_vec_dir_rel, [0, 0, 1]];
					_dernier_vec_dir_up = [[0,0,0] vectorDiff (_vec_dir_up select 0), _vec_dir_up select 1];
					_avant_dernier_vec_dir_up = [_dernier_vec_dir_up select 0, [0,0,0] vectorDiff (_dernier_vec_dir_up select 1)];
					
					_objet attachTo [_joueur, _pos_rel_objet_initial];
					
					// Si échec transfert local, mode dégradé : on conserve la direction de l'objet par rapport au joueur
					if (!local _objet) then {[_objet, "setDir", R3F_LOG_deplace_dir_rel_objet] call R3F_LOG_FNCT_exec_commande_MP;};
					
					R3F_LOG_mutex_local_verrou = false;
					
					// Boucle de gestion des évènements et du positionnement pendant le déplacement
					while {!isNull R3F_LOG_joueur_deplace_objet && _objet getVariable "R3F_LOG_est_deplace_par" == _joueur && alive _joueur} do
					{
						// Gestion de l'orientation de l'objet en fonction du terrain
						if (local _objet) then
						{
							// En fonction de la touche appuyée (X/C), on fait pivoter l'objet
							if (R3F_LOG_joueur_deplace_key_rotation == "X" || R3F_LOG_joueur_deplace_key_rotation == "C") then
							{
								// Un cycle sur deux maxi (flood) on modifie de l'angle
								if (time - _time_derniere_rotation > 0.045) then
								{
									if (R3F_LOG_joueur_deplace_key_rotation == "X") then {R3F_LOG_deplace_dir_rel_objet = R3F_LOG_deplace_dir_rel_objet + 4;};
									if (R3F_LOG_joueur_deplace_key_rotation == "C") then {R3F_LOG_deplace_dir_rel_objet = R3F_LOG_deplace_dir_rel_objet - 4;};
									
									R3F_LOG_deplace_force_setVector = true;
									_time_derniere_rotation = time;
								};
							} else {_time_derniere_rotation = 0;};
							
							_vec_dir_rel = [sin R3F_LOG_deplace_dir_rel_objet, cos R3F_LOG_deplace_dir_rel_objet, 0];
							
							// Conversion de la normale du sol dans le repère du joueur car l'objet est attachTo
							_normale_surface = surfaceNormal getPos _objet;
							_normale_surface = (player worldToModel ASLtoATL (_normale_surface vectorAdd getPosASL player)) vectorDiff (player worldToModel ASLtoATL (getPosASL player));
							
							// Redéfinir l'orientation en fonction du terrain et du mode d'alignement
							_vec_dir_up = switch (R3F_LOG_deplace_mode_alignement) do
							{
								case "sol": {[[-cos R3F_LOG_deplace_dir_rel_objet, sin R3F_LOG_deplace_dir_rel_objet, 0] vectorCrossProduct _normale_surface, _normale_surface]};
								case "pente": {[_vec_dir_rel, _normale_surface]};
								default {[_vec_dir_rel, [0, 0, 1]]};
							};
							
							// On ré-oriente l'objet, lorsque nécessaire (pas de flood)
							if (R3F_LOG_deplace_force_setVector ||
								(
									// Vecteur dir suffisamment différent du dernier
									(_vec_dir_up select 0) vectorCos (_dernier_vec_dir_up select 0) < 0.999 &&
									// et différent de l'avant dernier (pas d'oscillations sans fin)
									vectorMagnitude ((_vec_dir_up select 0) vectorDiff (_avant_dernier_vec_dir_up select 0)) > 1E-9
								) ||
								(
									// Vecteur up suffisamment différent du dernier
									(_vec_dir_up select 1) vectorCos (_dernier_vec_dir_up select 1) < 0.999 &&
									// et différent de l'avant dernier (pas d'oscillations sans fin)
									vectorMagnitude ((_vec_dir_up select 1) vectorDiff (_avant_dernier_vec_dir_up select 1)) > 1E-9
								)
							) then
							{
								_objet setVectorDirAndUp _vec_dir_up;
								
								_avant_dernier_vec_dir_up = _dernier_vec_dir_up;
								_dernier_vec_dir_up = _vec_dir_up;
								
								R3F_LOG_deplace_force_setVector = false;
							};
						};
						
						sleep 0.015;
						
						// En fonction de la touche appuyée (F/R), on fait avancer ou reculer l'objet
						if (R3F_LOG_joueur_deplace_key_translation == "F" || R3F_LOG_joueur_deplace_key_translation == "R") then
						{
							// Un cycle sur deux maxi (flood) on modifie de l'angle
							if (time - _time_derniere_translation > 0.045) then
							{
								if (R3F_LOG_joueur_deplace_key_translation == "F") then
								{
									R3F_LOG_deplace_distance_rel_objet = R3F_LOG_deplace_distance_rel_objet - 0.075;
								}
								else
								{
									R3F_LOG_deplace_distance_rel_objet = R3F_LOG_deplace_distance_rel_objet + 0.075;
								};
								
								// Borne min-max de la distance
								R3F_LOG_deplace_distance_rel_objet = R3F_LOG_deplace_distance_rel_objet min (
										(
											vectorMagnitude [
												(-(boundingBoxReal _objet select 0 select 0)) max (boundingBoxReal _objet select 1 select 0),
												(-(boundingBoxReal _objet select 0 select 1)) max (boundingBoxReal _objet select 1 select 1),
												0
											] + 2
										) max (_pos_rel_objet_initial select 1)
								) max (
									(
										((-(boundingBoxReal _objet select 0 select 0) * sin R3F_LOG_deplace_dir_rel_objet) max (-(boundingBoxReal _objet select 1 select 0) * sin R3F_LOG_deplace_dir_rel_objet)) +
										((-(boundingBoxReal _objet select 0 select 1) * cos R3F_LOG_deplace_dir_rel_objet) max (-(boundingBoxReal _objet select 1 select 1) * cos R3F_LOG_deplace_dir_rel_objet)) +
										1.2
									)
								);
								
								R3F_LOG_deplace_force_attachTo = true;
								_time_derniere_translation = time;
							};
						} else {_time_derniere_translation = 0;};
						
						// Calcul de la position relative de l'objet, basée sur la position initiale, et sécurisée pour ne pas que l'objet rentre dans le joueur lors de la rotation
						// L'ajout de ce calcul a également rendu inutile le test avec la fonction R3F_LOG_FNCT_unite_marche_dessus lors de la prise de l'objet
						_pos_rel_objet = [
							_pos_rel_objet_initial select 0,
							R3F_LOG_deplace_distance_rel_objet max
							(
								((-(boundingBoxReal _objet select 0 select 0) * sin R3F_LOG_deplace_dir_rel_objet) max (-(boundingBoxReal _objet select 1 select 0) * sin R3F_LOG_deplace_dir_rel_objet)) +
								((-(boundingBoxReal _objet select 0 select 1) * cos R3F_LOG_deplace_dir_rel_objet) max (-(boundingBoxReal _objet select 1 select 1) * cos R3F_LOG_deplace_dir_rel_objet)) +
								1.2
							),
							_pos_rel_objet_initial select 2
						];
						
						_elev_cam = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));
						_offset_hauteur_cam = (vectorMagnitude [_pos_rel_objet select 0, _pos_rel_objet select 1, 0]) * tan (89 min (-89 max (_elev_cam_initial - _elev_cam)));
						_offset_bounding_center = ((_objet modelToWorld boundingCenter _objet) select 2) - ((_objet modelToWorld [0,0,0]) select 2);
						
						// Calcul de la hauteur de l'objet en fonction de l'élévation de la caméra et du terrain
						if (_objet isKindOf "Static") then
						{
							// En mode horizontal, la plage d'offset terrain est calculée de sorte à conserver au moins un des quatre coins inférieurs en contact avec le sol
							if (R3F_LOG_deplace_mode_alignement == "horizon") then
							{
								_hauteur_terrain_min_max_objet = [_objet] call R3F_LOG_FNCT_3D_get_hauteur_terrain_min_max_objet;
								_offset_hauteur_terrain_min = (_hauteur_terrain_min_max_objet select 0) - (getPosASL _joueur select 2) + _offset_bounding_center;
								_offset_hauteur_terrain_max = (_hauteur_terrain_min_max_objet select 1) - (getPosASL _joueur select 2) + _offset_bounding_center;
								
								// On autorise un léger enterrement jusqu'à 40% de la hauteur de l'objet
								_offset_hauteur_terrain_min = _offset_hauteur_terrain_min min (_offset_hauteur_terrain_max - 0.4 * ((boundingBoxReal _objet select 1 select 2) - (boundingBoxReal _objet select 0 select 2)) / (_dernier_vec_dir_up select 1 select 2));
							}
							// Dans les autres modes d'alignement, on autorise un léger enterrement jusqu'à 40% de la hauteur de l'objet
							else
							{
								_offset_hauteur_terrain_max = getTerrainHeightASL (getPos _objet) - (getPosASL _joueur select 2) + _offset_bounding_center;
								_offset_hauteur_terrain_min = _offset_hauteur_terrain_max - 0.4 * ((boundingBoxReal _objet select 1 select 2) - (boundingBoxReal _objet select 0 select 2)) / (_dernier_vec_dir_up select 1 select 2);
							};
							
							if (R3F_LOG_CFG_no_gravity_objects_can_be_set_in_height_over_ground) then
							{
								_offset_hauteur = _offset_hauteur_terrain_min max ((-1.4 + _offset_bounding_center) max ((2.75 + _offset_bounding_center) min ((_pos_rel_objet select 2) + _offset_hauteur_cam)));
							}
							else
							{
								_offset_hauteur = _offset_hauteur_terrain_min max (_offset_hauteur_terrain_max min ((_pos_rel_objet select 2) + _offset_hauteur_cam)) + (getPosATL _joueur select 2);
							};
						}
						else
						{
							_offset_hauteur_terrain = getTerrainHeightASL (getPos _objet) - (getPosASL _joueur select 2) + _offset_bounding_center;
							_offset_hauteur = _offset_hauteur_terrain max ((-1.4 + _offset_bounding_center) max ((2.75 + _offset_bounding_center) min ((_pos_rel_objet select 2) + _offset_hauteur_cam)));
						};
						
						// On repositionne l'objet par rapport au joueur, lorsque nécessaire (pas de flood)
						if (R3F_LOG_deplace_force_attachTo ||
							(
								// Positionnement en hauteur suffisamment différent
								abs (_offset_hauteur - _dernier_offset_hauteur) > 0.025 &&
								// et différent de l'avant dernier (pas d'oscillations sans fin)
								abs (_offset_hauteur - _avant_dernier_offset_hauteur) > 1E-9
							) ||
							(
								// Position relative suffisamment différente
								vectorMagnitude (_pos_rel_objet vectorDiff _dernier_pos_rel_objet) > 0.025 &&
								// et différente de l'avant dernier (pas d'oscillations sans fin)
								vectorMagnitude (_pos_rel_objet vectorDiff _avant_dernier_pos_rel_objet) > 1E-9
							)
						) then
						{
							_objet attachTo [_joueur, [
								_pos_rel_objet select 0,
								_pos_rel_objet select 1,
								_offset_hauteur
							]];
							
							_avant_dernier_offset_hauteur = _dernier_offset_hauteur;
							_dernier_offset_hauteur = _offset_hauteur;
							
							_avant_dernier_pos_rel_objet = _dernier_pos_rel_objet;
							_dernier_pos_rel_objet = _pos_rel_objet;
							
							R3F_LOG_deplace_force_attachTo = false;
						};
						
						// On interdit de monter dans un véhicule tant que l'objet est porté
						if (vehicle _joueur != _joueur) then
						{
							systemChat STR_R3F_LOG_ne_pas_monter_dans_vehicule;
							_joueur action ["GetOut", vehicle _joueur];
							_joueur action ["Eject", vehicle _joueur];
							sleep 1;
						};
						
						// Le joueur change d'arme, on stoppe le déplacement et on ne reprendra pas l'arme initiale
						if (currentWeapon _joueur != "" && currentWeapon _joueur != handgunWeapon _joueur && !surfaceIsWater getPos _joueur) then
						{
							R3F_LOG_joueur_deplace_objet = objNull;
							_restaurer_arme = false;
						};
						
						sleep 0.015;
					};
					
					// Si l'objet est relaché (et donc pas chargé dans un véhicule)
					if (isNull (_objet getVariable ["R3F_LOG_est_transporte_par", objNull])) then
					{
						// L'objet n'est plus porté, on le repose. Le léger setVelocity vers le haut sert à defreezer les objets qui pourraient flotter.
						// TODO gestion collision, en particulier si le joueur meurt
						[_objet, "detachSetVelocity", [0, 0, 0.1]] call R3F_LOG_FNCT_exec_commande_MP;
					};
					
					_joueur removeEventHandler ["Fired", _idx_eh_fired];
					(findDisplay 46) displayRemoveEventHandler ["KeyDown", _idx_eh_keyDown];
					(findDisplay 46) displayRemoveEventHandler ["KeyUp", _idx_eh_keyUp];
					
					_joueur removeAction _action_relacher;
					_joueur removeAction _action_aligner_pente;
					_joueur removeAction _action_aligner_sol;
					_joueur removeAction _action_aligner_horizon;
					_joueur removeAction _action_tourner;
					_joueur removeAction _action_rapprocher;
					
					_objet setVariable ["R3F_LOG_est_deplace_par", objNull, true];
				}
				// Echec d'obtention de l'objet
				else
				{
					_objet setVariable ["R3F_LOG_est_deplace_par", objNull, true];
					R3F_LOG_mutex_local_verrou = false;
				};
				
				_joueur forceWalk false;
				R3F_LOG_joueur_deplace_objet = objNull;
				
				// Reprise de l'arme et restauration de son mode de tir, si nécessaire
				if (alive _joueur && !surfaceIsWater getPos _joueur && _restaurer_arme) then
				{
					for [{_idx_muzzle = 0},
						{currentWeapon _joueur != _arme_courante ||
						currentMuzzle _joueur != _muzzle_courant ||
						currentWeaponMode _joueur != _mode_muzzle_courant},
						{_idx_muzzle = _idx_muzzle+1}] do
					{
						_joueur action ["SWITCHWEAPON", _joueur, _joueur, _idx_muzzle];
					};
				};
				
				sleep 5; // Délai de 5 secondes pour attendre la chute/stabilisation
				if (!isNull _objet) then
				{
					if (isNull (_objet getVariable ["R3F_LOG_est_deplace_par", objNull]) ||
						{(!alive (_objet getVariable "R3F_LOG_est_deplace_par")) || (!isPlayer (_objet getVariable "R3F_LOG_est_deplace_par"))}
					) then
					{
						R3F_LOG_PV_fin_deplacement_objet = _objet;
						publicVariable "R3F_LOG_PV_fin_deplacement_objet";
						["R3F_LOG_PV_fin_deplacement_objet", R3F_LOG_PV_fin_deplacement_objet] call R3F_LOG_FNCT_PVEH_fin_deplacement_objet;
					};
				};
			}
			else
			{
				hintC format [STR_R3F_LOG_joueur_dans_objet, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
				R3F_LOG_mutex_local_verrou = false;
			};
		}
		else
		{
			hintC format [STR_R3F_LOG_objet_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
			R3F_LOG_mutex_local_verrou = false;
		};
	}
	else
	{
		hintC format [STR_R3F_LOG_objet_en_cours_transport, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
		R3F_LOG_mutex_local_verrou = false;
	};
	
	// No more fucking busted crates
	if (local _objet && {_objet isKindOf "ReammoBox_F"}) then
	{
		_objet allowDamage false;
		_objet setDamage 0;
	} else {
		_objet allowDamage true;
		_objet setVariable ["allowDamage", true, true];
	};
};