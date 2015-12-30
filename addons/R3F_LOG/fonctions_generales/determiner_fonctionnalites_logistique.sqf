/**
 * Détermine les fonctionnalités logistique disponibles pour une classe donnée
 * 
 * @param 0 le nom de classe pour lequel déterminer les fonctionnalités logistique
 * 
 * @return 0 true si can_be_depl_heli_remorq_transp
 * @return 1 true si can_be_moved_by_player
 * @return 2 true si can_be_lifted
 * @return 3 true si can_be_towed
 * @return 4 true si can_be_transported_cargo
 * @return 5 true si can_lift
 * @return 6 true si can_tow
 * @return 7 true si can_transport_cargo
 * 
 * Copyright (C) 2014 Team ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_classe", "_tab_classe_heritage", "_config", "_idx"];
private ["_can_be_depl_heli_remorq_transp", "_can_lift", "_can_tow", "_can_transport_cargo", "_can_transport_cargo_cout"];
private ["_can_be_moved_by_player", "_can_be_lifted", "_can_be_towed", "_can_be_transported_cargo", "_can_be_transported_cargo_cout"];

_classe = _this select 0;

// Calcul de l'arborescence d'héritage
_tab_classe_heritage = [];
for [
	{_config = configFile >> "CfgVehicles" >> _classe},
	{isClass _config},
	{_config = inheritsFrom _config}
] do
{
	_tab_classe_heritage pushBack (toLower configName _config);
};

// Calcul des fonctionnalités

_can_be_depl_heli_remorq_transp = false;
{
	if (_x in R3F_LOG_objets_depl_heli_remorq_transp) exitWith {_can_be_depl_heli_remorq_transp = true;};
} forEach _tab_classe_heritage;

_can_be_moved_by_player = false;
_can_be_lifted = false;
_can_be_towed = false;
_can_be_transported_cargo = false;
_can_be_transported_cargo_cout = 0;

if (_can_be_depl_heli_remorq_transp) then
{
	{
		if (_x in R3F_LOG_CFG_can_be_moved_by_player) exitWith {_can_be_moved_by_player = true;};
	} forEach _tab_classe_heritage;
	
	{
		if (_x in R3F_LOG_CFG_can_be_lifted) exitWith {_can_be_lifted = true;};
	} forEach _tab_classe_heritage;
	
	{
		if (_x in R3F_LOG_CFG_can_be_towed) exitWith {_can_be_towed = true;};
	} forEach _tab_classe_heritage;
	
	{
		_idx = R3F_LOG_classes_objets_transportables find _x;
		if (_idx != -1) exitWith
		{
			_can_be_transported_cargo = true;
			_can_be_transported_cargo_cout = R3F_LOG_CFG_can_be_transported_cargo select _idx select 1;
		};
	} forEach _tab_classe_heritage;
};

_can_lift = false;
{
	if (_x in R3F_LOG_CFG_can_lift) exitWith {_can_lift = true;};
} forEach _tab_classe_heritage;

_can_tow = false;
{
	if (_x in R3F_LOG_CFG_can_tow) exitWith {_can_tow = true;};
} forEach _tab_classe_heritage;

_can_transport_cargo = false;
_can_transport_cargo_cout = 0;
{
	_idx = R3F_LOG_classes_transporteurs find _x;
	if (_idx != -1) exitWith
	{
		_can_transport_cargo = true;
		_can_transport_cargo_cout = R3F_LOG_CFG_can_transport_cargo select _idx select 1;
	};
} forEach _tab_classe_heritage;

// Cargo de capacité nulle
if (_can_transport_cargo_cout <= 0) then {_can_transport_cargo = false;};

// Retour des fonctionnalités
[
	_can_be_depl_heli_remorq_transp,
	_can_be_moved_by_player,
	_can_lift,
	_can_be_lifted,
	_can_tow,
	_can_be_towed,
	_can_transport_cargo,
	_can_transport_cargo_cout,
	_can_be_transported_cargo,
	_can_be_transported_cargo_cout
]