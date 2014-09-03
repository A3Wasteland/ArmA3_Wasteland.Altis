//	@file Version: 1.0
//	@file Name: onKilled.sqf
//	@file Author: [404] Deadbeat, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:19

_player = _this select 0;
_presumedKiller = effectiveCommander (_this select 1);
_killer = _player getVariable ["FAR_killerPrimeSuspect", objNull];

if (isNull _killer) then { _killer = _presumedKiller };
if (_killer == _player) then { _killer = objNull };

[_player, _killer, _presumedKiller] spawn
{
	if (isServer) then
	{
		_this call server_PlayerDied;
	}
	else
	{
		PlayerCDeath = _this;
		publicVariableServer "PlayerCDeath";
	};
};

if (_player == player) then
{
	closeDialog 2001; // Close Gunstore
	closeDialog 2009; // Close Genstore
	closeDialog 5285; // Close Vehstore
	uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; // close message boxes

	playerData_gear = ""; // Reset gear data
	//combatTimestamp = -1; // Reset abort timer
};

_player setVariable ["FAR_killerPrimeSuspect", nil];
_player setVariable ["FAR_killerVehicle", nil];
_player setVariable ["FAR_killerAmmo", nil];
_player setVariable ["FAR_killerSuspects", nil];

_player spawn
{
	_player = _this;

	_money = _player getVariable ["cmoney", 0];
	_player setVariable ["cmoney", 0, true];

	_items = [];
	{
		_id = _x select 0;
		_qty = _x select 1;
		_type = (_id call mf_inventory_get) select 4;

		_items pushBack [_id, _qty, _type];
		[_id, _qty] call mf_inventory_remove;
	} forEach call mf_inventory_all;

	// wait until corpse stops moving before dropping stuff
	waitUntil {(getPos _player) select 2 < 1 && vectorMagnitude velocity _player < 1};

	// Drop money
	if (_money > 0) then
	{
		_m = createVehicle ["Land_Money_F", getPosATL _player, [], 0.5, "CAN_COLLIDE"];
		_m setDir random 360;
		_m setVariable ["cmoney", _money, true];
		_m setVariable ["owner", "world", true];
	};

	// Drop items
	_itemsDroppedOnDeath = [];

	{
		_id = _x select 0;
		_qty = _x select 1;
		_type = _x select 2;

		for "_i" from 1 to _qty do
		{
			_obj = createVehicle [_type, getPosATL _player, [], 0.5, "CAN_COLLIDE"];
			_obj setDir random 360;
			_obj setVariable ["mf_item_id", _id, true];
			_itemsDroppedOnDeath pushBack netId _obj;
		};
	} forEach _items;

	itemsDroppedOnDeath = _itemsDroppedOnDeath;
	publicVariableServer "itemsDroppedOnDeath";
};

_player spawn fn_removeAllManagedActions;

// Same-side kills
if (_player == player && (playerSide == side _killer) && (player != _killer) && (vehicle player != vehicle _killer)) then
{
	// Handle teamkills
	if (playerSide in [BLUFOR,OPFOR]) then
	{
		if (_killer isKindOf "CAManBase") then
		{
			pvar_PlayerTeamKiller = _killer;
		}
		else
		{
			pvar_PlayerTeamKiller = objNull;

			/*_veh = (_killer);
			_trts = configFile >> "CfgVehicles" >> typeof _veh >> "turrets";
			_paths = [[-1]];
			if (count _trts > 0) then {
				for "_i" from 0 to (count _trts - 1) do {
					_trt = _trts select _i;
					_trts2 = _trt >> "turrets";
					_paths = _paths + [[_i]];
					for "_j" from 0 to (count _trts2 - 1) do {
						_trt2 = _trts2 select _j;
						_paths = _paths + [[_i, _j]];
					};
				};
			};
			_ignore = ["SmokeLauncher", "FlareLauncher", "CMFlareLauncher", "CarHorn", "BikeHorn", "TruckHorn", "TruckHorn2", "SportCarHorn", "MiniCarHorn", "Laserdesignator_mounted"];
			_suspects = [];
			{
				_weps = (_veh weaponsTurret _x) - _ignore;
				if(count _weps > 0) then {
					_unt = objNull;
					if(_x select 0 == -1) then {_unt = driver _veh;}
					else {_unt = _veh turretUnit _x;};
					if(!isNull _unt) then {
						_suspects pushBack _unt;
					};
				};
			} forEach _paths;

			if(count _suspects == 1) then {
				pvar_PlayerTeamKiller = _suspects select 0;
			};*/
		};
	}
	else // Compensate negative score for indie-indie kills
	{
		if (isPlayer _killer) then
		{
			requestCompensateNegativeScore = _killer;
			publicVariableServer "requestCompensateNegativeScore";
		};
	};
};

if (isPlayer pvar_PlayerTeamKiller) then
{
	publicVar_teamkillMessage = pvar_PlayerTeamKiller;
	publicVariable "publicVar_teamkillMessage";
};
