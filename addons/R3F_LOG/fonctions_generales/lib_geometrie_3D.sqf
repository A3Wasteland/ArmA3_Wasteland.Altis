/**
 * Bibliothèque de fonctions de calculs dans un espace 3D (calculs d'intersection, rotations, etc.).
 * 
 * Fournit une série de fonctions de calculs d'intersection (bounding sphere, bounding box, rayon-bbox)
 * Fournit des fonctions de génération de matrices 3x3 de rotations yaw, pitch, roll
 * Fournit des fonctions de multiplications vec3 x mat3x3 et mat3x3 x mat3x3
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Liste des fonctions :
 * ---------------------
 * // Calculs d'intersection rayon/bounding box/sphere/mesh
 * R3F_LOG_FNCT_3D_ray_intersect_bbox
 * R3F_LOG_FNCT_3D_ray_intersect_bbox_obj
 * R3F_LOG_FNCT_3D_cam_intersect_bbox_obj
 * 
 * R3F_LOG_FNCT_3D_pos_est_dans_bbox
 * R3F_LOG_FNCT_3D_distance_min_pos_bbox
 * 
 * R3F_LOG_FNCT_3D_bounding_sphere_intersect_bounding_sphere
 * R3F_LOG_FNCT_3D_intersect_bounding_sphere_objs
 * R3F_LOG_FNCT_3D_bounding_sphere_intersect_bounding_box
 * R3F_LOG_FNCT_3D_bbox_intersect_bbox
 * R3F_LOG_FNCT_3D_bbox_intersect_bbox_objs
 * R3F_LOG_FNCT_3D_mesh_collision_objs
 * 
 * // Recherche de position
 * R3F_LOG_FNCT_3D_tirer_position_degagee_ciel
 * R3F_LOG_FNCT_3D_tirer_position_degagee_sol
 * 
 * // Utilitaires
 * R3F_LOG_FNCT_3D_cursorTarget_distance_bbox
 * R3F_LOG_FNCT_3D_cursorTarget_virtuel
 * R3F_LOG_FNCT_3D_get_huit_coins_bounding_box_model
 * R3F_LOG_FNCT_3D_get_huit_coins_bounding_box_world
 * R3F_LOG_FNCT_3D_get_objets_genants_rayon
 * R3F_LOG_FNCT_3D_get_bounding_box_depuis_classname
 * R3F_LOG_FNCT_3D_get_hauteur_terrain_min_max_objet
 * 
 * // Transformation 3D
 * R3F_LOG_FNCT_3D_mult_mat3x3
 * R3F_LOG_FNCT_3D_mult_vec_mat3x3
 * R3F_LOG_FNCT_3D_mat_rot_roll
 * R3F_LOG_FNCT_3D_mat_rot_pitch
 * R3F_LOG_FNCT_3D_mat_rot_yaw
 * 
 * // Visualisation
 * R3F_LOG_FNCT_3D_tracer_bbox
 * R3F_LOG_FNCT_3D_tracer_bbox_obj
 */

/**
 * Calcule l'intersection d'un rayon avec une bounding box
 * @param 0 position du rayon (dans le repère de la bbox)
 * @param 1 direction du rayon (dans le repère de la bbox)
 * @param 2 position min de la bounding box
 * @param 3 position max de la bounding box
 * @return la distance entre la position du rayon et la bounding box; 1E39 (infini) si pas d'intersection
 * @note le rayon doit être défini dans le repère de la bbox (worldToModel)
 */
R3F_LOG_FNCT_3D_ray_intersect_bbox =
{
	private ["_ray_pos", "_ray_dir", "_bbox_min", "_bbox_max", "_inv_ray_x", "_inv_ray_y", "_inv_ray_z"];
	private ["_tmin", "_tmax", "_tymin", "_tymax", "_tzmin", "_tzmax"];
	
	_ray_pos = _this select 0;
	_ray_dir = _this select 1;
	_bbox_min = _this select 2;
	_bbox_max = _this select 3;
	
	// Optimisation (1 div + 2 mul au lieu de 2 div) et gestion de la division par zéro
	_inv_ray_x = if (_ray_dir select 0 != 0) then {1 / (_ray_dir select 0)} else {1E39};
	_inv_ray_y = if (_ray_dir select 1 != 0) then {1 / (_ray_dir select 1)} else {1E39};
	_inv_ray_z = if (_ray_dir select 2 != 0) then {1 / (_ray_dir select 2)} else {1E39};
	
	/* Pour chaque axe, on calcule la distance d'intersection du rayon avec les deux plans de la bounding box */
	
	if (_inv_ray_x < 0) then
	{
		_tmax = ((_bbox_min select 0) - (_ray_pos select 0)) * _inv_ray_x;
		_tmin = ((_bbox_max select 0) - (_ray_pos select 0)) * _inv_ray_x;
	}
	else
	{
		_tmin = ((_bbox_min select 0) - (_ray_pos select 0)) * _inv_ray_x;
		_tmax = ((_bbox_max select 0) - (_ray_pos select 0)) * _inv_ray_x;
	};
	
	if (_inv_ray_y < 0) then
	{
		_tymax = ((_bbox_min select 1) - (_ray_pos select 1)) * _inv_ray_y;
		_tymin = ((_bbox_max select 1) - (_ray_pos select 1)) * _inv_ray_y;
	}
	else
	{
		_tymin = ((_bbox_min select 1) - (_ray_pos select 1)) * _inv_ray_y;
		_tymax = ((_bbox_max select 1) - (_ray_pos select 1)) * _inv_ray_y;
	};
	
	if ((_tmin > _tymax) || (_tymin > _tmax)) exitWith {1E39};
	
	_tmin = _tmin max _tymin;
	_tmax = _tmax min _tymax;
	
	if (_inv_ray_z < 0) then
	{
		_tzmax = ((_bbox_min select 2) - (_ray_pos select 2)) * _inv_ray_z;
		_tzmin = ((_bbox_max select 2) - (_ray_pos select 2)) * _inv_ray_z;
	}
	else
	{
		_tzmin = ((_bbox_min select 2) - (_ray_pos select 2)) * _inv_ray_z;
		_tzmax = ((_bbox_max select 2) - (_ray_pos select 2)) * _inv_ray_z;
	};
	
	if ((_tmin > _tzmax) || (_tzmin > _tmax)) exitWith {1E39};
	
	_tmin = _tmin max _tzmin;
	_tmax = _tmax min _tzmax;
	
	if (_tmax < 0) exitWith {1E39};
	
	_tmin
};

/**
 * Calcule l'intersection d'un rayon avec un objet
 * @param 0 position du rayon (dans le repère worldATL)
 * @param 1 direction du rayon (dans le repère world)
 * @param 2 l'objet pour lequel calculer l'intersection de bounding box
 * @return la distance entre la position du rayon et la bounding box; 1E39 (infini) si pas d'intersection
 */
