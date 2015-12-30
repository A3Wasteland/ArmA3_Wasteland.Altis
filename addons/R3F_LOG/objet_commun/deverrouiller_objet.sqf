/**
 * Gestion du déverrouillage d'un objet et du compte-à-rebours
 * 
 * @param 0 l'objet à déverrouiller
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
	
	private ["_objet", "_duree", "_ctrl_titre", "_ctrl_fond", "_ctrl_jauge", "_time_debut", "_attente_valide", "_cursorTarget_distance"];
	
	_objet = _this select 0;
	_duree = 0; //R3F_LOG_CFG_unlock_objects_timer;
	
	#define _JAUGE_Y 0.7
	#define _JAUGE_W 0.4
	#define _JAUGE_H 0.025
	
	disableSerialization;
	/*
	// Création du titre du compte-à-rebours dans le display du jeu
	_ctrl_titre = (findDisplay 46) ctrlCreate ["RscText", -1];
	_ctrl_titre ctrlSetPosition [0.5 - 0.5*_JAUGE_W, _JAUGE_Y - 1.5*_JAUGE_H, _JAUGE_W, 1.5*_JAUGE_H];
	_ctrl_titre ctrlSetFontHeight 1.5*_JAUGE_H;
	_ctrl_titre ctrlSetText format [STR_R3F_LOG_deverrouillage_en_cours, _duree];
	_ctrl_titre ctrlCommit 0;
	
	// Création de l'arrière-plan de la jauge dans le display du jeu
	_ctrl_fond = (findDisplay 46) ctrlCreate ["RscText", -1];
	_ctrl_fond ctrlSetBackgroundColor [0, 0, 0, 0.4];
	_ctrl_fond ctrlSetPosition [0.5 - 0.5*_JAUGE_W, _JAUGE_Y, _JAUGE_W, _JAUGE_H];
	_ctrl_fond ctrlCommit 0;
	
	// Création d'une jauge à 0% dans le display du jeu
	_ctrl_jauge = (findDisplay 46) ctrlCreate ["RscText", -1];
	_ctrl_jauge ctrlSetBackgroundColor [0, 0.6, 0, 1];
	_ctrl_jauge ctrlSetPosition [0.5 - 0.5*_JAUGE_W, _JAUGE_Y, 0, _JAUGE_H];
	_ctrl_jauge ctrlCommit 0;
	
	// La jauge passe progressivement de 0% à 100%
	_ctrl_jauge ctrlSetPosition [0.5 - 0.5*_JAUGE_W, _JAUGE_Y, _JAUGE_W, _JAUGE_H];
	_ctrl_jauge ctrlCommit _duree;
	*/
	_time_debut = time;
	_attente_valide = true;
	
	while {_attente_valide && time - _time_debut < _duree} do
	{
		//_ctrl_titre ctrlSetText format [STR_R3F_LOG_deverrouillage_en_cours, ceil (_duree - (time - _time_debut))];
		
		_cursorTarget_distance = call R3F_LOG_FNCT_3D_cursorTarget_distance_bbox;
		
		// Pour valider le déverrouillage, il faut maintenir la visée l'objet pendant le compte-à-rebours
		if (!alive player || _cursorTarget_distance select 0 != _objet || _cursorTarget_distance select 1 > 5) then
		{
			_attente_valide = false;
		};
		
		sleep 0.1;
	};
	
	//ctrlDelete _ctrl_titre;
	//ctrlDelete _ctrl_fond;
	//ctrlDelete _ctrl_jauge;
	
	if (_attente_valide) then
	{
		// Mise à jour du propriétaire du verrou
		[_objet, player] call R3F_LOG_FNCT_definir_proprietaire_verrou;
		
		systemChat STR_R3F_LOG_deverrouillage_succes_attente;
	}
	else
	{
		hintC STR_R3F_LOG_deverrouillage_echec_attente;
	};
	
	R3F_LOG_mutex_local_verrou = false;
};