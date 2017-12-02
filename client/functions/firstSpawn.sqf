// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: firstSpawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 28/12/2013 19:42

client_firstSpawn = true;

[] execVM "client\functions\welcomeMessage.sqf";

player addEventHandler ["Take",
{
	_vehicle = _this select 1;

	if (_vehicle isKindOf "LandVehicle" && {!(_vehicle getVariable ["itemTakenFromVehicle", false])}) then
	{
		_vehicle setVariable ["itemTakenFromVehicle", true, true];
	};
}];

player addEventHandler ["Put",
{
	_vehicle = _this select 1;

	if (_vehicle getVariable ["A3W_storeSellBox", false] && isNil {_vehicle getVariable "A3W_storeSellBox_track"}) then
	{
		_vehicle setVariable ["A3W_storeSellBox_track", _vehicle spawn
		{
			_vehicle = _this;

			waitUntil {sleep 1; !alive player || player distance _vehicle > 25};

			_sellScript = [_vehicle, player, -1, [true, true]] execVM "client\systems\selling\sellCrateItems.sqf";
			waitUntil {sleep 0.1; scriptDone _sellScript};

			if (!alive player) then
			{
				sleep 0.5;

				if (player getVariable ["cmoney", 0] > 0) then
				{
					_m = createVehicle ["Land_Money_F", getPosATL player, [], 0.5, "CAN_COLLIDE"];
					_m setVariable ["cmoney", player getVariable "cmoney", true];
					_m setVariable ["owner", "world", true];
					player setVariable ["cmoney", 0, true];
					[_m] remoteExec ["A3W_fnc_setItemCleanup", 2];
				};
			};

			_vehicle setVariable ["A3W_storeSellBox_track", nil];
		}];
	};
}];

player addEventHandler ["WeaponDisassembled", { _this spawn weaponDisassembledEvent }];
player addEventHandler ["WeaponAssembled",
{
	params ["_player", "_obj"];
	_objClass = typeOf _obj;

	clearBackpackCargoGlobal _obj;
	clearMagazineCargoGlobal _obj;
	clearWeaponCargoGlobal _obj;
	clearItemCargoGlobal _obj;

	if (unitIsUAV _obj) then
	{
		// ownerUID handled thru save funcs

		_playerSide = side group _player;

		if (side _obj != _playerSide) then
		{
			(crew _obj) joinSilent createGroup _playerSide;
		};

		if (!alive getConnectedUAV _player) then
		{
			_player connectTerminalToUAV _obj;
		};

		[_obj, _playerSide, true] call fn_createCrewUAV;
		[_obj, _player, false] call A3W_fnc_takeOwnership;
	};
}];

player addEventHandler ["InventoryOpened",
{
	_obj = _this select 1;
	_blocked = false;

	if !(_obj isKindOf "Man") then
	{
		if (locked _obj > 1 || (_obj getVariable ["A3W_inventoryLockR3F", false] && _obj getVariable ["R3F_LOG_disabled", false])) then
		{
			if (_obj isKindOf "AllVehicles") then
			{
				["This vehicle is locked.", 5] call mf_notify_client;
			}
			else
			{
				["This object is locked.", 5] call mf_notify_client;
			};

			_blocked = true;
		};
	};

	if (!_blocked) then
	{
		if (!simulationEnabled _obj) then { _obj enableSimulation true };
		_obj setVariable ["inventoryIsOpen", true];
	};

	_blocked
}];

player addEventHandler ["InventoryClosed",
{
	_obj = _this select 1;
	_obj setVariable ["inventoryIsOpen", nil];
}];

[] spawn
{
	waitUntil
	{
		// Prevent usage of commander camera
		if (cameraView == "GROUP" && cameraOn in [player, vehicle player]) then
		{
			cameraOn switchCamera "EXTERNAL";
		};

		false
	};
};

player addEventHandler ["HandleDamage", unitHandleDamage];

if (["A3W_remoteBombStoreRadius", 0] call getPublicVar > 0) then
{
	player addEventHandler ["Fired",
	{
		// Remove explosives if within 100m of a store
		if (_this select 1 == "Put") then
		{
			_ammo = _this select 4;

			//if ({_ammo isKindOf _x} count ["PipeBombBase", "ClaymoreDirectionalMine_Remote_Ammo"] > 0) then // "touchable" remote explosives only
			if (_ammo isKindOf "TimeBombCore") then // all explosives
			{
				_mag = _this select 5;
				_bomb = _this select 6;
				_minDist = ["A3W_remoteBombStoreRadius", 100] call getPublicVar;

				{
					if (_x getVariable ["storeNPC_setupComplete", false] && {_bomb distance _x < _minDist}) exitWith
					{
						deleteVehicle _bomb;
						[player, _mag] call fn_forceAddItem;
						playSound "FD_CP_Not_Clear_F";
						titleText [format ["You are not allowed to place explosives within %1m of a store.\nThe explosive has been re-added to your inventory.", _minDist], "PLAIN DOWN", 0.5];
					};
				} forEach entities "CAManBase";
			};
		};
	}];
};

if (["A3W_combatAbortDelay", 0] call getPublicVar > 0) then
{
	player addEventHandler ["FiredNear",
	{
		// Prevent aborting if event is not for placing an explosive
		if (_this select 3 != "Put") then {
			combatTimestamp = diag_tickTime;
		};
	}];

	player addEventHandler ["Hit",
	{
		_source = effectiveCommander (_this select 1);
		if (!isNull _source && _source != player) then {
			combatTimestamp = diag_tickTime;
		};
	}];
};

player addEventHandler ["GetInMan", { [_this select 2] call getInVehicle }];
player addEventHandler ["GetOutMan", { [_this select 2] call getOutVehicle }];

_uid = getPlayerUID player;

if (playerSide in [BLUFOR,OPFOR] && {{_x select 0 == _uid} count pvar_teamSwitchList == 0}) then
{
	_startTime = diag_tickTime;
	waitUntil {sleep 1; diag_tickTime - _startTime >= 180};

	pvar_teamSwitchLock = [_uid, playerSide];
	publicVariableServer "pvar_teamSwitchLock";

	_side = switch (playerSide) do
	{
		case BLUFOR: { "BLUFOR" };
		case OPFOR:  { "OPFOR" };
	};

	titleText [format ["You have been locked to %1", _side], "PLAIN", 0.5];
};