R3F_LOG_FNCT_3D_ray_intersect_bbox_obj =
{
	private ["_ray_pos", "_ray_dir", "_objet"];
	
	_ray_pos = _this select 0;
	_ray_dir = _this select 1;
	_objet = _this select 2;
	
	[
		_objet worldToModel _ray_pos,
		// (_objet worldToModel _ray_dir) vectorDiff (_objet worldToModel [0,0,0]), Manque de précision numérique, d'où l'expression ci-dessous
		(_objet worldToModel ASLtoATL (_ray_dir vectorAdd getPosASL _objet)) vectorDiff (_objet worldToModel ASLtoATL (getPosASL _objet)),
		boundingBoxReal _objet select 0,
		boundingBoxReal _objet select 1
	] call R3F_LOG_FNCT_3D_ray_intersect_bbox
};

/**
 * Calcule l'intersection du centre de la caméra avec la bounding box d'un objet
 * @param 0 l'objet pour lequel on souhaite calculer l'intersection de bounding box
 * @return la distance entre la caméra du joueur et la bounding box; 1E39 (infini) si pas d'intersection
 */
R3F_LOG_FNCT_3D_cam_intersect_bbox_obj =
{
	private ["_objet", "_pos_cam", "_pos_devant", "_dir_cam"];
	
	_objet = _this select 0;
	
	if (isNull _objet) exitWith {1E39};
	
	_pos_cam = positionCameraToWorld [0, 0, 0];
	_pos_devant = positionCameraToWorld [0, 0, 1];
	_dir_cam = (ATLtoASL _pos_devant) vectorDiff (ATLtoASL _pos_cam);
	
	[_pos_cam, _dir_cam, _objet] call R3F_LOG_FNCT_3D_ray_intersect_bbox_obj
};

/**
 * Indique si une position se trouve à l'intérieur d'une bounding box
 * @param 0 position à tester (dans le repère de la bbox)
 * @param 1 position min de la bounding box
 * @param 2 position max de la bounding box
 * @return true si la position se trouve à l'intérieur de la bounding box, false sinon
 * @note la position doit être défini dans le repère de la bbox (worldToModel)
 */
R3F_LOG_FNCT_3D_pos_est_dans_bbox =
{
	private ["_pos", "_bbox_min", "_bbox_max"];
	
	_pos = _this select 0;
	_bbox_min = _this select 1;
	_bbox_max = _this select 2;
	
	(_bbox_min select 0 <= _pos select 0) && (_pos select 0 <= _bbox_max select 0) &&
	(_bbox_min select 1 <= _pos select 1) && (_pos select 1 <= _bbox_max select 1) &&
	(_bbox_min select 2 <= _pos select 2) && (_pos select 2 <= _bbox_max select 2)
};

/**
 * Calcule la distance minimale entre une position et une bounding box
 * @param 0 la position pour laquelle calculer la distance avec la bbox (dans le repère de la bbox)
 * @param 1 position min de la bounding box
 * @param 2 position max de la bounding box
 * @return distance du segment le plus court reliant la position à la bounding box
 */
R3F_LOG_FNCT_3D_distance_min_pos_bbox =
{
	private ["_pos", "_bbox_min", "_bbox_max", "_pos_intersect_min_bbox"];
	
	_pos = _this select 0;
	_bbox_min = _this select 1;
	_bbox_max = _this select 2;
	
	_pos_intersect_min_bbox =
	[
		(_bbox_min select 0) max (_pos select 0) min (_bbox_max select 0),
		(_bbox_min select 1) max (_pos select 1) min (_bbox_max select 1),
		(_bbox_min select 2) max (_pos select 2) min (_bbox_max select 2)
	];
	
	_pos_intersect_min_bbox distance _pos
};

/**
 * Indique s'il y a intersection entre deux bounding sphere
 * @param 0 position centrale de la première bounding sphere
 * @param 1 rayon de la première bounding sphere
 * @param 2 position centrale de la deuxième bounding sphere
 * @param 3 rayon de la deuxième bounding sphere
 * @return true s'il y a intersection entre les deux bounding sphere, false sinon
 * @note les deux bounding sphere doivent être définies dans le même repère (worldASL ou model)
 * @note pour effecteur un test entre un point et une sphere, définir un rayon de 0
 */
R3F_LOG_FNCT_3D_bounding_sphere_intersect_bounding_sphere =
{
	private ["_pos1", "_rayon1", "_pos2", "_rayon2"];
	
	_pos1 = _this select 0;
	_rayon1 = _this select 1;
	_pos2 = _this select 2;
	_rayon2 = _this select 3;
	
	(_pos1 distance _pos2) <= (_rayon1 + _rayon2)
};

/**
 * Détermine s'il y a intersection entre les bounding spheres de deux objets
 * @param 0 le premier objet pour lequel calculer l'intersection de bounding sphere
 * @param 1 le deuxième objet pour lequel calculer l'intersection de bounding sphere
 * @return true s'il y a intersection entre les bounding sphere des deux objets, false sinon
 */
R3F_LOG_FNCT_3D_intersect_bounding_sphere_objs =
{
	private ["_objet1", "_objet2"];
	
	_objet1 = _this select 0;
	_objet2 = _this select 1;
	
	// Valeurs selon le formule de R3F_LOG_FNCT_3D_bounding_sphere_intersect_bounding_sphere
	//_pos1 = [0,0,0];
	//_rayon1 = (vectorMagnitude (boundingBoxReal _objet1 select 0)) max (vectorMagnitude (boundingBoxReal _objet1 select 1));
	//_pos2 = _objet1 worldToModel (_objet2 modelToWorld [0,0,0]);
	//_rayon2 = (vectorMagnitude (boundingBoxReal _objet2 select 0)) max (vectorMagnitude (boundingBoxReal _objet2 select 1));
	// Retour : (_pos1 distance _pos2) <= (_rayon1 + _rayon2)
	
	// Ce qui donne
	vectorMagnitude (_objet1 worldToModel (_objet2 modelToWorld [0,0,0])) <= (
		((vectorMagnitude (boundingBoxReal _objet1 select 0)) max (vectorMagnitude (boundingBoxReal _objet1 select 1)))
	+
		((vectorMagnitude (boundingBoxReal _objet2 select 0)) max (vectorMagnitude (boundingBoxReal _objet2 select 1)))
	)
};

/**
 * Détermine s'il y a intersection entre entre une bounding box et une bounding sphere
 * @param 0 la position centrale de la bounding sphere (dans le repère de la bbox)
 * @param 1 rayon de la bounding sphere
 * @param 2 position min de la bounding box
 * @param 3 position max de la bounding box
 * @return true s'il y a intersection entre la bounding box et la bounding sphere, false sinon
 */
