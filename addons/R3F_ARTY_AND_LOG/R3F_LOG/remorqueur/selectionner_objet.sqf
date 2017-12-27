/**
 * Sélectionne un objet à remorquer
 *
 * @param 0 l'objet à sélectionner
 */

if (R3F_LOG_mutex_local_verrou) exitWith
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
};

private _objet = _this select 0;

if (unitIsUAV _objet && {!(_objet getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) && !(group (uavControl _objet select 0) in [grpNull, group player])}) then
{
	player globalChat STR_R3F_LOG_action_selectionner_objet_remorque_UAV_group;
}
else
{
	R3F_LOG_mutex_local_verrou = true;

	R3F_LOG_objet_selectionne = _objet;
	player globalChat format [STR_R3F_LOG_action_selectionner_objet_remorque_fait, getText (configFile >> "CfgVehicles" >> (typeOf R3F_LOG_objet_selectionne) >> "displayName")];

	R3F_LOG_mutex_local_verrou = false;
};
