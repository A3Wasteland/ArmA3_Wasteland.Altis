//	@file Version: 1.0
//	@file Name: onKilled.sqf
//	@file Author: [404] Deadbeat, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:19

_player = _this select 0;
_presumedKiller = effectiveCommander (_this select 1);
_killer = _player getVariable ["FAR_killerPrimeSuspect", objNull];

if (isNull _killer) then { _killer = _presumedKiller };
if (_killer == _player) then { _killer = objNull };

_killData = [_player, _killer, _presumedKiller];

if (isServer) then
{
	_killData spawn server_PlayerDied;
}
else
{
	PlayerCDeath = _killData;
	publicVariableServer "PlayerCDeath";
};

if (_player == player) then
{
	closeDialog 2001; // Close Gunstore
	closeDialog 2009; // Close Genstore
	closeDialog 5285; // Close Vehstore

	playerData_gear = ""; // Reset gear data
	//combatTimestamp = -1; // Reset abort timer
};

_player setVariable ["FAR_killerPrimeSuspect", nil];
_player setVariable ["FAR_killerVehicle", nil];
_player setVariable ["FAR_killerAmmo", nil];
_player setVariable ["FAR_killerSuspects", nil];

_money = _player getVariable ["cmoney", -1];

if (_money != 0) then
{
	// Drop money
	if (_money > 0) then
	{
		_m = createVehicle ["Land_Money_F", _player call fn_getPos3D, [], 0.5, "CAN_COLLIDE"];
		_m setVariable ["cmoney", _money, true];
		_m setVariable ["owner", "world", true];
	};

	_player setVariable ["cmoney", 0, true];
};

// Drop items
_itemsDroppedOnDeath = [];

{
	for "_i" from 1 to (_x select 1) do
	{
		_obj = (_x select 0) call mf_inventory_drop;
		[_itemsDroppedOnDeath, netId _obj] call BIS_fnc_arrayPush;
	};
} forEach call mf_inventory_all;

itemsDroppedOnDeath = _itemsDroppedOnDeath;
publicVariableServer "itemsDroppedOnDeath";

[_player, objNull] call mf_player_actions_refresh;


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
						[_suspects, _unt] call BIS_fnc_arrayPush;
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