R3F_LOG_FNCT_3D_bounding_sphere_intersect_bounding_box =
{
	private ["_pos_bsphere", "_rayon_bsphere", "_bbox_min", "_bbox_max", "_pos_intersect_min_bbox"];
	
	// Utilisation "inline" de la fonction R3F_LOG_FNCT_3D_distance_min_pos_bbox
	_pos_bsphere = _this select 0;
	_rayon_bsphere = _this select 1;
	_bbox_min = _this select 2;
	_bbox_max = _this select 3;
	
	_pos_intersect_min_bbox =
	[
		(_bbox_min select 0) max (_pos_bsphere select 0) min (_bbox_max select 0),
		(_bbox_min select 1) max (_pos_bsphere select 1) min (_bbox_max select 1),
		(_bbox_min select 2) max (_pos_bsphere select 2) min (_bbox_max select 2)
	];
	
	(_pos_intersect_min_bbox distance _pos_bsphere) <= _rayon_bsphere
};

/**
 * Détermine s'il y a intersection entre les bounding box de deux objets
 * @param 0 le premier objet pour lequel calculer l'intersection
 * @param 1 position min de la bounding box du premier objet
 * @param 2 position max de la bounding box du premier objet
 * @param 3 le deuxième objet pour lequel calculer l'intersection
 * @param 4 position min de la bounding box du deuxième objet
 * @param 5 position max de la bounding box du deuxième objet
 * @return true s'il y a intersection entre les bounding box des deux objets, false sinon
 * @note les objets peuvent être d'un type ne correspondant pas aux bounding box
 * @note cela permet par exemple d'utiliser une logique de jeu, pour un calcul à priori
 */
R3F_LOG_FNCT_3D_bbox_intersect_bbox =
{
	private ["_objet1", "_objet2", "_bbox1_min", "_bbox1_max", "_bbox2_min", "_bbox2_max", "_intersect", "_coins", "_rayons"];
	
	_objet1 = _this select 0;
	_bbox1_min = _this select 1;
	_bbox1_max = _this select 2;
	_objet2 = _this select 3;
	_bbox2_min = _this select 4;
	_bbox2_max = _this select 5;
	
	// Quitter dès maintenant s'il est impossible d'avoir une intersection
	if !(
			[
				_objet2 worldToModel (_objet1 modelToWorld [0,0,0]),
				(vectorMagnitude _bbox1_min) max (vectorMagnitude _bbox1_max),
				_bbox2_min,
				_bbox2_max
			] call R3F_LOG_FNCT_3D_bounding_sphere_intersect_bounding_box
		&&
			[
				_objet1 worldToModel (_objet2 modelToWorld [0,0,0]),
				(vectorMagnitude _bbox2_min) max (vectorMagnitude _bbox2_max),
				_bbox1_min,
				_bbox1_max
			] call R3F_LOG_FNCT_3D_bounding_sphere_intersect_bounding_box
	) exitWith {false};
	
	_intersect = false;
	_coins = [];
	
	// Composition des coordonnées des 8 coins de la bounding box de l'objet1, dans l'espace du modèle _objet2
	_coins set [0, _objet2 worldToModel (_objet1 modelToWorld [_bbox1_min select 0, _bbox1_min select 1, _bbox1_min select 2])];
	_coins set [1, _objet2 worldToModel (_objet1 modelToWorld [_bbox1_min select 0, _bbox1_min select 1, _bbox1_max select 2])];
	_coins set [2, _objet2 worldToModel (_objet1 modelToWorld [_bbox1_min select 0, _bbox1_max select 1, _bbox1_min select 2])];
	_coins set [3, _objet2 worldToModel (_objet1 modelToWorld [_bbox1_min select 0, _bbox1_max select 1, _bbox1_max select 2])];
	_coins set [4, _objet2 worldToModel (_objet1 modelToWorld [_bbox1_max select 0, _bbox1_min select 1, _bbox1_min select 2])];
	_coins set [5, _objet2 worldToModel (_objet1 modelToWorld [_bbox1_max select 0, _bbox1_min select 1, _bbox1_max select 2])];
	_coins set [6, _objet2 worldToModel (_objet1 modelToWorld [_bbox1_max select 0, _bbox1_max select 1, _bbox1_min select 2])];
	_coins set [7, _objet2 worldToModel (_objet1 modelToWorld [_bbox1_max select 0, _bbox1_max select 1, _bbox1_max select 2])];
	
	// Test de présence de chacun des coins de la bounding box de l'objet1, dans la bounding box de l'objet2
	{
		// Utilisation "inline" de la fonction R3F_LOG_FNCT_3D_pos_est_dans_bbox
		if (
			(_bbox2_min select 0 <= _x select 0) && (_x select 0 <= _bbox2_max select 0) &&
			(_bbox2_min select 1 <= _x select 1) && (_x select 1 <= _bbox2_max select 1) &&
			(_bbox2_min select 2 <= _x select 2) && (_x select 2 <= _bbox2_max select 2)
		) exitWith {_intersect = true;};
	} forEach _coins;
	
	if (_intersect) exitWith {true};
	
	// Composition des coordonnées des 8 coins de la bounding box de l'objet2, dans l'espace du modèle _objet1
	_coins set [0, _objet1 worldToModel (_objet2 modelToWorld [_bbox2_min select 0, _bbox2_min select 1, _bbox2_min select 2])];
	_coins set [1, _objet1 worldToModel (_objet2 modelToWorld [_bbox2_min select 0, _bbox2_min select 1, _bbox2_max select 2])];
	_coins set [2, _objet1 worldToModel (_objet2 modelToWorld [_bbox2_min select 0, _bbox2_max select 1, _bbox2_min select 2])];
	_coins set [3, _objet1 worldToModel (_objet2 modelToWorld [_bbox2_min select 0, _bbox2_max select 1, _bbox2_max select 2])];
	_coins set [4, _objet1 worldToModel (_objet2 modelToWorld [_bbox2_max select 0, _bbox2_min select 1, _bbox2_min select 2])];
	_coins set [5, _objet1 worldToModel (_objet2 modelToWorld [_bbox2_max select 0, _bbox2_min select 1, _bbox2_max select 2])];
	_coins set [6, _objet1 worldToModel (_objet2 modelToWorld [_bbox2_max select 0, _bbox2_max select 1, _bbox2_min select 2])];
	_coins set [7, _objet1 worldToModel (_objet2 modelToWorld [_bbox2_max select 0, _bbox2_max select 1, _bbox2_max select 2])];
	
	// Test de présence de chacun des coins de la bounding box de l'objet2, dans la bounding box de l'objet1
	{
		// Utilisation "inline" de la fonction R3F_LOG_FNCT_3D_pos_est_dans_bbox
		if (
			(_bbox1_min select 0 <= _x select 0) && (_x select 0 <= _bbox1_max select 0) &&
			(_bbox1_min select 1 <= _x select 1) && (_x select 1 <= _bbox1_max select 1) &&
			(_bbox1_min select 2 <= _x select 2) && (_x select 2 <= _bbox1_max select 2)
		) exitWith {_intersect = true;};
	} forEach _coins;
	
	if (_intersect) exitWith {true};
	
	// Composition des 12 rayons [pos, dir, longueur] correspondant aux segments de la bounding box de l'objet2, dans l'espace du modèle _objet1
	_rayons = [];
	_rayons set [ 0, [_coins select 1, _coins select 0, vectorMagnitude ((_coins select 1) vectorDiff (_coins select 0))]];
	_rayons set [ 1, [_coins select 2, _coins select 0, vectorMagnitude ((_coins select 2) vectorDiff (_coins select 0))]];
	_rayons set [ 2, [_coins select 1, _coins select 3, vectorMagnitude ((_coins select 1) vectorDiff (_coins select 3))]];
	_rayons set [ 3, [_coins select 2, _coins select 3, vectorMagnitude ((_coins select 2) vectorDiff (_coins select 3))]];
	_rayons set [ 4, [_coins select 5, _coins select 4, vectorMagnitude ((_coins select 5) vectorDiff (_coins select 4))]];
	_rayons set [ 5, [_coins select 6, _coins select 4, vectorMagnitude ((_coins select 6) vectorDiff (_coins select 4))]];
	_rayons set [ 6, [_coins select 5, _coins select 7, vectorMagnitude ((_coins select 5) vectorDiff (_coins select 7))]];
	_rayons set [ 7, [_coins select 6, _coins select 7, vectorMagnitude ((_coins select 6) vectorDiff (_coins select 7))]];
	_rayons set [ 8, [_coins select 0, _coins select 4, vectorMagnitude ((_coins select 0) vectorDiff (_coins select 4))]];
	_rayons set [ 9, [_coins select 1, _coins select 5, vectorMagnitude ((_coins select 1) vectorDiff (_coins select 5))]];
	_rayons set [10, [_coins select 2, _coins select 6, vectorMagnitude ((_coins select 2) vectorDiff (_coins select 6))]];
	_rayons set [11, [_coins select 3, _coins select 7, vectorMagnitude ((_coins select 3) vectorDiff (_coins select 7))]];
	
	// Test d'intersection de chaque rayon avec la bounding box de l'objet1
	{
		// Si la dimension de la bbox, dans l'axe concerné, est nulle, on fait un calcul basé sur la position (rayon de longueur nulle)
		if (_x select 2 == 0) then
		{
			if ([_x select 0, _bbox1_min, _bbox1_max] call R3F_LOG_FNCT_3D_pos_est_dans_bbox) exitWith {_intersect = true;};
		}
		else
		{
			if ([
				_x select 0,
				((_x select 1) vectorDiff (_x select 0)) vectorMultiply (1 / (_x select 2)), // Direction rayon
				_bbox1_min,
				_bbox1_max
			] call R3F_LOG_FNCT_3D_ray_intersect_bbox <= (_x select 2)) exitWith {_intersect = true;};
		};
	} forEach _rayons;
	
	_intersect
};

