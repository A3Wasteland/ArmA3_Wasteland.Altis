/**
 * Bibliothèque de fonctions permettant la visualisation 3D d'objets
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * Démarre le mode de visualisation 3D
 */
R3F_LOG_VIS_FNCT_demarrer_visualisation =
{
	// Création d'une caméra
	R3F_LOG_VIS_cam = "camera" camCreate ([[5000, 5000, 0]] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel);
	R3F_LOG_VIS_cam cameraEffect ["Internal", "BACK"];
	R3F_LOG_VIS_cam camSetFocus [-1, -1];
	showCinemaBorder false;
	R3F_LOG_VIS_cam camCommit 0;
	camUseNVG (sunOrMoon == 0);
	
	R3F_LOG_VIS_objet = objNull;
	
	// Fil d'exécution réalisant une rotation continue de la caméra autour de l'objet à visualiser
	0 spawn
	{
		// Tant qu'on ne quitte pas la visualisation
		while {!isNull R3F_LOG_VIS_cam} do
		{
			private ["_objet", "_distance_cam", "_azimut_cam"];
			
			// Attente d'un objet à visualiser
			waitUntil {!isNull R3F_LOG_VIS_objet};
			
			_objet = R3F_LOG_VIS_objet;
			
			_distance_cam = 2.25 * (
					[boundingBoxReal _objet select 0 select 0, boundingBoxReal _objet select 0 select 2]
				distance
					[boundingBoxReal _objet select 1 select 0, boundingBoxReal _objet select 1 select 2]
			);
			_azimut_cam = 0;
			
			R3F_LOG_VIS_cam camSetTarget _objet;
			R3F_LOG_VIS_cam camSetPos (_objet modelToWorld [_distance_cam * sin _azimut_cam, _distance_cam * cos _azimut_cam, _distance_cam * 0.33]);
			R3F_LOG_VIS_cam camCommit 0;
			
			// Rotation autour de l'objet
			while {R3F_LOG_VIS_objet == _objet} do
			{
				_azimut_cam = _azimut_cam + 3.25;
				
				R3F_LOG_VIS_cam camSetPos (_objet modelToWorld [_distance_cam * sin _azimut_cam, _distance_cam * cos _azimut_cam, _distance_cam * 0.33]);
				R3F_LOG_VIS_cam camCommit 0.05;
				
				sleep 0.05;
			};
		};
	};
};

/**
 * Termine le mode de visualisation 3D
 */
R3F_LOG_VIS_FNCT_terminer_visualisation =
{
	if (!isNull R3F_LOG_VIS_objet) then {detach R3F_LOG_VIS_objet; deleteVehicle R3F_LOG_VIS_objet;};
	R3F_LOG_VIS_objet = objNull;
	
	R3F_LOG_VIS_cam cameraEffect ["Terminate", "BACK"];
	camDestroy R3F_LOG_VIS_cam;
	R3F_LOG_VIS_cam = objNull;
};

/**
 * Visualiser un type d'objet en 3D
 * 
 * @param 0 le nom de classe de l'objet à visualiser
 */
R3F_LOG_VIS_FNCT_voir_objet =
{
	private ["_classe_a_visualiser", "_objet", "_position_attache"];
	
	if (isNil "R3F_LOG_VIS_cam") then
	{
		call R3F_LOG_VIS_FNCT_demarrer_visualisation;
	};
	
	_classe_a_visualiser = _this select 0;
	
	// Ignorer les objets non instanciables
	if (_classe_a_visualiser != "" && {isClass (configFile >> "CfgVehicles" >> _classe_a_visualiser) && {getNumber (configFile >> "CfgVehicles" >> _classe_a_visualiser >> "scope") > 0}}) then
	{
		// Ignorer si l'objet à visualiser est le même que précédemment
		if (isNull R3F_LOG_VIS_objet || {_classe_a_visualiser != typeOf R3F_LOG_VIS_objet}) then
		{
			// Créer et placer l'objet dans le ciel
			_position_attache = [[5000, 5000, 0]] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel;
			_objet = _classe_a_visualiser createVehicleLocal _position_attache;
			_objet attachTo [R3F_LOG_PUBVAR_point_attache, _position_attache];
			
			if (!isNull R3F_LOG_VIS_objet) then {detach R3F_LOG_VIS_objet; deleteVehicle R3F_LOG_VIS_objet;};
			R3F_LOG_VIS_objet = _objet;
		};
	};
};