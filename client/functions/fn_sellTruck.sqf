// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_sellTruck.sqf
//	@file Author: Gigatek, Wiking, Lodac


#define SELL_TRUCK_DISTANCE 20
#define SELLTRUCK_PRICE_RELATIONSHIP 2


// Check if mutex lock is active.
if (mutexScriptInProgress) exitWith
{
	["You are already performing another action.", 5] call mf_notify_client;
};

mutexScriptInProgress = true;

_truck = _this select 0;
_unit = _this select 1;
_vehicle = vehicle _unit;

//check if caller is not in vehicle
if (_vehicle == _unit) exitWith
{
	["You must be in the driver seat to sell a vehicle.", 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

//set up prices
_vehClass = typeOf _vehicle;
_price = 5000; // price = 100 for vehicles not found in vehicle store.

{
	if (_vehClass == _x select 1) exitWith
	{
		_price = (ceil (((_x select 2) / SELLTRUCK_PRICE_RELATIONSHIP) / 5)) * 5;
	};
} forEach (call allVehStoreVehicles);

_text = format ["Stop engine in 10s to sell vehicle. $%1 for this vehicle. This will take some time.\nYou can always abort by getting out of the vehicle.", _price];
[_text, 5] call mf_notify_client;

uiSleep 10;

if (isEngineOn _vehicle) exitWith
{
	["Engine still running. Service CANCELLED!", 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

if (!local _vehicle) then
{
	_crew = crew _vehicle;
	_text = format ["Selling vehicle aborted by %1", if (count _crew > 0 && !isStreamFriendlyUIEnabled) then { name (_crew select 0) } else { "another player" }];
	[_text, 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

if (_vehicle distance _truck > SELL_TRUCK_DISTANCE || vehicle _unit != _vehicle) then
{
	if (_started) then { ["Vehicle resupply aborted", 5] call mf_notify_client };
	mutexScriptInProgress = false;
};

if (!isNil "_price") then 
{
	player setVariable["cmoney",(player getVariable "cmoney")+_price,true];
	player setVariable["timesync",(player getVariable "timesync")+(_price * 3),true];
	[] call fn_savePlayerData;
	["Dismantling will take about 1 minute.", 10] call mf_notify_client;
	_vehCfg = configFile >> "CfgVehicles" >> _vehClass;
	_vehName = getText (_vehCfg >> "displayName");
	_vehicle setFuel 0;
	_vehicle setVelocity [0,0,0];
	_text = format ["Selling %1 for $%2. Removing Engine, emptying fluids, and removing ammo.", _vehName, _price];
	[_text, 5] call mf_notify_client;
	sleep 5;
	["Chopping up vehicle.", 5] call mf_notify_client;
	_vehicle animate ["HideBackpacks", 1];
	sleep 1;
	_vehicle animate ["HideBumper1", 1];
	sleep 1;
	_vehicle animate ["HideBumper2", 1];
	sleep 1;
	_vehicle animate ["HideDoor1", 1];
	sleep 1;		
	_vehicle animate ["HideDoor2", 1];
	sleep 1;
	_vehicle animate ["HideDoor3", 1];
	sleep 1;
	deleteVehicle _vehicle;

	_text = format ["%1 has been chopped.", _vehName];
	[_text, 10] call mf_notify_client;
	mutexScriptInProgress = false;
}
else
{
	["Unknown Error", 10] call mf_notify_client;
	mutexScriptInProgress = false;
};