/**
 * Détermine s'il y a intersection entre les bounding box de deux objets
 * @param 0 le premier objet pour lequel calculer l'intersection
 * @param 1 le deuxième objet pour lequel calculer l'intersection
 * @return true s'il y a intersection entre les bounding box des deux objets, false sinon
 */
R3F_LOG_FNCT_3D_bbox_intersect_bbox_objs =
{
	private ["_objet1", "_objet2"];
	
	_objet1 = _this select 0;
	_objet2 = _this select 1;
	
	[
		_objet1,
		boundingBoxReal _objet1 select 0,
		boundingBoxReal _objet1 select 1,
		_objet2,
		boundingBoxReal _objet2 select 0,
		boundingBoxReal _objet2 select 1
	] call R3F_LOG_FNCT_3D_bbox_intersect_bbox
};

/**
 * Détermine s'il y a une collision physique réelle (mesh) entre deux objets
 * @param 0 le premier objet pour lequel calculer l'intersection
 * @param 1 le deuxième objet pour lequel calculer l'intersection
 * @param 2 (optionnel) true pour tester directement la collision de mesh sans tester les bbox, false pour d'abord tester les bbox (défaut : false)
 * @return true s'il y a une collision physique réelle (mesh) entre deux objets, false sinon
 * @note le calcul est basé sur les collisions PhysX, des objets non PhysX ne genère pas de collision
 * 
 * @note WARNING WORK IN PROGRESS FUNCTION, NOT FOR USE !!! TODO FINALIZE IT
 */
R3F_LOG_FNCT_3D_mesh_collision_objs =
{
	private ["_objet1", "_objet2", "_objet_test1", "_objet_test2", "_force_test_mesh", "_pos_test", "_num_frame_start", "_collision"];
	
	_objet1 = _this select 0;
	_objet2 = _this select 1;
	_force_test_mesh = if (count _this > 2) then {_this select 2} else {false};
	
	// Quitter dès maintenant s'il est impossible d'avoir une intersection (sauf test forcé)
	if (!_force_test_mesh && {!(
		[
			_objet1,
			boundingBoxReal _objet1 select 0,
			boundingBoxReal _objet1 select 1,
			_objet2,
			boundingBoxReal _objet2 select 0,
			boundingBoxReal _objet2 select 1
		] call R3F_LOG_FNCT_3D_bbox_intersect_bbox
	)}) exitWith {false};
	
	systemChat format ["PROBABLE INTERSECT MESH : %1 @ %2", _objet2, time];//TODO REMOVE
	
	_pos_test = ATLtoASL (player modelToWorld [0,16,20]);// TODO remplacer par R3F_LOG_FNCT_3D_tirer_position_degagee_ciel
	
	_objet_test1 = (typeOf _objet1) createVehicleLocal ([] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel);
	_objet_test1 setVectorDirAndUp [vectorDir _objet1, vectorUp _objet1];
	_objet_test1 allowDamage false;
	_objet_test1 addEventHandler ["EpeContactStart", {if (!isNull (_this select 1)) then {(_this select 0) setVariable ["R3F_LOG_3D_collision", true, false];};}];
	_objet_test1 setVariable ["R3F_LOG_3D_collision", false, false];
	
	_objet_test2 = (typeOf _objet2) createVehicleLocal ([] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel);
	_objet_test2 setVectorDirAndUp [vectorDir _objet2, vectorUp _objet2];
	_objet_test2 allowDamage false;
	_objet_test2 addEventHandler ["EpeContactStart", {if (!isNull (_this select 1)) then {(_this select 0) setVariable ["R3F_LOG_3D_collision", true, false];};}];
	_objet_test2 setVariable ["R3F_LOG_3D_collision", false, false];
	
	_objet_test1 setVelocity [0,0,0];
	_objet_test1 setVectorDirAndUp [vectorDir _objet1, vectorUp _objet1];
	_objet_test1 setPosASL _pos_test;
	_objet_test2 setVelocity [0,0,0];
	_objet_test2 setVectorDirAndUp [vectorDir _objet2, vectorUp _objet2];
	_objet_test2 setPosASL (_pos_test vectorAdd ((_objet1 worldToModel (_objet2 modelToWorld [0,0,0])) vectorDiff (_objet1 modelToWorld [0,0,0])));
	
	_num_frame_start = diag_frameno;
	waitUntil
	{
		_collision = (_objet_test1 getVariable "R3F_LOG_3D_collision") || (_objet_test2 getVariable "R3F_LOG_3D_collision");
		_collision || (diag_frameno - _num_frame_start > 10)
	};
	
	if (_collision) then {systemChat format ["RESULTAT COLLISION: %1 @ %2", _objet2, time];};//TODO REMOVE
	
	sleep 0.02;// TODO REMOVE
	
	deleteVehicle _objet_test1;
	deleteVehicle _objet_test2;
	
	_collision
};

