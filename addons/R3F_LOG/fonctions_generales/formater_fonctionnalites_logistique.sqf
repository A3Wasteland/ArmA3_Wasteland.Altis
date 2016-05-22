/**
 * Affiche dans la zone "hint" les fonctionnalités logistique disponibles pour une classe donnée
 * 
 * @param 0 le nom de classe pour lequel consulter les fonctionnalités logistique
 * @return structuredText des fonctionnalités logistique
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_classe", "_fonctionnalites", "_side", "_places", "_infos", "_j", "_tab_inheritance_tree"];

_classe = _this select 0;

if !(isClass (configFile >> "CfgVehicles" >> _classe)) exitWith {};

_fonctionnalites = [_classe] call R3F_LOG_FNCT_determiner_fonctionnalites_logistique;

_side = switch (getNumber (configFile >> "CfgVehicles" >> _classe >> "side")) do
{
	case 0: {"EAST"};
	case 1: {"WEST"};
	case 2: {"GUER"};
	case 3: {"CIV"};
	default {"NONE"};
};

_places = 0;
if (!isNil "R3F_LOG_VIS_objet" && {!isNull R3F_LOG_VIS_objet && {typeOf R3F_LOG_VIS_objet == _classe}}) then
{
	{
		_places = _places + (R3F_LOG_VIS_objet emptyPositions _x);
	} forEach ["Commander", "Driver", "Gunner", "Cargo"];
};

_infos = "<t align='left'>";
_infos = _infos + format ["%1 : %2<br/>", STR_R3F_LOG_nom_fonctionnalite_side, _side];
if (_places != 0) then {_infos = _infos + format ["%1 : %2<br/>", STR_R3F_LOG_nom_fonctionnalite_places, _places]} else {_infos = _infos + "<br/>";};
_infos = _infos + "<br/>";
_infos = _infos + format ["%1<br/>", STR_R3F_LOG_nom_fonctionnalite_passif];
_infos = _infos + format ["<t color='%2'>- %1</t><br/>", STR_R3F_LOG_nom_fonctionnalite_passif_deplace, if (_fonctionnalites select R3F_LOG_IDX_can_be_moved_by_player) then {"#00eeff"} else {"#777777"}];
_infos = _infos + format ["<t color='%2'>- %1</t><br/>", STR_R3F_LOG_nom_fonctionnalite_passif_heliporte, if (_fonctionnalites select R3F_LOG_IDX_can_be_lifted) then {"#00ee00"} else {"#777777"}];
_infos = _infos + format ["<t color='%2'>- %1</t><br/>", STR_R3F_LOG_nom_fonctionnalite_passif_remorque, if (_fonctionnalites select R3F_LOG_IDX_can_be_towed) then {"#00ee00"} else {"#777777"}];
_infos = _infos + format ["<t color='%2'>- %1%3</t><br/>",
	STR_R3F_LOG_nom_fonctionnalite_passif_transporte,
	if (_fonctionnalites select R3F_LOG_IDX_can_be_transported_cargo) then {"#f5f500"} else {"#777777"},
	if (_fonctionnalites select R3F_LOG_IDX_can_be_transported_cargo) then {format [" (" + STR_R3F_LOG_nom_fonctionnalite_passif_transporte_capacite + ")", _fonctionnalites select R3F_LOG_IDX_can_be_transported_cargo_cout]} else {""}
];
_infos = _infos + "<br/>";
_infos = _infos + format ["%1<br/>", STR_R3F_LOG_nom_fonctionnalite_actif];
_infos = _infos + format ["<t color='%2'>- %1</t><br/>", STR_R3F_LOG_nom_fonctionnalite_actif_heliporte, if (_fonctionnalites select R3F_LOG_IDX_can_lift) then {"#00ee00"} else {"#777777"}];
_infos = _infos + format ["<t color='%2'>- %1</t><br/>", STR_R3F_LOG_nom_fonctionnalite_actif_remorque, if (_fonctionnalites select R3F_LOG_IDX_can_tow) then {"#00ee00"} else {"#777777"}];
_infos = _infos + format ["<t color='%2'>- %1%3</t><br/>",
	STR_R3F_LOG_nom_fonctionnalite_actif_transporte,
	if (_fonctionnalites select R3F_LOG_IDX_can_transport_cargo) then {"#f5f500"} else {"#777777"},
	if (_fonctionnalites select R3F_LOG_IDX_can_transport_cargo) then {format [" (" + STR_R3F_LOG_nom_fonctionnalite_actif_transporte_capacite + ")", _fonctionnalites select R3F_LOG_IDX_can_transport_cargo_cout]} else {""}
];
_infos = _infos + "</t>";

parseText _infos