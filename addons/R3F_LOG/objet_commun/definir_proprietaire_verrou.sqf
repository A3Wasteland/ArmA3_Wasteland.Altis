/**
 * Défini le propriétaire (side/faction/player) du verrou d'un objet
 * 
 * @param 0 l'objet pour lequel définir le propriétaire du verrou
 * @param 1 l'unité pour laquelle définir le verrou
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_objet", "_unite"];

_objet = _this select 0;
_unite = _this select 1;

// Si le verrou de l'objet ne correspond pas à l'unité, on redéfini sa valeur pour lui correspondre
if (isNil {_objet getVariable "R3F_LOG_proprietaire_verrou"} || {[_objet, _unite] call R3F_LOG_FNCT_objet_est_verrouille}) then
{
	switch (R3F_LOG_CFG_lock_objects_mode) do
	{
		case "side": {_objet setVariable ["R3F_LOG_proprietaire_verrou", side group _unite, true];};
		case "faction": {_objet setVariable ["R3F_LOG_proprietaire_verrou", faction _unite, true];};
		case "player": {_objet setVariable ["R3F_LOG_proprietaire_verrou", name _unite, true];};
		case "unit": {_objet setVariable ["R3F_LOG_proprietaire_verrou", _unite, true];};
	};
};