/**
 * Retourne une position dégagée dans le ciel
 * @param 0 (optionnel) offset 3D du cube dans lequel chercher une position (défaut [0,0,0])
 * @return position dégagée (sphère de 50m de rayon) dans le ciel
 */
R3F_LOG_FNCT_3D_tirer_position_degagee_ciel =
{
	private ["_offset", "_nb_tirages", "_position_degagee"];
	
	_offset = if (count _this > 0) then {_this select 0} else {[0,0,0]};
	
	// Trouver une position dégagée (sphère de 50m de rayon) dans le ciel
	for [
		{
			_position_degagee = [random 3000, random 3000, 10000 + (random 20000)] vectorAdd _offset;
			_nb_tirages = 1;
		},
		{
			!isNull (nearestObject _position_degagee) && _nb_tirages < 25
		},
		{
			_position_degagee = [random 3000, random 3000, 10000 + (random 20000)] vectorAdd _offset;
			_nb_tirages = _nb_tirages+1;
		}
	] do {};
	
	_position_degagee
};

/**
 * Retourne une position suffisamment dégagée au sol pour créer un objet
 * @param 0 le rayon de la zone dégagée à trouver au sein de la zone de recherche
 * @param 1 la position centrale autour de laquelle chercher
 * @param 2 le rayon maximal autour de la position centrale dans lequel chercher la position dégagée
 * @param 3 (optionnel) nombre limite de tentatives de sélection d'une position dégagée avant abandon (défaut : 30)
 * @param 4 (optionnel) true pour autoriser de retourner une position sur l'eau, false sinon (défaut : false)
 * @return position dégagée du rayon indiqué, au sein de la zone de recherche, ou un tableau vide en cas d'échec
 * @note cette fonction pallie au manque de fiabilité des commandes findEmptyPosition et isFlatEmpty concernant les collisions
 */
R3F_LOG_FNCT_3D_tirer_position_degagee_sol =
{
	private ["_rayon_degage", "_pos_centre", "_rayon_max", "_nb_tirages_max", "_eau_autorise", "_rayon_max_carre"];
	private ["_nb_tirages", "_objets_genants", "_position_degagee", "_rayon_curr", "_angle_curr", "_intersect"];
	
	_rayon_degage = 1 max (_this select 0);
	_pos_centre = _this select 1;
	_rayon_max = _rayon_degage max (_this select 2);
	_nb_tirages_max = if (count _this > 3) then {_this select 3} else {30};
	_eau_autorise = if (count _this > 4) then {_this select 4} else {false};
	
	_rayon_max_carre = _rayon_max * _rayon_max;
	
	for [
		{
			_position_degagee = [_pos_centre select 0, _pos_centre select 1, 0];
			_nb_tirages = 0;
		},
		{
			if (!_eau_autorise && surfaceIsWater _position_degagee) then {_nb_tirages < _nb_tirages_max}
			else
			{
				_intersect = false;
				
				// Pour chaque objets à proximité de la zone à tester
				{
					// Test de collision de la bbox de l'objet avec la bounding sphere de la zone à tester
					if (
						[
							_x worldToModel _position_degagee,
							_rayon_degage,
							boundingBoxReal _x select 0,
							boundingBoxReal _x select 1
						] call R3F_LOG_FNCT_3D_bounding_sphere_intersect_bounding_box
					) exitWith {_intersect = true;};
				} forEach ([_position_degagee, _rayon_degage+15] call R3F_LOG_FNCT_3D_get_objets_genants_rayon);
				
				_intersect && _nb_tirages < _nb_tirages_max
			}
		},
		{
			// Tirage d'un angle aléatoire, et d'une rayon aléatoirement (distribution surfacique uniforme)
			_angle_curr = random 360;
			_rayon_curr = sqrt random _rayon_max_carre;
			
			_position_degagee =
			[
				(_pos_centre select 0) + _rayon_curr * sin _angle_curr,
				(_pos_centre select 1) + _rayon_curr * cos _angle_curr,
				0
			];
			
			_nb_tirages = _nb_tirages+1;
		}
	] do {};
	
	// Echec, position introuvée
	if (_nb_tirages >= _nb_tirages_max) then {_position_degagee = [];};
	
	_position_degagee
};

/**
 * Calcule la distance entre le joueur et la bbox de l'objet pointé
 * @return tableau avec en premier élément l'objet pointé (ou objNull), et en deuxième élément la distance entre le joueur et la bbox de l'objet pointé
 */
R3F_LOG_FNCT_3D_cursorTarget_distance_bbox =
{
	private ["_objet", "_joueur"];
	
	_objet = cursorTarget;
	_joueur = player;
	
	if (!isNull _objet && !isNull _joueur && alive _joueur && cameraOn == _joueur) then
	{
		[
			_objet,
			[
				_objet worldToModel (_joueur modelToWorld (_joueur selectionPosition "head")),
				boundingBoxReal _objet select 0,
				boundingBoxReal _objet select 1
			] call R3F_LOG_FNCT_3D_distance_min_pos_bbox
		]
	}
	else
	{
		[objNull, 1E39]
	};
};

/**
 * Retourne l'objet pointé par le joueur à une distance max de la bounding box de l'objet pointé
 * @param 0 (optionnel) liste d'objets à ignorer (défaut [])
 * @param 1 (optionnel) distance maximale entre l'unité et la bounding box des objets (défaut : 10)
 * @return l'objet pointé par le joueur ou objNull
 */
