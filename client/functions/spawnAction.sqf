//	@file Version: 1.0
//	@file Name: spawnAction.sqf
//	@file Author: [404] Deadbeat, [KoS] Bewilderbeest, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args: [int(type of spawn)]

#define respawn_Content_Text 3401
#define respawn_Town_Button0 3403
#define respawn_Town_Button1 3404
#define respawn_Town_Button2 3405
#define respawn_Town_Button3 3406
#define respawn_Town_Button4 3407
#define respawn_Random_Button 3413
#define respawn_LoadTowns_Button 3414
#define respawn_LoadBeacons_Button 3415

disableSerialization;

if (!isNil "spawnActionHandle" && {typeName spawnActionHandle == "SCRIPT"} && {!scriptDone spawnActionHandle}) exitWith {};

spawnActionHandle = [_this select 1, _this select 2] spawn
{
	private ["_switch", "_data"];
	_switch = _this select 0;
	_data = _this select 1;

	player allowDamage true;

	// Deal with money here
	_baseMoney = ["A3W_startingMoney", 100] call getPublicVar;
	player setVariable ["cmoney", _baseMoney, true];

	[MF_ITEMS_CANNED_FOOD, 1] call mf_inventory_add;
	[MF_ITEMS_WATER, 1] call mf_inventory_add;
	[MF_ITEMS_REPAIR_KIT, 1] call mf_inventory_add;

	switch (_switch) do 
	{
		case 1:
		{
			_scriptHandle = _data execVM "client\functions\spawnInTown.sqf";
			waitUntil {sleep 0.1; scriptDone _scriptHandle};
		};
		case 2:
		{
			_scriptHandle = _data execVM "client\functions\spawnOnBeacon.sqf";
			waitUntil {sleep 0.1; scriptDone _scriptHandle};
		};
		default
		{
			_scriptHandle = [] execVM "client\functions\spawnRandom.sqf";
			waitUntil {sleep 0.1; scriptDone _scriptHandle};
		};
	};

	if (isNil "client_firstSpawn") then
	{
		execVM "client\functions\firstSpawn.sqf";
	};
};

private ["_ctrlButton", "_header", "_spawnActionHandle"];
_header = (uiNamespace getVariable "RespawnSelectionDialog") displayCtrl respawn_Content_Text;
//_ctrlButton = (uiNamespace getVariable "RespawnSelectionDialog") displayCtrl (_this select 0);

//if (!isNull _ctrlButton) then
//{
	_header ctrlSetStructuredText parseText "<t size='0.5'>�<br/></t><t size='1.33'>Preloading spawn...</t>";
//};

if (typeName spawnActionHandle == "SCRIPT") then
{
	_spawnActionHandle = spawnActionHandle;
	waitUntil {scriptDone _spawnActionHandle};
	spawnActionHandle = nil;
};

//if (!isNull _ctrlButton) then
//{
	_header ctrlSetStructuredText parseText "It appears there was an error,<br/>please try again.";
	{
		ctrlEnable [_x, true];
	} forEach [respawn_Random_Button, respawn_LoadTowns_Button, respawn_LoadBeacons_Button, respawn_Town_Button0, respawn_Town_Button1, respawn_Town_Button2, respawn_Town_Button3, respawn_Town_Button4];
//};
