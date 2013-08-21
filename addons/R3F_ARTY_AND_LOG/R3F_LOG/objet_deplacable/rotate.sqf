/*
	@file Author: [404] Costlyy
	@file Version: 1.0
   	@file Date:	20/11/2012	
	@file Description: Rotates an object by x degrees depending on args
	@file Args: [rotation amount(int)]
*/

private ["_currDirection", "_targetDirection", "_rotateAmount"];

_rotateAmount = _this select 3;
_targetDirection = "";

if (R3F_LOG_mutex_local_verrou) then {
	player globalChat STR_R3F_LOG_mutex_action_en_cours; // French crap
} else {
	_targetDirection = (getDir R3F_LOG_joueur_deplace_objet) + _rotateAmount; // Get the direction of the object and increment by _rotateAmount
	_targetDirection = _targetDirection - getDir player;

	R3F_LOG_joueur_deplace_objet setDir _targetDirection;
	R3F_ARTY_AND_LOG_PUBVAR_setDir = [R3F_LOG_joueur_deplace_objet, _targetDirection];
	publicVariable "R3F_ARTY_AND_LOG_PUBVAR_setDir";
	R3F_LOG_mutex_local_verrou = false;
};





