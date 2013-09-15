/**
 * Fait déplacer un objet par le joueur. Il garde l'objet tant qu'il ne le relâche pas ou ne meurt pas.
 * L'objet est relaché quand la variable R3F_LOG_joueur_deplace_objet passe à objNull ce qui terminera le script
 * 
 * @param 0 l'objet à déplacer
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

_currentAnim =	animationState player;
_config = configFile >> "CfgMovesMaleSdr" >> "States" >> _currentAnim;
_onLadder =	(getNumber (_config >> "onLadder"));
if(_onLadder == 1) exitWith{player globalChat "You can't move this object while on a ladder";};

if (R3F_LOG_mutex_local_verrou) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	R3F_LOG_objet_selectionne = objNull;
	
	private ["_objet", "_est_calculateur", "_arme_principale", "_arme_principale_accessoires", "_arme_principale_magasines", "_action_menu_release_relative", "_action_menu_release_horizontal" , "_action_menu_45", "_action_menu_90", "_action_menu_180", "_azimut_canon", "_muzzles", "_magazine", "_ammo", "_adjustPOS"];
	
	_objet = _this select 0;
	if(isNil {_objet getVariable "R3F_Side"}) then {
		_objet setVariable ["R3F_Side", (playerSide), true];
	};
	_tempVar = false;
	if(!isNil {_objet getVariable "R3F_Side"}) then {
		if(playerSide != (_objet getVariable "R3F_Side")) then {
			{if(side _x ==  (_objet getVariable "R3F_Side") && alive _x && _x distance _objet < 150) exitwith {_tempVar = true;};} foreach AllUnits;
		};
	};
	if(_tempVar) exitwith {
		hint format["This object belongs to %1 and they're nearby you cannot take this.", _objet getVariable "R3F_Side"]; R3F_LOG_mutex_local_verrou = false;
	};
	_objet setVariable ["R3F_Side", (playerSide), true];
	
	// Si l'objet est un calculateur d'artillerie, on laisse le script spécialisé gérer
	_est_calculateur = _objet getVariable "R3F_ARTY_est_calculateur";
	if !(isNil "_est_calculateur") then
	{
		R3F_LOG_mutex_local_verrou = false;
		[_objet] execVM "addons\R3F_ARTY_AND_LOG\R3F_ARTY\poste_commandement\deplacer_calculateur.sqf";
	}
	else
	{
		_objet setVariable ["R3F_LOG_est_deplace_par", player, true];
		
		R3F_LOG_joueur_deplace_objet = _objet;
		
		// Sauvegarde et retrait de l'arme primaire
		_arme_principale = primaryWeapon player;
		_arme_principale_accessoires = [];
		_arme_principale_magasines = [];
		
		if (_arme_principale != "") then
		{
			_arme_principale_accessoires = primaryWeaponItems player;
			
			player selectWeapon _arme_principale;
			_arme_principale_magasines set [count _arme_principale_magasines, [currentMagazine player, player ammo _arme_principale]];
			
			{ // add one mag for each muzzle
				if (_x != "this") then {
					player selectWeapon _x;
					_arme_principale_magasines set [count _arme_principale_magasines, [currentMagazine player, player ammo _x]];
				};
			} forEach getArray(configFile>>"CfgWeapons">>_arme_principale>>"muzzles");
			
			player playMove "AidlPercMstpSnonWnonDnon04";
			sleep 1;
			player removeWeapon _arme_principale;
		}
		else {sleep 0.5;};
		
		// Si le joueur est mort pendant le sleep, on remet tout comme avant
		if (!alive player) then
		{
			R3F_LOG_joueur_deplace_objet = objNull;
			_objet setVariable ["R3F_LOG_est_deplace_par", objNull, true];
			// Car attachTo de "charger" positionne l'objet en altitude :
			_objet setPos [getPos _objet select 0, getPos _objet select 1, 0];
			_objet setVelocity [0,0,0];
			
			R3F_LOG_mutex_local_verrou = false;
		}
		else
		{
			_objet attachTo [player, [
				0,
				(((boundingBox _objet select 1 select 1) max (-(boundingBox _objet select 0 select 1))) max ((boundingBox _objet select 1 select 0) max (-(boundingBox _objet select 0 select 0)))) + 1,
				1]
			];
			
			if (count (weapons _objet) > 0) then
			{
				// Le canon doit pointer devant nous (sinon on a l'impression de se faire empaler)
				_azimut_canon = ((_objet weaponDirection (weapons _objet select 0)) select 0) atan2 ((_objet weaponDirection (weapons _objet select 0)) select 1);
				
				// On est obligé de demander au serveur de tourner le canon pour nous
				R3F_ARTY_AND_LOG_PUBVAR_setDir = [_objet, (getDir _objet)-_azimut_canon];
				if (isServer) then
				{
					["R3F_ARTY_AND_LOG_PUBVAR_setDir", R3F_ARTY_AND_LOG_PUBVAR_setDir] spawn R3F_ARTY_AND_LOG_FNCT_PUBVAR_setDir;
				}
				else
				{
					publicVariable "R3F_ARTY_AND_LOG_PUBVAR_setDir";
				};
			};
			
			R3F_LOG_mutex_local_verrou = false;
			R3F_LOG_force_horizontally = false;
			
			_action_menu_release_relative = player addAction [("<img image=""client\icons\r3f_release.paa""/> <t color=""#06ef00"">" + STR_R3F_LOG_action_relacher_objet + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\objet_deplacable\relacher.sqf", false, 5, true, true];
			_action_menu_release_horizontal = player addAction [("<img image=""client\icons\r3f_releaseh.paa""/> <t color=""#06ef00"">" + STR_RELEASE_HORIZONTAL + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\objet_deplacable\relacher.sqf", true, 5, true, true];
			_action_menu_45 = player addAction [("<img image=""client\icons\r3f_rotate.paa""/> <t color=""#06ef00"">Rotate object 45°</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\objet_deplacable\rotate.sqf", 45, 5, true, true];
			//_action_menu_90 = player addAction [("<img image='client\ui\ui_arrow_combo_ca.paa' width='32' height='32'/> <t color=""#dddd00"">Rotate object 90°</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\objet_deplacable\rotate.sqf", 90, 5, true, true];
			//_action_menu_180 = player addAction [("<img image='client\ui\ui_arrow_combo_ca.paa' width='32' height='32'/> <t color=""#dddd00"">Rotate object 180°</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\objet_deplacable\rotate.sqf", 180, 5, true, true];
			
			// On limite la vitesse de marche et on interdit de monter dans un véhicule tant que l'objet est porté
			while {!isNull R3F_LOG_joueur_deplace_objet && alive player} do
			{
				if (vehicle player != player) then
				{
					player globalChat STR_R3F_LOG_ne_pas_monter_dans_vehicule;
					player action ["eject", vehicle player];
					sleep 1;
				};
				
				if ([0,0,0] distance [(velocity player) select 0,(velocity player) select 1,0] > 3.5) then
				{
					player globalChat STR_R3F_LOG_courir_trop_vite;					
					player playMove "AmovPpneMstpSrasWpstDnon";
					sleep 1;
				};
				
				sleep 0.25;
			};
			
			// L'objet n'est plus porté, on le repose
			detach _objet;

			// this addition comes from Sa-Matra (fixes the heigt of some of the objects) - all credits for this fix go to him!

			_adjustPOS=0;

			switch(typeOf _objet) do {
				case "Land_Scaffolding_F":
				{
					_adjustPOS=-3; 
				};
				case "Land_Canal_WallSmall_10m_F":
				{
					_adjustPOS=3;
				};
				case "Land_Canal_Wall_Stairs_F":
				{
					_adjustPOS=3;
				};
			};

			if(R3F_LOG_force_horizontally) then {
				R3F_LOG_force_horizontally = false;

				_opos = getPosASL _objet;
				_ppos = getPosASL player;
				_opos set [2, _ppos select 2];
				_opos2 = +_opos;
				_opos2 set [2, (_opos2 select 2)+ _adjustPOS];
				if(terrainIntersectASL [_opos, _opos2]) then {
					_objet setPosATL [getPosATL _objet select 0, getPosATL _objet select 1, getPosATL player select 2];
				} else {
					_objet setPosASL _opos;
				};
			} else {
				if((getPosATL player select 2) < 5) then {
					_objet setPos [getPos _objet select 0, getPos _objet select 1, (getPosATL player select 2)+_adjustPOS];
				} else {
					_objet setPosATL [getPosATL _objet select 0, getPosATL _objet select 1, (getPosATL player select 2)+_adjustPOS];
				};
			};
			
			_objet setVelocity [0,0,0];
			
			player removeAction _action_menu_release_relative;
			player removeAction _action_menu_release_horizontal;
			player removeAction _action_menu_45;
			//player removeAction _action_menu_90;
			//player removeAction _action_menu_180;
			R3F_LOG_joueur_deplace_objet = objNull;
			
			_objet setVariable ["R3F_LOG_est_deplace_par", objNull, true];
			
			// Restauration de l'arme primaire
			if (alive player && _arme_principale != "") then
			{
				if(primaryWeapon player != "") then {
					_o = createVehicle ["WeaponHolder", player modelToWorld [0,0,0], [], 0, "NONE"];
					_o addWeaponCargoGlobal [_arme_principale, 1];
				}
				else {
					{
						_magazine = _x select 0;
						_ammo = _x select 1;
						
						if(_magazine != "" && _ammo > 0) then {
							player addMagazine _x;
						};
					} forEach _arme_principale_magasines; // add all default primery weapon magazines
					
					player addWeapon _arme_principale;
					
					{ if(_x!="") then { player addPrimaryWeaponItem _x; }; } foreach (_arme_principale_accessoires);
					
					player selectWeapon _arme_principale;
					//player selectWeapon (getArray (configFile >> "cfgWeapons" >> _arme_principale >> "muzzles") select 0);
				};
			};
		};
	};
};