R3F_LOG_FNCT_3D_cursorTarget_virtuel =
{
	private ["_liste_ingores", "_distance_max", "_joueur", "_objet_pointe", "_cursorTarget_distance"];
	
	if (isNull player) exitWith {objNull};
	
	_liste_ingores = if (!isNil "_this" && {typeName _this == "ARRAY" && {count _this > 0}}) then {_this select 0} else {[]};
	_distance_max = if (!isNil "_this" && {typeName _this == "ARRAY" && {count _this > 1}}) then {_this select 1} else {10};
	_joueur = player;
	
	_objet_pointe = objNull;
	
	_cursorTarget_distance = call R3F_LOG_FNCT_3D_cursorTarget_distance_bbox;
	
	if (!isNull (_cursorTarget_distance select 0) &&
		{!((_cursorTarget_distance select 0) in _liste_ingores) && (_cursorTarget_distance select 1) <= _distance_max}
	) then
	{
		_objet_pointe = cursorTarget;
	}
	else
	{
		private ["_vec_dir_unite_world", "_pos_unite_world", "_liste_objets"];
		
		_vec_dir_unite_world = (ATLtoASL positionCameraToWorld [0, 0, 1]) vectorDiff (ATLtoASL positionCameraToWorld [0,0,0]);
		_pos_unite_world = _joueur modelToWorld (_joueur selectionPosition "head");
		
		_liste_objets = lineIntersectsObjs [
			(ATLtoASL _pos_unite_world),
			(ATLtoASL _pos_unite_world) vectorAdd (_vec_dir_unite_world vectorMultiply _distance_max),
			objNull,
			player,
			true,
			16 + 32
		];
		
		{
			if (!(_x in _liste_ingores) &&
				[
					_x worldToModel _pos_unite_world,
					boundingBoxReal _x select 0,
					boundingBoxReal _x select 1
				] call R3F_LOG_FNCT_3D_distance_min_pos_bbox <= _distance_max
			) exitWith {_objet_pointe = _x;};
		} forEach _liste_objets;
	};
	
	_objet_pointe
};

/**
 * Retourne la position des huit coins d'une bounding box dans le repère du modèle
 * @param 0 position min de la bounding box
 * @param 1 position max de la bounding box
 * @return tableau contenant la position des huit coins d'une bounding box dans le repère du modèle
 */
R3F_LOG_FNCT_3D_get_huit_coins_bounding_box_model =
{
	private ["_bbox_min", "_bbox_max"];
	
	_bbox_min = _this select 0;
	_bbox_max = _this select 1;
	
	[
		[_bbox_min select 0, _bbox_min select 1, _bbox_min select 2],
		[_bbox_min select 0, _bbox_min select 1, _bbox_max select 2],
		[_bbox_min select 0, _bbox_max select 1, _bbox_min select 2],
		[_bbox_min select 0, _bbox_max select 1, _bbox_max select 2],
		[_bbox_max select 0, _bbox_min select 1, _bbox_min select 2],
		[_bbox_max select 0, _bbox_min select 1, _bbox_max select 2],
		[_bbox_max select 0, _bbox_max select 1, _bbox_min select 2],
		[_bbox_max select 0, _bbox_max select 1, _bbox_max select 2]
	]
};

/**
 * Retourne la position des huit coins d'une bounding box dans le repère world
 * @param 0 l'objet pour lequel calculer les huit coins de la bbox dans le repère world
 * @return tableau contenant la position des huit coins d'une bounding box dans le repère world
 */
R3F_LOG_FNCT_3D_get_huit_coins_bounding_box_world =
{
	private ["_objet", "_bbox_min", "_bbox_max"];
	
	_objet = _this select 0;
	
	_bbox_min = boundingBoxReal _objet select 0;
	_bbox_max = boundingBoxReal _objet select 1;
	
	[
		_objet modelToWorld [_bbox_min select 0, _bbox_min select 1, _bbox_min select 2],
		_objet modelToWorld [_bbox_min select 0, _bbox_min select 1, _bbox_max select 2],
		_objet modelToWorld [_bbox_min select 0, _bbox_max select 1, _bbox_min select 2],
		_objet modelToWorld [_bbox_min select 0, _bbox_max select 1, _bbox_max select 2],
		_objet modelToWorld [_bbox_max select 0, _bbox_min select 1, _bbox_min select 2],
		_objet modelToWorld [_bbox_max select 0, _bbox_min select 1, _bbox_max select 2],
		_objet modelToWorld [_bbox_max select 0, _bbox_max select 1, _bbox_min select 2],
		_objet modelToWorld [_bbox_max select 0, _bbox_max select 1, _bbox_max select 2]
	]
};

/**
 * Retourne la liste des objets présents dans un périmètre et pouvant avoir une collision physique, y compris les éléments de décors propres à la carte
 * @param 0 la position centrale de la zone de recherche
 * @param 1 le rayon de recherche
 * @return la liste des objets présents dans un périmètre et pouvant avoir une collision physique
 * @note la liste des objets retournées contient également les éléments de terrain tels que les rochers et les arbres, murs, bâtiments, ...
 */
R3F_LOG_FNCT_3D_get_objets_genants_rayon =
{
	private ["_pos_centre", "_rayon", "_obj_proches", "_elements_terrain", "_bbox_dim", "_volume", "_e"];
	
	_pos_centre = _this select 0;
	_rayon = _this select 1;
	
	// Récupération des objets et véhicules proches avec bounding suffisamment grande
	_obj_proches = [];
	{
		_bbox_dim = (boundingBoxReal _x select 1) vectorDiff (boundingBoxReal _x select 0);
		_volume = (_bbox_dim select 0) * (_bbox_dim select 1) * (_bbox_dim select 2);
		
		// Filtre : volume suffisamment important
		if (_volume > 0.08) then
		{
			// Filtre : insectes et vie ambiante
			if !(typeOf _x in ["Snake_random_F", "ButterFly_random", "HouseFly", "HoneyBee", "Mosquito"]) then
			{
				_obj_proches pushBack _x;
			};
		};
	} forEach (nearestObjects [_pos_centre, ["All"], _rayon]);
	
	// Récupération de TOUS les éléments à proximité (y compris les rochers, végétations, insectes, particules en suspension, ...)
	// On ignore les éléments non gênants tels que les traces de pas, insectes, particules en suspension, ...
	_elements_terrain = [];
	{
		_e = _x;
		
		// Filtre : objet immobile
		if (vectorMagnitude velocity _e == 0) then
		{
			_bbox_dim = (boundingBoxReal _e select 1) vectorDiff (boundingBoxReal _e select 0);
			_volume = (_bbox_dim select 0) * (_bbox_dim select 1) * (_bbox_dim select 2);
			
			// Filtre : volume suffisamment important
			if (_volume > 0.08) then
			{
				// Filtre : insectes et vie ambiante
				if !(typeOf _x in ["Snake_random_F", "ButterFly_random", "HouseFly", "HoneyBee", "Mosquito"]) then
				{
					// Filtre : ignorer les segments de routes
					if ({_x == _e} count (getPos _e nearRoads 1) == 0) then
					{
						_elements_terrain pushBack _e;
					};
				};
			};
		};
	} forEach nearestObjects [_pos_centre, [], _rayon];
	
	_elements_terrain - _obj_proches + _obj_proches
};

