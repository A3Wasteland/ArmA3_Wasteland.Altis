/**
 * Détermine si un objet est verrouillé ou non pour un joueur donné
 * 
 * @param 0 l'objet pour lequel savoir s'il est verrouillé
 * @param 1 l'unité pour laquelle savoir si l'objet est verrouillé
 * 
 * @return true si l'objet est verrouillé, false sinon
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_objet", "_unite", "_objet_verrouille"];

_objet = _this select 0;
_unite = _this select 1;

_objet_verrouille = switch (R3F_LOG_CFG_lock_objects_mode) do
{
	case "side": {_objet getVariable ["R3F_LOG_proprietaire_verrou", side group _unite] != side group _unite};
	case "faction": {_objet getVariable ["R3F_LOG_proprietaire_verrou", faction _unite] != faction _unite};
	case "player": {_objet getVariable ["R3F_LOG_proprietaire_verrou", name _unite] != name _unite};
	case "unit": {_objet getVariable ["R3F_LOG_proprietaire_verrou", _unite] != _unite};
	default {false};
};

_objet_verrouille