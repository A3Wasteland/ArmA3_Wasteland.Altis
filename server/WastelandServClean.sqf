// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: WastelandServClean.sqf
//	@file Author: AgentRev, Wiking, JoSchaap

// runs every X minutes to cleanup items / wrecks

#define SLEEP_REALTIME(SECS) if (hasInterface) then { sleep (SECS) } else { uiSleep (SECS) }

if (!isServer && hasInterface) exitWith {};

// configure cleanup below this line

#define CLEANUP_INTERVAL (5*60) // Interval to run the cleanup
#define ITEM_CLEANUP_TIME (30*60) // Dropped player items cleanup time
#define MONEY_CLEANUP_TIME (60*60) // Dropped money cleanup time
#define STORE_CLEANUP_TIME (30*60) // Dropped store items cleanup time
#define STORE_CLEANUP_RADIUS 7.5 // Radius in meters to scan near store NPCs for dropped items
#define DEBRIS_CLEANUP_TIME (10*60) // Vehicle crash crater/debris cleanup time (actual vehicle wreck cleanup is handled through description.ext parameters)
#define GROUP_CLEANUP_TIME (1*60) // How long a group must have been empty before deleting it

// Corpse cleanup is handled through description.ext parameters

_objCleanup =
{
	private _obj = _x;
	private _processedDeath = _obj getVariable ["processedDeath", 0];
	private _timeLimit = if (isNil "_timeLimitOverride") then { [ITEM_CLEANUP_TIME, MONEY_CLEANUP_TIME] select (_obj getVariable ["cmoney",0] > 0) } else { _timeLimitOverride };

	if (_isWreck) then
	{
		if (_baseClass in ["UAV_01_base_F","UAV_06_base_F","UGV_02_Base_F"] && {fuel _obj > 0 || !isNull ((uavControl _obj) select 0)}) exitWith
		{
			if (_processedDeath > 0) then
			{
				_obj setVariable ["processedDeath", nil];
			};
		};

		_timeLimit = DEBRIS_CLEANUP_TIME;

		if (_processedDeath == 0) then
		{
			_obj setVariable ["processedDeath", call _serverTick];
		};

		if (_baseClass == "Ruins") then
		{
			if (!isNil "pvpfw_cleanUp_ruinRadius") then
			{
				_obj setVariable ["pvpfw_cleanup_InitTime", 1e11];
			};

			_processedDeath = 0;
		};
	};

	if (!isNil {_obj getVariable "Lootready"}) then
	{
		_processedDeath = 0;
	}
	else
	{
		if (!isNil "_isStoreCleanup" && _processedDeath <= 0) then
		{
			_obj setVariable ["processedDeath", call _serverTick];
		};
	};

	if (_processedDeath > 0) then
	{
		if (call _serverTick - _processedDeath >= _timeLimit) then
		{
			deleteVehicle _obj;
			_delQtyO = _delQtyO + 1;
		};
	};

	sleep 0.01;
};

_parachuteCleanup =
{
	if (count crew _x == 0 && isNull attachedTo _x) then
	{
		deleteVehicle _x;
		_delQtyO = _delQtyO + 1;
	};

	sleep 0.01;
};

_groupCleanup =
{
	private _grp = _x;
	private _processedDeath = _grp getVariable ["processedDeath", 0];

	if (count units _grp == 0) then
	{
		if (_processedDeath > 0) then
		{
			if (call _serverTick - _processedDeath >= GROUP_CLEANUP_TIME) then
			{
				if (local _grp) then
				{
					deleteGroup _grp;
				}
				else
				{
					[_grp] remoteExecCall ["A3W_fnc_deleteEmptyGroup", 2];
				};

				_delQtyG = _delQtyG + 1;
			};
		}
		else
		{
			_grp setVariable ["processedDeath", call _serverTick];
		};
	}
	else
	{
		if (_processedDeath != 0) then
		{
			_grp setVariable ["processedDeath", nil];
		};
	};

	sleep 0.01;
};

_entityCleanup =
{
	private _isWreck = false;
	call _objCleanup
};

_wreckCleanup =
{
	private _isWreck = true;
	call _objCleanup
};

_storeCleanup =
{
	private _isStoreCleanup = true;
	private _isWreck = false;
	private _timeLimitOverride = STORE_CLEANUP_TIME;
	call _objCleanup
};


_storeNPCs = allUnits select {[["GenStore","GunStore","VehStore"], vehicleVarName _x] call fn_startsWith};
_baseClass = "";

if (!isServer) then
{
	diag_log "WASTELAND HEADLESS - Object cleanup enabled";
};

_lastCleanup = diag_tickTime;

while {true} do
{
	SLEEP_REALTIME((CLEANUP_INTERVAL - (diag_tickTime - _lastCleanup)) max 1);

	_serverTick = if (isServer) then
	{
		{ diag_tickTime }
	}
	else // HC
	{
		A3W_serverTickTime = nil;

		while {isNil "A3W_serverTickTime"} do
		{
			[clientOwner] remoteExecCall ["A3W_fnc_requestTickTime", 2];

			_requestTime = diag_tickTime;
			waitUntil {!isNil "A3W_serverTickTime" || diag_tickTime - _requestTime >= 10}; // request every 10s
		};

		compile str A3W_serverTickTime
	};

	_lastCleanup = diag_tickTime;

	_delQtyO = 0;
	_entityCleanup forEach ([0,0] nearEntities ["All", 1e11]);
	{ private _baseClass = _x; _wreckCleanup forEach allMissionObjects _x } forEach ["CraterLong","Ruins","#destructioneffects","UAV_01_base_F","UAV_06_base_F"];
	{ _storeCleanup forEach nearestObjects [_x, ["GroundWeaponHolder"], STORE_CLEANUP_RADIUS] } forEach _storeNPCs;
	_parachuteCleanup forEach ([0,0] nearEntities ["ParachuteBase", 1e11]); // delete glitched parachutes

	diag_log format ["SERVER CLEANUP: Deleted %1 expired objects", _delQtyO];

	_delQtyG = 0;
	_groupCleanup forEach allGroups;

	diag_log format ["SERVER CLEANUP: Deleted %1 empty groups", _delQtyG];
};
