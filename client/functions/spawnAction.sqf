//	@file Version: 1.0
//	@file Name: spawnAction.sqf
//	@file Author: [404] Deadbeat, [KoS] Bewilderbeest
//	@file Created: 20/11/2012 05:19
//	@file Args: [int(type of spawn)]

if (!isNil "spawnActionHandle" && {typeName spawnActionHandle == "SCRIPT"} && {!scriptDone spawnActionHandle}) exitWith {};

disableSerialization;
_ctrlButton = (_this select 0) select 0;

_params = +_this;
_params set [0, ctrlText _ctrlButton];

spawnActionHandle = _params spawn
{
	private ["_buttonText", "_switch", "_scriptHandle"];
	_buttonText = _this select 0;
	_switch = _this select 1;

	player allowDamage true;

	// Deal with money here
	_baseMoney = ["A3W_startingMoney", 100] call getPublicVar;
	_player setVariable ["cmoney", _baseMoney, true];

	[MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_add;
	[MF_ITEMS_WATER, 1] call mf_inventory_add;
	[MF_ITEMS_REPAIR_KIT, 1] call mf_inventory_add;

	switch (_switch) do 
	{
		case 0:
		{
			_scriptHandle = [] execVM "client\functions\spawnRandom.sqf";
			waitUntil {scriptDone _scriptHandle};
		};
		case 1:
		{
			if (showBeacons) then
			{ 	
				_scriptHandle = [_buttonText] execVM "client\functions\spawnOnBeacon.sqf";
				waitUntil {scriptDone _scriptHandle};
			}
			else
			{
				_scriptHandle = [_buttonText] execVM "client\functions\spawnInTown.sqf";
				waitUntil {scriptDone _scriptHandle};
			}; 
		};
	};

	if (isNil "client_firstSpawn") then
	{
		execVM "client\functions\firstSpawn.sqf";
	};
};

disableSerialization;

private ["_ctrlButton", "_btnText", "_spawnActionHandle"];
_ctrlButton = (_this select 0) select 0;

if (!isNull _ctrlButton) then
{
	_btnText = ctrlText _ctrlButton;
	_ctrlButton ctrlSetText "Please wait...";
};

if (typeName spawnActionHandle == "SCRIPT") then
{
	_spawnActionHandle = spawnActionHandle;
	waitUntil {scriptDone _spawnActionHandle};
	spawnActionHandle = nil;
};

if (!isNull _ctrlButton) then
{
	_ctrlButton ctrlSetText _btnText;
	_ctrlButton ctrlEnable true;
};
