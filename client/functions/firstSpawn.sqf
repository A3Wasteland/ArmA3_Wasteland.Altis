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
					_m = createVehicle ["Land_Money_F", player call fn_getPos3D, [], 0.5, "CAN_COLLIDE"];
					_m setVariable ["cmoney", player getVariable "cmoney", true];
					_m setVariable ["owner", "world", true];
					player setVariable ["cmoney", 0, true];
				};
			};
			
			_vehicle setVariable ["A3W_storeSellBox_track", nil];
		}];
	};
}];

player addEventHandler ["WeaponDisassembled",
{
	_this spawn
	{
		_unit = _this select 0;
		_bag1 = _this select 1;
		_bag2 = _this select 2;

		_currBag = unitBackpack _unit;

		titleText ['You are not allowed to disassemble static weapons.\nUse the "Move" option instead.', "PLAIN DOWN"];

		_this spawn
		{
			_bag1 = _this select 1;
			_bag2 = _this select 2;

			_bag1Cont = objNull;
			_bag2Cont = objNull;

			{
				if (_bag1 in everyBackpack _x) then { _bag1Cont = _x };
				if (_bag2 in everyBackpack _x) then { _bag2Cont = _x };
			} forEach nearestObjects [player, ["GroundWeaponHolder"], 10];

			_bag1Cont hideObjectGlobal true;
			_bag2Cont hideObjectGlobal true;
		};

		_unit action ["TakeBag", _bag1];

		if (isNull _currBag) then
		{
			_time = time;
			waitUntil {unitBackpack _unit == _bag1 || time - _time > 3};
		};

		_unit action ["Assemble", _bag2];

		if (!isNull _currBag) then { _unit action ["TakeBag", _currBag] };
	};
}];

// Manual GetIn/GetOut check because BIS is too lazy to implement GetInMan/GetOutMan, among a LOT of other things
[] spawn
{
	_lastVeh = vehicle player;

	while {true} do
	{
		_currVeh = vehicle player;

		if (_lastVeh != _currVeh) then
		{
			if (_currVeh != player) then
			{
				[_currVeh] call getInVehicle;
			}
			else
			{
				[_lastVeh] call getOutVehicle;
			};
		};

		_lastVeh = _currVeh;
		sleep 0.25;
	};
};

{
	player setVariable ["A3W_hitPoint_" + getText (_x >> "name"), configName _x];
} forEach ((typeOf player) call getHitPoints);

player addEventHandler ["HandleDamage", unitHandleDamage];

if (["A3W_combatAbortDelay", 0] call getPublicVar > 0) then
{
	player addEventHandler ["FiredNear",
	{
		// Don't prevent aborting when explosives are being placed
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

_startTime = diag_tickTime;
waitUntil {sleep 1; diag_tickTime - _startTime >= 180};

if (playerSide in [BLUFOR,OPFOR]) then
{
	if ({_x select 0 == getPlayerUID player} count pvar_teamSwitchList == 0) then
	{
		pvar_teamSwitchList set [count pvar_teamSwitchList, [getPlayerUID player, playerSide]];
		publicVariable "pvar_teamSwitchList";
		
		_side = switch (playerSide) do
		{
			case BLUFOR: { "BLUFOR" };
			case OPFOR:  { "OPFOR" };
			default      { "" };
		};
		
		titleText [format["You have been locked to %1",_side],"PLAIN",0];
	};
};
