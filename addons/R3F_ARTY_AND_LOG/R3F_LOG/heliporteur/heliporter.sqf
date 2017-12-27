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

#define VEHICLE_UNLOCKED(VEH) (locked (VEH) < 2 || (VEH) getVariable ["ownerUID","0"] isEqualTo getPlayerUID player)

if (R3F_LOG_mutex_local_verrou) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;

	private ["_hasNoProhibitedCargo", "_heliporteur", "_objet"];

	_hasNoProhibitedCargo =
	{
		private _ammoCargo = getAmmoCargo _this;
		private _repairCargo = getRepairCargo _this;

		if (isNil "_ammoCargo" || {!finite _ammoCargo}) then { _ammoCargo = 0 };
		if (isNil "_repairCargo" || {!finite _repairCargo}) then { _repairCargo = 0 };

		(_ammoCargo <= 0 && _repairCargo <= 0)
	};

	_heliporteur = _this select 0;
	_objet = (nearestObjects [_heliporteur, R3F_LOG_CFG_objets_heliportables, 20]) select {_obj = _x; _x call _hasNoProhibitedCargo && (_heliporteur getVariable ["R3F_LOG_heliporteurH",false] || {{_obj isKindOf _x} count R3F_LOG_CFG_objets_heliportablesH == 0})};
	// Parce que l'héliporteur peut être un objet héliportable
	_objet = (_objet select {VEHICLE_UNLOCKED(_x) && !(_x getVariable "R3F_LOG_disabled")}) - [_heliporteur];

	if (count _objet > 0) then
	{
		_objet = _objet select 0;

		if !(_objet getVariable "R3F_LOG_disabled") then
		{
			if (unitIsUAV _objet && {!(_objet getVariable ["ownerUID","0"] isEqualTo getPlayerUID player) && !(group (uavControl _objet select 0) in [grpNull, group player])}) exitWith
			{
				player globalChat STR_R3F_LOG_action_heliporter_UAV_group;
			};

			if (isNull (_objet getVariable "R3F_LOG_est_transporte_par")) then
			{
				if ({isPlayer _x} count crew _objet == 0) then
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

							_heliBB = _heliporteur call fn_boundingBoxReal;
							_heliMinBB = _heliBB select 0;
							_heliMaxBB = _heliBB select 1;

							_objectBB = _objet call fn_boundingBoxReal;
							_objectMinBB = _objectBB select 0;
							_objectMaxBB = _objectBB select 1;

							_objectCenterX = (_objectMinBB select 0) + (((_objectMaxBB select 0) - (_objectMinBB select 0)) / 2);
							_objectCenterY = (_objectMinBB select 1) + (((_objectMaxBB select 1) - (_objectMinBB select 1)) / 2);

							_heliPos = _heliporteur modelToWorld [0,0,0];
							_objectPos = _objet modelToWorld [0,0,0];

							_minZ = (_heliMinBB select 2) - (_objectMaxBB select 2) - 0.5;

							// Attacher sous l'héliporteur au ras du sol
							[_objet, true] call fn_enableSimulationGlobal;
							_objet attachTo [_heliporteur,
							[
								0 - _objectCenterX,
								0 - _objectCenterY,
								/*((_objectPos select 2) - (_heliPos select 2) + 2) min*/ _minZ
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
