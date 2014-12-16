/**
 * Vérifie régulièrement des conditions portant sur l'objet pointé par l'arme du joueur
 * Permet de diminuer la fréquence des vérifications des conditions normalement faites dans les addAction (~60Hz)
 * La justification de ce système est que les conditions sont très complexes (count, nearestObjects)
 *
 * Copyright (C) 2010 madbull ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
private ["_objet_pointe", "_resetConditions"];

_resetConditions =
{
	R3F_LOG_action_deplacer_objet_valide = false;
	R3F_LOG_action_detacher_valide = false;
	R3F_LOG_action_charger_deplace_valide = false;
	R3F_LOG_action_charger_selection_valide = false;
	R3F_LOG_action_contenu_vehicule_valide = false;
	R3F_LOG_action_remorquer_deplace_valide = false;
	R3F_LOG_action_remorquer_selection_valide = false;
	R3F_LOG_action_selectionner_objet_remorque_valide = false;
	R3F_LOG_action_selectionner_objet_charge_valide = false;
	R3F_LOG_action_heliporter_valide = false;
	R3F_LOG_action_heliport_larguer_valide = false;
};

while {true} do
{
	R3F_LOG_objet_addAction = objNull;

	_objet_pointe = cursorTarget;

	if (vehicle player == player && {!isNull _objet_pointe} && {player distance _objet_pointe < 14} && {!local _objet_pointe || {[":-", netId _objet_pointe] call fn_findString == -1}}) then
	{
		R3F_LOG_objet_addAction = _objet_pointe;

		// Note : les expressions de conditions ne sont pas factorisées pour garder de la clarté (déjà que c'est pas vraiment ça) (et le gain serait minime)

		Object_canLock = !(_objet_pointe getVariable ['objectLocked', false]);

		// Si l'objet est un objet déplaçable
		if ({_objet_pointe isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
		{
			// Condition action deplacer_objet
			R3F_LOG_action_deplacer_objet_valide =
				count crew _objet_pointe == 0 &&
				isNull R3F_LOG_joueur_deplace_objet &&
				{!alive (_objet_pointe getVariable "R3F_LOG_est_deplace_par")} &&
				{isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par")} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};
		};

		if ({_objet_pointe isKindOf _x} count R3F_LOG_CFG_objets_remorquablesH > 0) then
		{
			// Condition action selectionner_objet_remorque
			R3F_LOG_action_selectionner_objet_remorque_valide =
				alive _objet_pointe &&
				isNull R3F_LOG_joueur_deplace_objet &&
				{isNull driver _objet_pointe ||
					{!isPlayer driver _objet_pointe && // allow UAV towing
					{getText (configFile >> "CfgVehicles" >> typeOf driver _objet_pointe >> "simulation") == "UAVPilot"}}} &&
				{isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par")} &&
				{!alive (_objet_pointe getVariable "R3F_LOG_est_deplace_par")} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};
			// Condition action detacher
			R3F_LOG_action_detacher_valide =
				isNull R3F_LOG_joueur_deplace_objet &&
				{!isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par")} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};
			// S'il est déplaçable
			if ({_objet_pointe isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
			{
				// Condition action remorquer_deplace
				R3F_LOG_action_remorquer_deplace_valide =
					alive R3F_LOG_joueur_deplace_objet &&
					{R3F_LOG_joueur_deplace_objet == _objet_pointe} &&
					{isNull driver _objet_pointe ||
						{!isPlayer driver _objet_pointe && // allow UAV towing
						{getText (configFile >> "CfgVehicles" >> typeOf driver _objet_pointe >> "simulation") == "UAVPilot"}}} &&
					{{
						alive _x &&
						_x != _objet_pointe &&
						{isNull (_x getVariable "R3F_LOG_remorque")} &&
						{vectorMagnitude velocity _x < 6} &&
						{(getPos _x) select 2 < 2} &&
						{!(_x getVariable "R3F_LOG_disabled")}
					} count nearestObjects [_objet_pointe, R3F_LOG_CFG_remorqueursALL, 18] > 0} &&
					{!(_objet_pointe getVariable "R3F_LOG_disabled")};
				if ({_objet_pointe isKindOf (_x select 0)} count R3F_LOG_CFG_objets_transportables > 0) then
				{
					// Disable towing on loadable objects
					R3F_LOG_action_selectionner_objet_remorque_valide = false;
				};
			};
		};
		// Si l'objet est un objet remorquable
		if ({_objet_pointe isKindOf _x} count R3F_LOG_CFG_objets_remorquables > 0) then
		{
			// Condition action selectionner_objet_remorque
			R3F_LOG_action_selectionner_objet_remorque_valide =
				alive _objet_pointe &&
				isNull R3F_LOG_joueur_deplace_objet &&
				{isNull driver _objet_pointe ||
					{!isPlayer driver _objet_pointe && // allow UAV towing
					{getText (configFile >> "CfgVehicles" >> typeOf driver _objet_pointe >> "simulation") == "UAVPilot"}}} &&
				{isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par")} &&
				{!alive (_objet_pointe getVariable "R3F_LOG_est_deplace_par")} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};

			// Condition action detacher
			R3F_LOG_action_detacher_valide =
				isNull R3F_LOG_joueur_deplace_objet &&
				{!isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par")} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};

			// S'il est déplaçable
			if ({_objet_pointe isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
			{
				// Condition action remorquer_deplace
				R3F_LOG_action_remorquer_deplace_valide =
					alive R3F_LOG_joueur_deplace_objet &&
					{R3F_LOG_joueur_deplace_objet == _objet_pointe} &&
					{isNull driver _objet_pointe ||
						{!isPlayer driver _objet_pointe && // allow UAV towing
						{getText (configFile >> "CfgVehicles" >> typeOf driver _objet_pointe >> "simulation") == "UAVPilot"}}} &&
					{{
						alive _x &&
						_x != _objet_pointe &&
						{isNull (_x getVariable "R3F_LOG_remorque")} &&
						{vectorMagnitude velocity _x < 6} &&
						{(getPos _x) select 2 < 2} &&
						{!(_x getVariable "R3F_LOG_disabled")}
					} count nearestObjects [_objet_pointe, R3F_LOG_CFG_remorqueursALL, 18] > 0} &&
					{!(_objet_pointe getVariable "R3F_LOG_disabled")};

				if ({_objet_pointe isKindOf (_x select 0)} count R3F_LOG_CFG_objets_transportables > 0) then
				{
					// Disable towing on loadable objects
					R3F_LOG_action_selectionner_objet_remorque_valide = false;
				};
			};
		};

		// Si l'objet est un objet transportable
		if ({_objet_pointe isKindOf _x} count R3F_LOG_classes_objets_transportables > 0) then
		{
			// Et qu'il est déplaçable
			if ({_objet_pointe isKindOf _x} count R3F_LOG_CFG_objets_deplacables > 0) then
			{
				// Condition action charger_deplace
				R3F_LOG_action_charger_deplace_valide =
					count crew _objet_pointe == 0 &&
					R3F_LOG_joueur_deplace_objet == _objet_pointe &&
					{{
						alive _x &&
						_x != _objet_pointe &&
						{vectorMagnitude velocity _x < 6} &&
						{(getPos _x) select 2 < 2} &&
						{!(_x getVariable "R3F_LOG_disabled")}
					} count nearestObjects [_objet_pointe, R3F_LOG_classes_transporteurs, 18] > 0} &&
					{!(_objet_pointe getVariable "R3F_LOG_disabled")};
			};

			// Condition action selectionner_objet_charge
			R3F_LOG_action_selectionner_objet_charge_valide =
				count crew _objet_pointe == 0 &&
				isNull R3F_LOG_joueur_deplace_objet &&
				{isNull (_objet_pointe getVariable "R3F_LOG_est_transporte_par")} &&
				{!alive (_objet_pointe getVariable "R3F_LOG_est_deplace_par")} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};
		};
		if ({_objet_pointe isKindOf _x} count R3F_LOG_CFG_remorqueursH > 0) then
		{
			// Condition action remorquer_deplace
			R3F_LOG_action_remorquer_deplace_valide =
				alive _objet_pointe &&
				alive R3F_LOG_joueur_deplace_objet &&
				{!(R3F_LOG_joueur_deplace_objet getVariable "R3F_LOG_disabled")} &&
				{{R3F_LOG_joueur_deplace_objet isKindOf _x} count R3F_LOG_CFG_objets_remorquablesH > 0} &&
				{isNull (_objet_pointe getVariable "R3F_LOG_remorque")} &&
				{vectorMagnitude velocity _objet_pointe < 6} &&
				{(getPos _objet_pointe) select 2 < 2} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")} &&
				{{_objet_pointe isKindOf (_x select 0)} count R3F_LOG_CFG_objets_transportables == 0};
			// Condition action remorquer_selection
			R3F_LOG_action_remorquer_selection_valide =
				alive _objet_pointe &&
				isNull R3F_LOG_joueur_deplace_objet &&
				!isNull R3F_LOG_objet_selectionne &&
				{R3F_LOG_objet_selectionne != _objet_pointe} &&
				{!(R3F_LOG_objet_selectionne getVariable "R3F_LOG_disabled")} &&
				{{R3F_LOG_objet_selectionne isKindOf _x} count R3F_LOG_CFG_objets_remorquablesH > 0} &&
				{isNull (_objet_pointe getVariable "R3F_LOG_remorque")} &&
				{vectorMagnitude velocity _objet_pointe < 6} &&
				{(getPos _objet_pointe) select 2 < 2} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};
		};

		// Si l'objet est un véhicule remorqueur
		if ({_objet_pointe isKindOf _x} count R3F_LOG_CFG_remorqueurs > 0) then
		{
			// Condition action remorquer_deplace
			R3F_LOG_action_remorquer_deplace_valide =
				alive _objet_pointe &&
				alive R3F_LOG_joueur_deplace_objet &&
				{!(R3F_LOG_joueur_deplace_objet getVariable "R3F_LOG_disabled")} &&
				{{R3F_LOG_joueur_deplace_objet isKindOf _x} count R3F_LOG_CFG_objets_remorquables > 0} &&
				{isNull (_objet_pointe getVariable "R3F_LOG_remorque")} &&
				{vectorMagnitude velocity _objet_pointe < 6} &&
				{(getPos _objet_pointe) select 2 < 2} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")} &&
				{{_objet_pointe isKindOf (_x select 0)} count R3F_LOG_CFG_objets_transportables == 0};

			// Condition action remorquer_selection
			R3F_LOG_action_remorquer_selection_valide =
				alive _objet_pointe &&
				isNull R3F_LOG_joueur_deplace_objet &&
				!isNull R3F_LOG_objet_selectionne &&
				{R3F_LOG_objet_selectionne != _objet_pointe} &&
				{!(R3F_LOG_objet_selectionne getVariable "R3F_LOG_disabled")} &&
				{{R3F_LOG_objet_selectionne isKindOf _x} count R3F_LOG_CFG_objets_remorquables > 0} &&
				{isNull (_objet_pointe getVariable "R3F_LOG_remorque")} &&
				{vectorMagnitude velocity _objet_pointe < 6} &&
				{(getPos _objet_pointe) select 2 < 2} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};
		};

		// Si l'objet est un véhicule transporteur
		if ({_objet_pointe isKindOf _x} count R3F_LOG_classes_transporteurs > 0) then
		{
			// Condition action charger_deplace
			R3F_LOG_action_charger_deplace_valide =
				alive _objet_pointe &&
				!isNull R3F_LOG_joueur_deplace_objet &&
				{R3F_LOG_joueur_deplace_objet != _objet_pointe} &&
				{!(R3F_LOG_joueur_deplace_objet getVariable "R3F_LOG_disabled")} &&
				{{R3F_LOG_joueur_deplace_objet isKindOf _x} count R3F_LOG_classes_objets_transportables > 0} &&
				{vectorMagnitude velocity _objet_pointe < 6} &&
				{(getPos _objet_pointe) select 2 < 2} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};

			// Condition action charger_selection
			R3F_LOG_action_charger_selection_valide =
				alive _objet_pointe &&
				isNull R3F_LOG_joueur_deplace_objet &&
				!isNull R3F_LOG_objet_selectionne &&
				{R3F_LOG_objet_selectionne != _objet_pointe} &&
				{!(R3F_LOG_objet_selectionne getVariable "R3F_LOG_disabled")} &&
				{{R3F_LOG_objet_selectionne isKindOf _x} count R3F_LOG_classes_objets_transportables > 0} &&
				{vectorMagnitude velocity _objet_pointe < 6} &&
				{(getPos _objet_pointe) select 2 < 2} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};

			// Condition action contenu_vehicule
			R3F_LOG_action_contenu_vehicule_valide =
				alive _objet_pointe &&
				isNull R3F_LOG_joueur_deplace_objet &&
				{vectorMagnitude velocity _objet_pointe < 6} &&
				{(getPos _objet_pointe) select 2 < 2} &&
				{!(_objet_pointe getVariable "R3F_LOG_disabled")};
		};
	}
	else
	{
		call _resetConditions;
	};

	if ({(vehicle player) isKindOf _x} count R3F_LOG_CFG_heliporteursH > 0) then
	{
		R3F_LOG_objet_addAction = vehicle player;
		// On est dans le véhicule, on affiche pas les options de transporteur et remorqueur
		call _resetConditions;
		// Condition action heliporter
		R3F_LOG_action_heliporter_valide =
			driver R3F_LOG_objet_addAction == player &&
			{{_x != R3F_LOG_objet_addAction && {!(_x getVariable "R3F_LOG_disabled")}} count nearestObjects [R3F_LOG_objet_addAction, R3F_LOG_CFG_objets_heliportablesH, 15] > 0} &&
			{isNull (R3F_LOG_objet_addAction getVariable "R3F_LOG_heliporte")} &&
			{vectorMagnitude velocity R3F_LOG_objet_addAction < 6} &&
			{(getPos R3F_LOG_objet_addAction) select 2 > 1} &&
			{!(R3F_LOG_objet_addAction getVariable "R3F_LOG_disabled")};
		// Condition action heliport_larguer
		R3F_LOG_action_heliport_larguer_valide =
			driver R3F_LOG_objet_addAction == player &&
			{!isNull (R3F_LOG_objet_addAction getVariable "R3F_LOG_heliporte")} &&
			//{vectorMagnitude velocity R3F_LOG_objet_addAction < 15} &&
			//{(getPos R3F_LOG_objet_addAction) select 2 < 40} &&
			{!(R3F_LOG_objet_addAction getVariable "R3F_LOG_disabled")} &&
			{(getPosATL (R3F_LOG_objet_addAction getVariable "R3F_LOG_heliporte") select 2) >= 0};
	};
	// Pour l'héliportation, l'objet n'est plus pointé, mais on est dedans
	// Si le joueur est dans un héliporteur
	if ({(vehicle player) isKindOf _x} count R3F_LOG_CFG_heliporteurs > 0) then
	{
		R3F_LOG_objet_addAction = vehicle player;

		// On est dans le véhicule, on affiche pas les options de transporteur et remorqueur
		call _resetConditions;

		// Condition action heliporter
		R3F_LOG_action_heliporter_valide =
			driver R3F_LOG_objet_addAction == player &&
			{{_x != R3F_LOG_objet_addAction && {!(_x getVariable "R3F_LOG_disabled")}} count nearestObjects [R3F_LOG_objet_addAction, R3F_LOG_CFG_objets_heliportables, 15] > 0} &&
			{isNull (R3F_LOG_objet_addAction getVariable "R3F_LOG_heliporte")} &&
			{vectorMagnitude velocity R3F_LOG_objet_addAction < 6} &&
			{(getPos R3F_LOG_objet_addAction) select 2 > 1} &&
			{!(R3F_LOG_objet_addAction getVariable "R3F_LOG_disabled")};

		// Condition action heliport_larguer
		R3F_LOG_action_heliport_larguer_valide =
			driver R3F_LOG_objet_addAction == player &&
			{!isNull (R3F_LOG_objet_addAction getVariable "R3F_LOG_heliporte")} &&
			//{vectorMagnitude velocity R3F_LOG_objet_addAction < 15} &&
			//{(getPos R3F_LOG_objet_addAction) select 2 < 40} &&
			{!(R3F_LOG_objet_addAction getVariable "R3F_LOG_disabled")} &&
			{(getPosATL (R3F_LOG_objet_addAction getVariable "R3F_LOG_heliporte") select 2) >= 0};
	};

	sleep 0.3;
};