/**
 * Retourne la bounding box d'un objet depuis son nom de classe
 * @param 0 le nom de classe de l'objet
 * @return la bounding box d'un objet correspondant au nom de classe
 */
R3F_LOG_FNCT_3D_get_bounding_box_depuis_classname =
{
	private ["_classe", "_objet_tmp", "_bbox"];
	
	_classe = _this select 0;
	
	// Création du véhicule local temporaire dans le ciel pour connaître la bounding box de l'objet
	_objet_tmp = _classe createVehicleLocal ([] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel);
	sleep 0.01;
	_bbox = boundingBoxReal _objet_tmp;
	deleteVehicle _objet_tmp;
	
	_bbox
};

/**
 * Calcule les hauteurs de terrain ASL minimale et maximale des quatre coins inférieurs d'un objet
 * @param 0 l'objet pour lequel calculer les hauteur de terrains min et max
 * @return tableau contenant respectivement las hauteurs de terrain ASL minimal et maximal
 */
R3F_LOG_FNCT_3D_get_hauteur_terrain_min_max_objet =
{
	private ["_objet", "_x1", "_x2", "_y1", "_y2", "_z", "_hauteur_min", "_hauteur_max", "_hauteur"];
	
	_objet = _this select 0;
	
	_x1 = boundingBoxReal _objet select 0 select 0;
	_x2 = boundingBoxReal _objet select 1 select 0;
	_y1 = boundingBoxReal _objet select 0 select 1;
	_y2 = boundingBoxReal _objet select 1 select 1;
	
	_z = boundingBoxReal _objet select 0 select 2;
	
	_hauteur_min = 1E39;
	_hauteur_max = -1E39;
	
	// Pour chaque coin de l'objet
	{
		_hauteur = getTerrainHeightASL (_objet modelToWorld _x);
		
		if (_hauteur < _hauteur_min) then {_hauteur_min = _hauteur};
		if (_hauteur > _hauteur_max) then {_hauteur_max = _hauteur};
	} forEach [[_x1, _y1, _z], [_x1, _y2, _z], [_x2, _y1, _z], [_x2, _y2, _z]];
	
	[_hauteur_min, _hauteur_max]
};

/**
 * Multiplie deux matrices 3x3
 * @param 0 la première matrice 3x3 à multiplier
 * @param 1 la deuxième matrice 3x3 à multiplier
 * @return la matrice 3x3 résultant de la multiplication
 */
R3F_LOG_FNCT_3D_mult_mat3x3 =
{
	private ["_a", "_b"];
	
	_a = _this select 0;
	_b = _this select 1;
	
	[
		[
			(_a select 0 select 0) * (_b select 0 select 0) + (_a select 0 select 1) * (_b select 1 select 0) + (_a select 0 select 2) * (_b select 2 select 0),
			(_a select 0 select 0) * (_b select 0 select 1) + (_a select 0 select 1) * (_b select 1 select 1) + (_a select 0 select 2) * (_b select 2 select 1),
			(_a select 0 select 0) * (_b select 0 select 2) + (_a select 0 select 1) * (_b select 1 select 2) + (_a select 0 select 2) * (_b select 2 select 2)
		],
		[
			(_a select 1 select 0) * (_b select 0 select 0) + (_a select 1 select 1) * (_b select 1 select 0) + (_a select 1 select 2) * (_b select 2 select 0),
			(_a select 1 select 0) * (_b select 0 select 1) + (_a select 1 select 1) * (_b select 1 select 1) + (_a select 1 select 2) * (_b select 2 select 1),
			(_a select 1 select 0) * (_b select 0 select 2) + (_a select 1 select 1) * (_b select 1 select 2) + (_a select 1 select 2) * (_b select 2 select 2)
		],
		[
			(_a select 2 select 0) * (_b select 0 select 0) + (_a select 2 select 1) * (_b select 1 select 0) + (_a select 2 select 2) * (_b select 2 select 0),
			(_a select 2 select 0) * (_b select 0 select 1) + (_a select 2 select 1) * (_b select 1 select 1) + (_a select 2 select 2) * (_b select 2 select 1),
			(_a select 2 select 0) * (_b select 0 select 2) + (_a select 2 select 1) * (_b select 1 select 2) + (_a select 2 select 2) * (_b select 2 select 2)
		]
	]
};

/**
 * Multiplie un vecteur 3D avec une matrice 3x3
 * @param 0 le vecteur 3D à multiplier
 * @param 1 le matrice 3x3 avec laquelle multiplier le vecteur
 * @return le vecteur 3D résultant de la multiplication
 */
R3F_LOG_FNCT_3D_mult_vec_mat3x3 =
{
	private ["_vec", "_mat"];
	
	_vec = _this select 0;
	_mat = _this select 1;
	
	[
		(_vec select 0) * (_mat select 0 select 0) + (_vec select 1) * (_mat select 1 select 0) + (_vec select 2) * (_mat select 2 select 0),
		(_vec select 0) * (_mat select 0 select 1) + (_vec select 1) * (_mat select 1 select 1) + (_vec select 2) * (_mat select 2 select 1),
		(_vec select 0) * (_mat select 0 select 2) + (_vec select 1) * (_mat select 1 select 2) + (_vec select 2) * (_mat select 2 select 2)
	]
};

/**
 * Retourne la matrice 3x3 de rotation en roulis (roll) pour un angle donné
 * @param l'angle de rotation en degrés
 * @return la matrice 3x3 de rotation en roulis (roll) pour un angle donné
 */
R3F_LOG_FNCT_3D_mat_rot_roll =
{
	[
		[cos _this, 0, sin _this],
		[0, 1, 0],
		[-sin _this, 0, cos _this]
	]
};

/**
 * Retourne la matrice 3x3 de rotation en tangage (pitch) pour un angle donné
 * @param l'angle de rotation en degrés
 * @return la matrice 3x3 de rotation en tangage (pitch) pour un angle donné
 */
R3F_LOG_FNCT_3D_mat_rot_pitch =
{
	[
		[1, 0, 0],
		[0, cos _this, -sin _this],
		[0, sin _this, cos _this]
	]
};

/**
 * Retourne la matrice 3x3 de rotation en lacet (yaw) pour un angle donné
 * @param l'angle de rotation en degrés
 * @return la matrice 3x3 de rotation en lacet (yaw) pour un angle donné
 */
R3F_LOG_FNCT_3D_mat_rot_yaw =
{
	[
		[cos _this, -sin _this, 0],
		[sin _this, cos _this, 0],
		[0, 0, 1]
	]
};

