// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	Lootspawner deleter script to remove old loot
//	Author: Na_Palm (BIS forums), AgentRev
//-------------------------------------------------------------------------------------
_objLifetime = _this;

while {true} do
{
	_countDel = 0;

	{
		_objClass = _x;
		_objIsContainer = ({_x == _objClass} count exclcontainer_list > 0);

		{
			_obj = _x;
			_objEmpty = false;
			_playerNear = false;

			// try to get local server Var "Lootready"
			_objVar = _obj getVariable "Lootready";

			// if "Lootready" NOT present then its not spawned by LS or in creation
			if (!isNil "_objVar") then
			{
				// check if lifetime is expired
				if (diag_tickTime - _objVar > _objLifetime) then
				{
					// if object is locked, it belongs to a player and therefore bad idea to delete it
					if !(_obj getVariable ["objectLocked", false]) then
					{
						if (_objIsContainer) then
						{
							if (count weaponCargo _obj + count magazineCargo _obj + count itemCargo _obj + count backpackCargo _obj == 0) then
							{
								_objEmpty = true;
							};
						};

						// check if any player is near
						{
							if (isPlayer _x && _x distance _obj < 500) exitWith
							{
								_playerNear = true;
							};
							sleep 0.001;
						} forEach playableUnits;

						if ((!_objIsContainer || _objEmpty) && !_playerNear) then
						{
							deleteVehicle _x;
							_countDel = _countDel + 1;
						};
					};
				};
			};

			sleep 0.001;
		} forEach allMissionObjects _x;
	} forEach LSusedclass_list;

	if (_countDel > 0) then
	{
		diag_log format ["-- LOOTSPAWNER deleted %1 objects --", _countDel];
	};

	uiSleep 60;
};
