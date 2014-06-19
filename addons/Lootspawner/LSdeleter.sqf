//	Lootspawner deleter script to remove old loot
//	Author: Na_Palm (BIS forums)
//-------------------------------------------------------------------------------------
private["_objlT","_countdel","_timedel","_objempty","_playersnear","_objisContainer","_objVar","_obj","_objlocked","_objclass"];

_objlT = _this;
while {true} do {
	_countdel = 0;
	//_timedel = diag_tickTime;
	{
		{
			_objempty = false;
			_playersnear = false;
			_objisContainer = false;
			//try to get local server Var "Lootready"
			_objVar = (_x getVariable "Lootready");
			//if "Lootready" NOT present then its not spawned by LS or in creation
			if (!isNil "_objVar") then {
				//check if lifetime is expired
				if ((diag_tickTime - _objVar) > _objlT) then {
					//if object has the var. "objectLocked", it belongs now to a player and therefor bad idea to delete it
					_objlocked = (_x getVariable "objectLocked");
					if(isNil "_objlocked") then {
						//case-insensitive
						_objclass = typeOf _x;
						if (({_x == _objclass} count exclcontainer_list) > 0) then {
							_objisContainer = true;
							if ((count ((getWeaponCargo _x) select 0)) == 0) then {
								if ((count ((getMagazineCargo _x) select 0)) == 0) then {
									if ((count ((getItemCargo _x) select 0)) == 0) then {
										if ((count ((getBackpackCargo _x) select 0)) == 0) then {
											_objempty = true;
										};
									};
								};
							};
						};
						_obj = _x;
						//check if any alive player is near
						{
							if ((isPlayer _x) && (alive _x)) then {
								if ((getPosASL _x) vectorDistance (getPosASL _obj) < 500)  then {
									_playersnear = true;
								};
							};
							sleep 0.001;
						}forEach playableUnits;
						//if (_objempty AND !_playersnear) OR (!_objisContainer AND !_playersnear) then delete
						if (((_objempty) && (!_playersnear)) || ((!_objisContainer) && (!_playersnear))) then {
							//diag_log format["-- DEBUG LOOTSPAWNER Delete item: %1:%2:%3 %4vLT%5v%6v for %7 v%8v%9%10v%11v --", _objisContainer, _objempty, _playersnear, _objVar, (diag_tickTime - _objVar), _objlT, (typeOf _x), ((getWeaponCargo _x) select 0), ((getMagazineCargo _x) select 0), ((getItemCargo _x) select 0), ((getBackpackCargo _x) select 0)];
							deleteVehicle _x;
							_countdel = _countdel + 1;
						};
					};
				};
			};
			_objVar = Nil;
			_objlocked = Nil;
			sleep 0.001;
		}forEach allMissionObjects _x;
		sleep 0.001;
	}forEach LSusedclass_list;
	if (_countdel > 0) then {
		diag_log format["-- LOOTSPAWNER deleted %1 objects --", _countdel];
	};
	sleep 60;
};