/**
 * Trace dans le jeu une bounding box donnée pour un objet passé en paramètre
 * @param 0 l'objet pour lequel tracer la bounding box
 * @param 1 position min de la bounding box de l'objet
 * @param 2 position max de la bounding box de l'objet
 * @note les objets peuvent être d'un type ne correspondant pas aux bounding box
 * @note cela permet par exemple d'utiliser une logique de jeu, pour un calcul à priori
 */
R3F_LOG_FNCT_3D_tracer_bbox =
{
	private ["_objet", "_bbox_min", "_bbox_max", "_coins", "_couleur"];
	
	_objet = _this select 0;
	_bbox_min = _this select 1;
	_bbox_max = _this select 2;
	
	if !(isNull _objet) then
	{
		// Composition des coordonnées des 8 coins, dans l'espace world
		_coins = [_objet] call R3F_LOG_FNCT_3D_get_huit_coins_bounding_box_world;
		
		// Faire clignoter en rouge/vert le tracé
		_couleur = if (floor (2*diag_tickTime) % 2 == 0) then {[0.95,0,0,1]} else {[0,1,0,1]};
		
		// Tracer les segments de la bounding box
		drawLine3D [_coins select 1, _coins select 0, _couleur];
		drawLine3D [_coins select 2, _coins select 0, _couleur];
		drawLine3D [_coins select 1, _coins select 3, _couleur];
		drawLine3D [_coins select 2, _coins select 3, _couleur];
		
		drawLine3D [_coins select 5, _coins select 4, _couleur];
		drawLine3D [_coins select 6, _coins select 4, _couleur];
		drawLine3D [_coins select 5, _coins select 7, _couleur];
		drawLine3D [_coins select 6, _coins select 7, _couleur];
		
		drawLine3D [_coins select 0, _coins select 4, _couleur];
		drawLine3D [_coins select 1, _coins select 5, _couleur];
		drawLine3D [_coins select 2, _coins select 6, _couleur];
		drawLine3D [_coins select 3, _coins select 7, _couleur];
	};
};

/**
 * Trace dans le jeu la bounding box de l'objet passé en paramètre
 * @param 0 l'objet pour lequel tracer la bounding box
 */
R3F_LOG_FNCT_3D_tracer_bbox_obj =
{
	private ["_objet"];
	
	_objet = _this select 0;
	
	if !(isNull _objet) then
	{
		[_objet, boundingBoxReal _objet select 0, boundingBoxReal _objet select 1] call R3F_LOG_FNCT_3D_tracer_bbox;
	};
};

// Quelques contrôles et visualisations in-game durant le développement
//#define R3F_LOG_3D_dev_mode // TODO commenter cette ligne lors du release
#ifdef R3F_LOG_3D_dev_mode
if (isNil "R3F_LOG_joueur_deplace_objet") then {R3F_LOG_joueur_deplace_objet = objNull};
addMissionEventHandler ["Draw3D",
{
	if !(isNull player) then
	{
		private ["_objet"];
		
		_objet = cursorTarget;
		
		if (!isNull R3F_LOG_joueur_deplace_objet) then
		{
			//[R3F_LOG_joueur_deplace_objet] call R3F_LOG_FNCT_3D_tracer_bbox_obj;
			
			{
				if ([
					R3F_LOG_joueur_deplace_objet,
					boundingBoxReal R3F_LOG_joueur_deplace_objet select 0,
					boundingBoxReal R3F_LOG_joueur_deplace_objet select 1,
					_x,
					boundingBoxReal _x select 0,
					boundingBoxReal _x select 1
				] call R3F_LOG_FNCT_3D_bbox_intersect_bbox) then
				{
					//systemChat format ["COLLISION BBOX %1 @ %2", typeOf _x, time];
					[_x] call R3F_LOG_FNCT_3D_tracer_bbox_obj;
				};
			} forEach (nearestObjects [R3F_LOG_joueur_deplace_objet, ["All"], 15] - [player, R3F_LOG_joueur_deplace_objet]);
		}
		else
		{
			if (false && !isNull _objet) then
			{
				hintSilent format ["%1 | %2 | %3", typeOf _objet, [_objet] call R3F_LOG_FNCT_3D_cam_intersect_bbox_obj,
					[_objet worldToModel (positionCameraToWorld [0, 0, 0]), boundingBoxReal _objet select 0, boundingBoxReal _objet select 1] call R3F_LOG_FNCT_3D_pos_est_dans_bbox];
				
				[_objet] call R3F_LOG_FNCT_3D_tracer_bbox_obj;
			}
			else
			{
				_cursorTarget_distance = call R3F_LOG_FNCT_3D_cursorTarget_distance_bbox;
				hintSilent format ["%1 | %2", typeOf (_cursorTarget_distance select 0), _cursorTarget_distance select 1];
				
				if !(isNull (_cursorTarget_distance select 0)) then
				{
					[_cursorTarget_distance select 0] call R3F_LOG_FNCT_3D_tracer_bbox_obj;
				};
			};
		};
		
		//{
		//	// Calcul de la bbox élargie par rapport au gabarit max d'une unité
		//	_bbox_min_elargie = (boundingBoxReal _x select 0) vectorDiff [1, 1, 2];
		//	_bbox_max_elargie = (boundingBoxReal _x select 1) vectorAdd [1, 1, 2];
		//	
		//	if ([_x worldToModel (player modelToWorld [0,0,0]), _bbox_min_elargie, _bbox_max_elargie] call R3F_LOG_FNCT_3D_pos_est_dans_bbox) then
		//	{
		//		//systemChat format ["JOUEUR PROCHE %1 @ %2", typeOf _x, time];
		//	};
		//} forEach (nearestObjects [player, ["All"], 15] - [player]);
		
		drawIcon3D ["\A3\ui_f\data\map\vehicleicons\iconManMedic_ca.paa", [1,0,0,1], positionCameraToWorld [0, 0, 1], 0.2, 0.2, 0, "", 1, 0, "TahomaB"];
		
		//if !(isNil "R3F_LOG_liste_objets_en_deplacement") then
		//{
		//	{
		//		[_x] call R3F_LOG_FNCT_3D_tracer_bbox_obj;
		//	} forEach R3F_LOG_liste_objets_en_deplacement;
		//};
		
		//{
		//	[_x] call R3F_LOG_FNCT_3D_tracer_bbox_obj;
		//} forEach [[[R3F_LOG_joueur_deplace_objet]] call R3F_LOG_FNCT_3D_cursorTarget_virtuel];
		
		//{
		//	[_x] call R3F_LOG_FNCT_3D_tracer_bbox_obj;
		//} forEach ([player, 100] call R3F_LOG_FNCT_3D_get_objets_genants_rayon);
	};
}];
#endif